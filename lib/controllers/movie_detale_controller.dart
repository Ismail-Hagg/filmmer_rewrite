import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie_detale_model.dart';
import '../pages/trailer_page/trailer_page.dart';
import 'home_controller.dart';
import 'watchlist_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../helper/constants.dart';
import '../helper/utils.dart';
import '../local_storage/local_data_pref.dart';
import '../local_storage/local_database.dart';
import '../models/comment_model.dart';
import '../models/fire_upload.dart';
import '../models/image_model.dart';
import '../models/profile_model.dart';
import '../models/trailer_model.dart';
import '../models/user_model.dart';
import '../pages/profile_page/profile_page.dart';
import '../pages/sub_comment/sub_comment_page.dart';
import '../services/cast_service.dart';
import '../services/episode_keeping_service.dart';
import '../services/firestore_services.dart';
import '../services/image_service.dart';
import '../services/movie_detale_service.dart';
import '../services/recommendation_srevice.dart';
import '../services/trailer_service.dart';
import '../widgets/image_network.dart';
import 'favorites_controller.dart';

class MovieDetaleController extends GetxController {
  final UserModel _userModel = Get.find<HomeController>().userModel;
  UserModel get userModel => _userModel;
  FocusNode myFocusNode = FocusNode();
  late MovieDetaleModel _detales;
  MovieDetaleModel get detales => _detales;

  List<CommentModel> _commentsList = [];
  List<CommentModel> get commentsList => _commentsList;

  late Stream<QuerySnapshot> _commentStream;
  Stream<QuerySnapshot> get commentStream => _commentStream;

  final TextEditingController _txtControlller = TextEditingController();
  TextEditingController get txtControlller => _txtControlller;

  TrailerModel _trailer = TrailerModel();

  int _commentLoader = 0;
  int get commentLoader => _commentLoader;
  TrailerModel get trailer => _trailer;

  ImagesModel _imageModel = ImagesModel();
  ImagesModel get imageModel => _imageModel;

  int _loader = 0;
  int get loader => _loader;

  int _imagesCounter = 0;

  int _heart = 0;
  int get heart => _heart;

  int get imagesCounter => _imagesCounter;

