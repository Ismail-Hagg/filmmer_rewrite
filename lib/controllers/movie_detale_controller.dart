import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmmer_rewrite/controllers/home_controller.dart';
import 'package:filmmer_rewrite/models/movie_detale_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../helper/constants.dart';
import '../local_storage/local_data_pref.dart';
import '../local_storage/local_database.dart';
import '../models/comment_model.dart';
import '../models/image_model.dart';
import '../models/trailer_model.dart';
import '../models/user_model.dart';
import '../services/cast_service.dart';
import '../services/firestore_services.dart';
import '../services/image_service.dart';
import '../services/movie_detale_service.dart';
import '../services/recommendation_srevice.dart';
import '../services/trailer_service.dart';
import '../widgets/image_network.dart';

class MovieDetaleController extends GetxController {
  final UserModel _userModel = Get.find<HomeController>().userModel;
  UserModel get userModel => _userModel;
  final FocusNode myFocusNode = FocusNode();
  MovieDetaleModel _detales = Get.arguments ?? MovieDetaleModel();
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

  int _loader = 0;
  int get loader => _loader;

  int _imagesCounter = 0;

  int _heart = 0;
  int get heart => _heart;

  List<String> slashes = ['', 'credits', 'recommendations', 'videos'];

  int get imagesCounter => _imagesCounter;

  final dbHelper = DatabaseHelper.instance;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    heartCheck();
    getData(res: _detales);
    _commentStream = FirestoreService()
        .commentStream(movieId: _detales.id.toString(), collection: 'Comments');
  }

  // call api to get images
  void getImages(double height, double width, bool isActor, String id) async {
    if (_loader == 0) {
      ImagesModel model = ImagesModel();
      _imagesCounter = 1;
      update();
      Get.dialog(
        Center(
          child: _imagesCounter == 1
              ? const CircularProgressIndicator(
                  color: orangeColor,
                )
              : model.isError == false
                  ? CarouselSlider.builder(
                      options: CarouselOptions(
                          height: height * 0.6, enlargeCenterPage: true),
                      itemCount: model.links!.length,
                      itemBuilder: (context, index, realIndex) {
                        return ImageNetwork(
                          link: imagebase + model.links![index],
                          height: height * 0.95,
                          width: width * 0.8,
                          color: orangeColor,
                          fit: BoxFit.contain,
                          isMovie: true,
                          isShadow: false,
                        );
                      },
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
        model = val;
        _imagesCounter = 0;
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

    for (var i = 0; i < slashes.length; i++) {
      switch (i) {
        case 0:
          await MovieDetaleService()
              .getHomeInfo(link: '$base${slashes[i]}$end')
              .then((value) => {
                    if (value.isError == false) {_detales = value}
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
              .then((value) => {_detales.recomendation = value});
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

  void uploadComment({required String movieId, required String comment}) async {
    myFocusNode.unfocus();

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
              });
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
    FirestoreService().getCurrentUser(userId: uid).then((value) {
      try {
        lst = value.get('ref');
        lst.add({
          'ref': FirebaseFirestore.instance
              .doc('Comments/$movieId/Comments/$postId'),
          'isSub': isSub
        });
        FirestoreService()
            .userUpdate(userId: uid, map: {'ref', lst} as Map<String, dynamic>);
      } catch (e) {
        FirestoreService().userUpdate(
            userId: uid,
            map: {
              'ref',
              [
                {
                  'ref': FirebaseFirestore.instance
                      .doc('Comments/$movieId/Comments/$postId'),
                  'isSub': isSub
                }
              ]
            } as Map<String, dynamic>);
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
}
