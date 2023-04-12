import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:filmmer_rewrite/controllers/auth_controller.dart';
import 'package:filmmer_rewrite/models/search_move_model.dart';
import 'package:filmmer_rewrite/models/user_model.dart';
import 'package:filmmer_rewrite/pages/movie_detale_page/movie_detale_page_amdroid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/constants.dart';
import '../helper/utils.dart';
import '../local_storage/local_data_pref.dart';
import '../models/actor_model.dart';
import '../models/cast_model.dart';
import '../models/homepage_model.dart';
import '../models/movie_detale_model.dart';
import '../models/results_model.dart';
import '../pages/actorPage/actor_page.dart';
import '../pages/movie_detale_page/mocvie_detale_page.dart';
import '../pages/search_more_page/sewarch_more_page.dart';
import '../services/firebase_storage_service.dart';
import '../services/firestore_services.dart';
import '../services/home_page_service.dart';
import 'actor_controller.dart';
import 'movie_detale_controller.dart';

class HomeController extends GetxController {
  final BuildContext context;
  final bool isIos;
  HomeController({required this.context, required this.isIos});

  int _count = 0;
  int get count => _count;

  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;

  final HomePageModel _upcomingMovies =
      HomePageModel(results: [], isError: false);
  final HomePageModel _popularShows =
      HomePageModel(results: [], isError: false);
  final HomePageModel _popularMovies =
      HomePageModel(results: [], isError: false);
  final HomePageModel _topMovies = HomePageModel(results: [], isError: false);
  final HomePageModel _topShows = HomePageModel(results: [], isError: false);
  //MovieDetaleModel _movieDetales = MovieDetaleModel();

  HomePageModel get upcomingMovies => _upcomingMovies;
  HomePageModel get popularMovies => _popularMovies;
  HomePageModel get popularShows => _popularShows;
  HomePageModel get topMovies => _topMovies;
  HomePageModel get topShows => _topShows;
  //MovieDetaleModel get movieDetales => _movieDetales;

  final List<String> _urls = [upcoming, pop, popularTv, top, topTv];
  List<String> get urls => _urls;
  List<HomePageModel> _lists = [];
  List<HomePageModel> get lists => _lists;

