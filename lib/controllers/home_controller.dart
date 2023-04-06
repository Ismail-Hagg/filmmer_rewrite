import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:filmmer_rewrite/controllers/auth_controller.dart';
import 'package:filmmer_rewrite/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/constants.dart';
import '../local_storage/local_data_pref.dart';
import '../models/homepage_model.dart';
import '../models/movie_detale_model.dart';
import '../services/firebase_storage_service.dart';
import '../services/firestore_services.dart';
import '../services/home_page_service.dart';

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
  MovieDetaleModel _movieDetales = MovieDetaleModel();

  HomePageModel get upcomingMovies => _upcomingMovies;
  HomePageModel get popularMovies => _popularMovies;
  HomePageModel get popularShows => _popularShows;
  HomePageModel get topMovies => _topMovies;
  HomePageModel get topShows => _topShows;
  MovieDetaleModel get movieDetales => _movieDetales;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
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
    List<String> urls = [upcoming, pop, popularTv, top, topTv];
    List<HomePageModel> lists = [
      _upcomingMovies,
      _popularMovies,
      _popularShows,
      _topMovies,
      _topShows
    ];

    for (var i = 0; i < urls.length; i++) {
      await HomePageService().getHomeInfo(urls[i], language).then((value) {
        lists[i] = value;
      });
    }
    _count = 0;
    update();
  }

  // upload profile image to firebase storage
  void uploadImage() async {
    if (_userModel.isPicLocal == true && _userModel.onlinePicPath == '') {
      await FirebaseStorageService()
          .uploade(_userModel.userId.toString(),
              File(_userModel.localPicPath.toString()))
          .then((value) async {
        _userModel.onlinePicPath = value;
        await UserDataPref().setUser(_userModel);
        await FirestoreService().userUpdate(
            userId: _userModel.userId.toString(),
            map: {'onlinePicPath': value});
      }).catchError((e) {
        Get.find<AuthController>().platformAlert(
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
}
