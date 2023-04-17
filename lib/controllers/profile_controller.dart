import 'package:filmmer_rewrite/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/profile_model.dart';
import '../models/results_model.dart';
import '../models/user_model.dart';
import '../services/firestore_services.dart';
import 'home_controller.dart';

class ProfileController extends GetxController {
  final BuildContext context;
  final bool isIos;
  ProfileController({required this.context, required this.isIos});

  final ProfileModel _detales = Get.arguments;
  ProfileModel get detales => _detales;

  final UserModel _userModel = Get.find<HomeController>().userModel;
  UserModel get userModel => _userModel;

  int _counter = 0;
  int get counter => _counter;

  int _loader = 0;
  int get loader => _loader;

  @override
  void onInit() async {
    super.onInit();
    setList();
  }

  // set lists
  void setList() async {
    _loader = 1;
    update();
    await getData('Favourites').then((favs) {
      _detales.favList = favs;
      _loader = 0;
      update();
    }).then((value) async {
      await getData('movieWatchList').then((wachMov) async {
        await getData('showWatchList').then((wachShow) async {
          update();
          _detales.watchList = [...wachMov, ...wachShow];
          await getData('episodeKeeping').then((value) {
            _detales.nowList = value;
            update();
          });
        });
      });
    });
  }

  // get users data from firebase
  Future<List<Results>> getData(String collection) async {
    List<Results> results = [];
    await FirestoreService()
        .getThingz(uid: _detales.usreId, collection: collection)
        .then((favs) {
      results = [];
      for (var i = 0; i < favs.docs.length; i++) {
        results.add(Results(
          voteAverage: favs.docs[i].get('voteAverage'),
          posterPath: collection == 'episodeKeeping'
              ? favs.docs[i].get('pic')
              : favs.docs[i].get('posterPath'),
          title: favs.docs[i].get('name'),
          id: collection == 'episodeKeeping'
              ? favs.docs[i].get('id')
              : int.parse(
                  favs.docs[i].get('id'),
                ),
          overview: favs.docs[i].get('overView'),
          releaseDate: favs.docs[i].get('releaseDate'),
          isShow: collection == 'episodeKeeping'
              ? true
              : favs.docs[i].get('isShow'),
        ));
      }
    }).onError((error, stackTrace) {
      platformAlert(
          isIos: isIos,
          title: 'error'.tr,
          body: error.toString(),
          context: context);
    });

    return results;
  }

  // go back
  void goBack() {
    Get.back();
  }

  // switch between tabs
  void flipper(int count) {
    _counter = count;
    update();
  }

  // navigate to the detales page
  void navToDet({required int index}) {
    Results results = Results(voteAverage: 0.0);
    switch (_counter) {
      case 0:
        results = _detales.favList[index];
        break;
      case 1:
        results = _detales.watchList[index];
        break;
      case 2:
        results = _detales.nowList[index];
        break;
    }
    update();
    try {
      Get.find<HomeController>().navToDetale(res: results);
    } catch (e) {
      print('========>>> $e');
    }
  }
}