  final dbHelper = DatabaseHelper.instance;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _detales = Get.arguments ?? MovieDetaleModel(isError: true);
    heartCheck();
    getData(res: _detales);
    _commentStream = FirestoreService()
        .commentStream(movieId: _detales.id.toString(), collection: 'Comments');
  }

  // call api to get images
  void getImages(
      {required double height,
      required double width,
      required bool isActor,
      required String id,
      required bool isIos}) async {
    if (_loader == 0) {
      _imageModel = ImagesModel();
      _imagesCounter = 1;
      update();
      Get.dialog(
        GetBuilder<MovieDetaleController>(
          init: Get.find<MovieDetaleController>(),
          builder: (build) => Center(
            child: _imagesCounter == 1
                ? isIos
                    ? CupertinoActivityIndicator(
                        color: orangeColor,
                        radius: width * 0.05,
                      )
                    : const CircularProgressIndicator(
                        color: orangeColor,
                      )
                : _imageModel.isError == false
                    ? CarouselSlider.builder(
                        options: CarouselOptions(
                            height: height * 0.6, enlargeCenterPage: true),
                        itemCount: _imageModel.links!.length,
                        itemBuilder: (context, index, realIndex) {
                          return ImageNetwork(
                            link: imagebase + _imageModel.links![index],
                            height: height * 0.95,
                            width: width * 0.8,
                            color: orangeColor,
                            fit: BoxFit.contain,
                            isMovie: true,
                            isShadow: false,
                          );
                        },
                      )
                    : isIos
                        ? CupertinoAlertDialog(
                            title: Text('noimage'.tr),
                            actions: [
                              CupertinoDialogAction(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    'ok'.tr,
                                  ))
                            ],
                          )
                        : AlertDialog(
                            title: Text('noimage'.tr),
                            actions: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: orangeColor,
                                ),
                                child: Text("answer".tr),
                                onPressed: () async => {
                                  Get.back(),
                                },
                              ),
                            ],
                          ),
          ),
        ),
      );
      ImagesService()
          .getImages(
              media: isActor
                  ? 'person'
                  : _detales.isShow == true
                      ? 'tv'
                      : 'movie',
              id: id,
              lang: _userModel.language
                  .toString()
                  .substring(0, _userModel.language.toString().indexOf('_')))
          .then((val) {
        _imageModel = val;
        _imagesCounter = 0;
        update();
      });
    }
  }

  // check if movie or show is in local database for favorites
  void heartCheck() async {
    await dbHelper
        .querySelect(
      DatabaseHelper.table,
      _detales.id.toString(),
    )
        .then((value) async {
      if (value.isEmpty) {
        _heart = 0;
      } else {
        _heart = 1;
      }
      update();
    });
  }

  // get data from api
  void getData({required MovieDetaleModel res}) async {
    _loader = 1;
    update();
    var lan = _userModel.language.toString().replaceAll('_', '-');
    var show = res.isShow == true ? 'tv' : 'movie';
    var base = 'https://api.themoviedb.org/3/$show/${res.id}';
    var end = '?api_key=$apiKey&language=$lan';
    List<String> slashes = ['', '/credits', '/recommendations', '/videos'];

    for (var i = 0; i < slashes.length; i++) {
      switch (i) {
        case 0:
          await MovieDetaleService()
              .getHomeInfo(link: '$base${slashes[i]}$end')
              .then((value) {
            if (value.isError == false) {
              _detales = value;
            }
          });
          break;
        case 1:
          await CastService()
              .getHomeInfo(link: '$base/${slashes[i]}$end')
              .then((value) => {_detales.cast = value});
          break;
        case 2:
          await RecommendationService()
              .getHomeInfo(link: '$base/${slashes[i]}$end')
              .then((value) => {
                    _detales.recomendation = value,
                  });
          break;
        case 3:
          await TrailerService()
              .getHomeInfo(link: '$base/${slashes[i]}$end')
              .then((value) => {_trailer = value});
          break;
      }
    }
    _loader = 0;
    update();
  }

  void uploadComment(
      {required String movieId,
      required String comment,
      required BuildContext context}) async {
    FocusScope.of(context).unfocus();

    if (comment != '') {
      _commentLoader = 1;
      update();
      var uuid = const Uuid();
      CommentModel commentModel = CommentModel(
          comment: comment,
          dislikeCount: 0,
          isPicOnline: _userModel.onlinePicPath == '' ? false : true,
          isSpoilers: false,
          isSub: false,
          likeCount: 0,
          pic: _userModel.onlinePicPath.toString(),
          postId: uuid.v4(),
          subComments: <Map<String, dynamic>>[],
          timeStamp: DateTime.now(),
          userId: _userModel.userId.toString(),
          userName: _userModel.userName.toString(),
          token: _userModel.messagingToken.toString());
      await FirestoreService()
          .addComment(
              model: commentModel,
              movieId: movieId,
              userId: _userModel.userId.toString())
          .then((value) => {
                _commentLoader = 0,
                txtControlller.clear(),
                commemtCount(
                  uid: _userModel.userId.toString(),
                  key: 'numberOfComments',
                ),
                update(),
                uploadRef(
                    uid: _userModel.userId.toString(),
                    movieId: movieId,
                    postId: value,
                    isSub: false)
              })
          .catchError((error) => {print('===>>>>    $error')});
    } else {
      txtControlller.clear();
    }
  }

  // add count of comments or replies to the user data only on firestore
  void commemtCount({required String uid, required String key}) async {
    await FirestoreService().getCurrentUser(userId: uid).then((value) async => {
          if ((value.data() as Map<dynamic, dynamic>)[key] == null)
            {
              await FirestoreService().userUpdate(
                  userId: uid, map: {key, '1'} as Map<String, dynamic>)
            }
          else
            {
              await FirestoreService().userUpdate(
                  userId: uid,
                  map: {
                    key,
                    (int.parse((value.data() as Map<dynamic, dynamic>)[key]) +
                            1)
                        .toString()
                  } as Map<String, dynamic>)
            }
        });
  }

  // upload a reference to the comment
  void uploadRef(
      {required String uid,
      required String movieId,
      required String postId,
      required bool isSub}) async {
    List<dynamic> lst = [];
    await FirestoreService().getCurrentUser(userId: uid).then((value) async {
      try {
        lst = value.get('ref');
        lst.add({
          'ref': FirebaseFirestore.instance
              .doc('Comments/$movieId/Comments/$postId'),
          'isSub': isSub
        });
        await FirestoreService().userUpdate(userId: uid, map: {'ref': lst});
      } catch (e) {
        FirestoreService().userUpdate(userId: uid, map: {
          'ref': [
            {
              'ref': FirebaseFirestore.instance
                  .doc('Comments/$movieId/Comments/$postId'),
              'isSub': isSub
            }
          ]
        });
      }
    });
  }

  // model the comments in the streambuilder
  void modelComments({required List<QueryDocumentSnapshot<Object?>> lst}) {
    _commentsList = [];
    if (lst.isNotEmpty) {
      for (var i = 0; i < lst.length; i++) {
        _commentsList
            .add(CommentModel.fromMap(lst[i].data() as Map<String, dynamic>));
        lst[i].get('comment');
      }
    }
  }

  // likes and dislikes on a comment
  void likeSystem(bool isLike, String postId, String movieId, String firePostId,
      int count) async {
    if (isLike) {
      var lst = userModel.commentLikes.toString().split(',');
      var other = userModel.commentsDislikes.toString().split(',');
      if (lst.contains(postId)) {
        // there is already a like so remove
        lst.remove(postId);
        _userModel.commentLikes = lst.join(',');
        saveLike(
            model: _userModel,
            key: 'commentLikes',
            value: _userModel.commentLikes.toString(),
            movieId: movieId,
            firePostId: firePostId,
            otherKey: 'likeCount',
            otherVal: count - 1);
      } else {
        // add a like
        // first if there's a dislike remove it
        if (other.contains(postId)) {
          other.remove(postId);
          _userModel.commentsDislikes = other.join(',');
          saveLike(
              model: _userModel,
              key: 'commentsDislikes',
              value: _userModel.commentsDislikes.toString(),
              movieId: movieId,
              firePostId: firePostId,
              otherKey: 'dislikeCount',
              otherVal: count - 1);
          lst.add(postId);
          _userModel.commentLikes = lst.join(',');
          saveLike(
              model: _userModel,
              key: 'commentLikes',
              value: _userModel.commentLikes.toString(),
              movieId: movieId,
              firePostId: firePostId,
              otherKey: 'likeCount',
              otherVal: count + 1);
        } else {
          // add a like
          lst.add(postId);
          _userModel.commentLikes = lst.join(',');
          saveLike(
              model: _userModel,
              key: 'commentLikes',
              value: _userModel.commentLikes.toString(),
              movieId: movieId,
              firePostId: firePostId,
              otherKey: 'likeCount',
              otherVal: count + 1);

          // notify user that someone liked his comment
        }
      }
    } else {
      var lst = userModel.commentsDislikes.toString().split(',');
      var other = userModel.commentLikes.toString().split(',');
      if (lst.contains(postId)) {
        // there is already a dislike so remove
        lst.remove(postId);
        _userModel.commentsDislikes = lst.join(',');
        saveLike(
            model: _userModel,
            key: 'commentsDislikes',
            value: _userModel.commentsDislikes.toString(),
            movieId: movieId,
            firePostId: firePostId,
            otherKey: 'dislikeCount',
            otherVal: count - 1);
      } else {
        // add a dislike
        // first if there's a like remove it
        if (other.contains(postId)) {
          other.remove(postId);
          _userModel.commentLikes = other.join(',');
          saveLike(
              model: _userModel,
              key: 'commentLikes',
              value: _userModel.commentsDislikes.toString(),
              movieId: movieId,
              firePostId: firePostId,
              otherKey: 'likeCount',
              otherVal: count + 1);
          lst.add(postId);
          _userModel.commentsDislikes = lst.join(',');
          saveLike(
              model: _userModel,
              key: 'commentsDislikes',
              value: _userModel.commentLikes.toString(),
              movieId: movieId,
              firePostId: firePostId,
              otherKey: 'dislikeCount',
              otherVal: count + 1);
        } else {
          lst.add(postId);
          _userModel.commentsDislikes = lst.join(',');
          saveLike(
              model: _userModel,
              key: 'commentsDislikes',
              value: _userModel.commentLikes.toString(),
              movieId: movieId,
              firePostId: firePostId,
              otherKey: 'dislikeCount',
              otherVal: count + 1);
        }
      }
    }
  }

  void saveLike(
      {required UserModel model,
      required String key,
      required String value,
      required String movieId,
      required String firePostId,
      required String otherKey,
      required dynamic otherVal}) async {
    await UserDataPref().setUser(model);
    update();
    await FirestoreService().userUpdate(userId: model.userId.toString(), map: {
      key: value
    }).then((value) async => {
          await FirestoreService().updateCommentData(
              movieId: movieId,
              postId: firePostId,
              key: otherKey,
              value: otherVal)
        });
  }

  // adding to and removing from local database and firestore
  void favouriteUpload({
    required BuildContext context,
  }) async {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    if (_loader == 0 && _detales.isError == false) {
      List<String> lst = [];

      for (var i = 0; i < _detales.genres!.length; i++) {
        lst.add(_detales.genres![i]);
      }

      FirebaseSend fire = FirebaseSend(
          posterPath: _detales.posterPath.toString(),
          overView: _detales.overview.toString(),
          voteAverage: _detales.voteAverage as double,
          name: _detales.title.toString(),
          isShow: _detales.isShow as bool,
          releaseDate: _detales.releaseDate.toString(),
          id: _detales.id.toString(),
          time: DateTime.now(),
          genres: lst);

      if (_heart == 0) {
        // adding to favourites locally and in firestore
        _heart = 1;
        // checking if we're coming from the favorites page
        if (Get.isRegistered<FavouritesController>() == true) {
          Get.find<FavouritesController>()
              .fromDetale(send: fire, addOrDelete: true);
        }
        await dbHelper
            .insert(fire.toMapLocal(), DatabaseHelper.table)
            .then((value) async {
          platformAlert(
              isIos: isIos, context: context, title: 'favadd'.tr, body: '');
          update();
          await FirestoreService().upload(
              userId: _userModel.userId.toString(), fire: fire, count: 0);
        });
      } else {
        _heart = 0;
        if (Get.isRegistered<FavouritesController>() == true) {
          Get.find<FavouritesController>()
              .fromDetale(send: fire, addOrDelete: false);
        }
        await dbHelper
            .delete(DatabaseHelper.table, fire.id)
            .then((value) async {
          platformAlert(
              isIos: isIos, context: context, title: 'favalready'.tr, body: '');
          update();
          await FirestoreService().upload(
              userId: _userModel.userId.toString(), fire: fire, count: 1);
        });
      }
    }
  }

  //add movie or show to watchlist
  void watch({required BuildContext context}) async {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    if (_loader == 0 && _detales.isError == false) {
      String table = _detales.isShow != true
          ? DatabaseHelper.movieTable
          : DatabaseHelper.showTable;
      await dbHelper
          .querySelect(table, _detales.id.toString())
          .then((value) async {
        if (value.isEmpty) {
          List<String> lst = [];
          String show = '';
          for (var i = 0; i < _detales.genres!.length; i++) {
            lst.add(_detales.genres![i]);
          }
          FirebaseSend fire = FirebaseSend(
              posterPath: _detales.posterPath.toString(),
              overView: _detales.overview.toString(),
              voteAverage: _detales.voteAverage as double,
              name: _detales.title.toString(),
              isShow: _detales.isShow as bool,
              releaseDate: _detales.releaseDate.toString(),
              id: _detales.id.toString(),
              time: DateTime.now(),
              genres: lst);
          fire.isShow == true ? show = 'show' : show = 'movie';

          await dbHelper.insert(fire.toMapLocal(), table).then((value) async {
            if (Get.isRegistered<WatchlistController>() == true) {
              Get.find<WatchlistController>()
                  .fromDetale(send: fire, isShow: fire.isShow);
            }
            platformAlert(
                isIos: isIos, context: context, title: 'watchadd'.tr, body: '');

            await FirestoreService().watchList(
                userId: _userModel.userId.toString(),
                fire: fire,
                isShow: show,
                count: 0);
          });
        } else {
          platformAlert(
              isIos: isIos,
              context: context,
              title: 'watchalready'.tr,
              body: '');
        }
      });
    }
  }

  // add to episode keeping
  void addKeeping({required BuildContext context}) async {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    FirestoreService()
        .ref
        .doc(_userModel.userId)
        .collection('episodeKeeping')
        .doc(_detales.id.toString())
        .get()
        .then((value) async {
      if (value.exists) {
        platformAlert(
            isIos: isIos, title: 'readykeep'.tr, body: '', context: context);
      } else {
        await EpisodeKeepingService()
            .getData(
                link:
                    'https://api.themoviedb.org/3/tv/${_detales.id}?api_key=$apiKey&language=',
                lan: _userModel.language.toString(),
                isFire: false)
            .then((value) async {
          if (value.isError == false) {
            value.token = _userModel.messagingToken;
            await FirestoreService()
                .addEpisode(uid: _userModel.userId.toString(), model: value)
                .then((thing) async {
              platformAlert(
                  isIos: isIos,
                  title: 'keepadd'.tr,
                  body: '',
                  context: context);
              // remove from firebase watchinglist and from local storage

              await FirestoreService()
                  .ref
                  .doc(_userModel.userId)
                  .collection('showWatchList')
                  .doc(value.id.toString())
                  .get()
                  .then((value) async {
                if (value.exists) {
                  await FirestoreService()
                      .delete(
                          uid: _userModel.userId.toString(),
                          id: value.id,
                          collection: 'showWatchList')
                      .then((nothing) async {
                    await dbHelper.delete('showTable', value.id);
                  });
                }
              });
            });
          } else {
            platformAlert(
                isIos: isIos,
                title: 'error'.tr,
                body: value.errorMessage.toString(),
                context: context);
          }
        });
      }
    });
  }

  //navigate to trailer page
  goToTrailer({required BuildContext context}) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    if (_loader == 0) {
      if (_trailer.results!.isEmpty) {
        platformAlert(
            isIos: isIos, title: 'trailer'.tr, body: '', context: context);
      } else {
        Get.to(() => const TrailerPage(), arguments: _trailer);
      }
    }
  }

  // go to profile page
  void goToProfile({required ProfileModel profile}) {
    Get.to(() => const ProfilePage(), arguments: profile);
  }

  // navigate to subcomment page
  void navToSubComment(
      {required MovieDetaleController controller,
      required String movieId,
      required String postId,
      required String firePostId,
      required String userId,
      required String token}) {
    Get.to(() => SubCommentPage(
        movieId: movieId,
        mainPostId: postId,
        firePostId: firePostId,
        pastController: controller,
        userId: userId,
        token: token));
  }

  // delete comments from
  void deleteComment(
      {required String movieId,
      required String postId,
      required BuildContext context}) async {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    platforMulti(
        buttonTitle: [
          'cancel'.tr,
          'answer'.tr,
        ],
        func: [
          () {
            Get.back();
          },
          () async {
            Get.back();
            await FirestoreService()
                .deleteComment(movieId: movieId, postId: postId);
          }
        ],
        isIos: isIos,
        title: 'deletecomment'.tr,
        body: 'deletecommentsure'.tr,
        context: context);
  }
}