  final List<String> _translation = [
    'upcoming'.tr,
    'popularMovies'.tr,
    'popularShows'.tr,
    'topMovies'.tr,
    'topShowa'.tr,
  ];
  List<String> get translation => _translation;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _lists = [
      _upcomingMovies,
      _popularMovies,
      _popularShows,
      _topMovies,
      _topShows
    ];
    loadUser();
    notify();
  }

  // load user's data
  void loadUser() async {
    await UserDataPref().getUserData().then((value) {
      if (value.isError == false) {
        _userModel = value;
        update();
        apiCall(language: _userModel.language.toString());
        uploadImage();
      } else {
        Get.find<AuthController>().signOut();
      }
    });
  }

  // call api
  void apiCall({required String language}) async {
    _count = 1;
    update();

    for (var i = 0; i < _urls.length; i++) {
      await HomePageService()
          .getHomeInfo(link: _urls[i], language: language)
          .then((value) {
        _lists[i].results = value.results;
      });
    }
    _count = 0;
    update();
  }

  // upload profile image to firebase storage
  void uploadImage() async {
    if (_userModel.isPicLocal == true && _userModel.onlinePicPath == '') {
      await FirebaseStorageService()
          .uploade(
              id: _userModel.userId.toString(),
              file: File(_userModel.localPicPath.toString()))
          .then((value) async {
        _userModel.onlinePicPath = value;
        await UserDataPref().setUser(_userModel);
        await FirestoreService().userUpdate(
            userId: _userModel.userId.toString(),
            map: {'onlinePicPath': value});
      }).catchError((e) {
        platformAlert(
            isIos: isIos,
            title: 'error'.tr,
            body: e.toString(),
            context: context);
      });
    }
  }

  // notoficatios permissions
  void notify() async {
    await AwesomeNotifications().isNotificationAllowed().then((value) async {
      if (value) {
        await AwesomeNotifications().initialize(
            null,
            [
              NotificationChannel(
                  ledColor: orangeColor,
                  playSound: true,
                  defaultColor: orangeColor,
                  channelKey: 'basic_channel',
                  channelName: 'Basic Notification',
                  channelDescription: 'describtion',
                  enableVibration: true,
                  importance: NotificationImportance.Max)
            ],
            debug: true);

        await AwesomeNotifications().setListeners(
          onActionReceivedMethod: onActionReceivedMethod,
        );
      }
    });
  }

  // navigate to search or more page
  void goToSearch(
      {required bool isSearch, required String link, required String title}) {
    Move moving = Move(isSearch: isSearch, link: link, title: title);
    Get.to(() => SearchMorePage(), arguments: moving);
  }

  // when notificatio is clicked
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // switch (map['action']) {
    //   case 'chat':
    //     Get.to(() => ChatPage(
    //         thing: ChatPageModel(
    //             userName: map['userNsme'],
    //             userId: map['userId'],
    //             fromList: true)));

    //     break;

    //   case 'episode':
    //     Get.to(() => EpisodeKeepingPage());

    //     break;

    //   case 'comments':
    //     Get.to(() => SubComment(
    //           movieId: map['movieId'].toString(),
    //           mainPostId: map['postId'].toString(),
    //           firePostId: map['firePostId'].toString(),
    //           pastController: MovieDetaleController(),
    //           token: '',
    //         ));

    //     break;
    //   default:
    // }
  }

  // navigate to the detale page
  void navToDetale({required Results res}) {
    if (res.mediaType == 'person') {
      // navigate to cast member pagex
      navToCast(
          name: res.title.toString(),
          link: imagebase + res.posterPath.toString(),
          id: res.id.toString(),
          language: Get.find<HomeController>().userModel.language.toString(),
          isShow: false);
    } else {
      MovieDetaleModel movieDetales = MovieDetaleModel(
          recomendation: HomePageModel(isError: false, results: [
            Results(
                voteAverage: 0.0, id: 0, posterPath: 'assets/images/oscar.jpg'),
            Results(
                voteAverage: 0.0, id: 0, posterPath: 'assets/images/oscar.jpg'),
            Results(
                voteAverage: 0.0, id: 0, posterPath: 'assets/images/oscar.jpg'),
            Results(
                voteAverage: 0.0, id: 0, posterPath: 'assets/images/oscar.jpg')
          ]),
          cast: CastModel(isError: false, cast: [
            Cast(
              profilePath: 'assets/images/oscar.jpg',
              name: 'Actor',
              character: 'character',
              id: 0,
              creditId: '',
            ),
            Cast(
              profilePath: 'assets/images/oscar.jpg',
              name: 'Actor',
              character: 'character',
              id: 0,
              creditId: '',
            ),
            Cast(
              profilePath: 'assets/images/oscar.jpg',
              name: 'Actor',
              character: 'character',
              id: 0,
              creditId: '',
            ),
            Cast(
              profilePath: 'assets/images/oscar.jpg',
              name: 'Actor',
              character: 'character',
              id: 0,
              creditId: '',
            )
          ]),
          id: res.id,
          posterPath: res.posterPath,
          overview: res.overview,
          voteAverage: double.parse(res.voteAverage.toString()),
          title: res.title,
          isShow: res.isShow,
          runtime: 0,
          genres: null,
          releaseDate: res.releaseDate,
          originCountry: '');

      if (Get.isRegistered<MovieDetaleController>() == true) {
        Get.find<MovieDetaleController>().myFocusNode.unfocus();
      }
      Get.create(() => (MovieDetaleController()), permanent: false);
      Get.to(
        () => const MovieDetalePage(),
        preventDuplicates: false,
        arguments: movieDetales,
      );
    }
  }

  // navigate to cast member page
  void navToCast(
      {required String name,
      required String link,
      required String id,
      required String language,
      required bool isShow}) {
    ActorModel actorModel = ActorModel(
        actorName: name,
        posterPath: link,
        language: language,
        id: id,
        isShow: isShow,
        bio: '',
        tvResults: [],
        movieResults: [],
        age: 0);
    Get.create(() => (ActorController()), permanent: false);
    Get.to(() => const ActorPage(),
        preventDuplicates: false, arguments: actorModel);
  }
}
