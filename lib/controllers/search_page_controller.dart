import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/fire_upload.dart';
import '../models/results_model.dart';
import 'home_controller.dart';

class SearchController extends GetxController {
  final List<FirebaseSend> list;
  SearchController({required this.list});
  //final List<FirebaseSend> _list = Get.arguments ?? [];
  //List<FirebaseSend> get list => _list;
  List<FirebaseSend> _display = [];
  List<FirebaseSend> get display => _display;

  final TextEditingController _txtControlller = TextEditingController();
  TextEditingController get txtControlller => _txtControlller;

  FocusNode myFocusNode = FocusNode();

  // search
  void searching({required String query, required List<FirebaseSend> lst}) {
    final suggestion = lst.where((element) {
      final name = element.name.toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();
    _display = suggestion;
    update();
  }

  //
  void clearThings() {
    _txtControlller.clear();
    myFocusNode.requestFocus();
    _display = [];
    update();
  }

  // navigato to detale page
  void navv({required FirebaseSend model}) {
    Get.find<HomeController>().navToDetale(
        res: Results(
      id: int.parse(model.id),
      posterPath: model.posterPath,
      overview: model.overView,
      voteAverage: model.voteAverage,
      title: model.name,
      isShow: model.isShow,
      releaseDate: model.releaseDate,
    ));
  }
}
