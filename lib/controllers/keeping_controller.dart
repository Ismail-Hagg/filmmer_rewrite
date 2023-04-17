import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/episode_keeping_model.dart';
import '../models/user_model.dart';
import '../services/firestore_services.dart';
import 'home_controller.dart';

class EpisodeKeepingColtroller extends GetxController {
  final UserModel _userModel = Get.find<HomeController>().userModel;
  UserModel get userModel => _userModel;

  final List<EpisodeModeL> _models = [];
  List<EpisodeModeL> get models => _models;

  int _count = 0;
  int get count => _count;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getData();
  }

  // open bottom sheet
  void openBottomSheet(Widget widget, BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return widget;
        });
  }

  // api call
  void getData() async {
    _count = 1;
    update();
    await FirestoreService()
        .getKeeping(userId: _userModel.userId.toString())
        .then((value) async {
      for (var i = 0; i < value.docs.length; i++) {
        _models.add(EpisodeModeL.fromMap(
            value.docs[i].data() as Map<String, dynamic>, true));
      }
      _count = 0;
      update();
      await FirestoreService().clearIsUpdates(
          userId: _userModel.userId.toString(),
          collection: 'episodeKeeping',
          clearAll: true,
          chatId: '');
    });
  }

  String showStatus(String status) {
    if (status == 'Returning Series') {
      return 'return'.tr;
    } else {
      return 'ended'.tr;
    }
  }

  // add or sub from episode or season
  void counting(int before, int index, String operation, bool isEpisode) {
    if (operation == 'add') {
      if (isEpisode) {
        _models[index].myEpisode = before + 1;
        _models[index].change = Timestamp.now();
      } else {
        _models[index].mySeason = before + 1;
        _models[index].change = Timestamp.now();
      }
    } else {
      if (isEpisode) {
        if (_models[index].myEpisode != 1) {
          _models[index].myEpisode = before - 1;
          _models[index].change = Timestamp.now();
        }
      } else {
        if (_models[index].mySeason != 1) {
          _models[index].mySeason = before - 1;
          _models[index].change = Timestamp.now();
        }
      }
    }
    update();
  }

  // order the list
  void updateEpisode(int index) async {
    Get.back();
    EpisodeModeL tempModel = _models[index];
    _models.sort((a, b) {
      return DateTime.parse(b.change!.toDate().toString())
          .compareTo(DateTime.parse(a.change!.toDate().toString()));
    });
    update();
    await FirestoreService()
        .addEpisode(uid: _userModel.userId.toString(), model: tempModel);
  }
}
