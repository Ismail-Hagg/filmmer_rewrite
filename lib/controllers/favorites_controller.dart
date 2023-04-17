import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../helper/constants.dart';
import '../helper/utils.dart';
import '../local_storage/local_database.dart';
import '../models/fire_upload.dart';
import '../models/results_model.dart';
import '../models/user_model.dart';
import '../services/firestore_services.dart';
import 'home_controller.dart';

class FavouritesController extends GetxController {
  final List<String> _genreList = [];
  List<String> get genreList => _genreList;

  final List<String> _genreListAdd = [];
  List<String> get genreListAdd => _genreListAdd;

  final UserModel _user = Get.find<HomeController>().userModel;
  UserModel get user => _user;

  final List<FirebaseSend> _newList = [];
  List<FirebaseSend> get newList => _newList;

  List<FirebaseSend> _postFilter = [];
  List<FirebaseSend> get postFilter => _postFilter;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  DatabaseHelper get dbHelper => _dbHelper;

  final Rx<List<FirebaseSend>> _favList = Rx([]);
  List<FirebaseSend> get favList => _favList.value;

  bool _filtering = false;
  bool get filtering => _filtering;

  @override
  void onInit() {
    super.onInit();
    loadDetales();
  }

  //get userdata and favourites from local storage
  void loadDetales() async {
    await dbHelper.queryAllRows(DatabaseHelper.table).then((value) {
      for (var i = 0; i < value.length; i++) {
        _newList.add(FirebaseSend.fromMap(value[i]));
        getGenres(lst: FirebaseSend.fromMap(value[i]).genres);
      }
      _newList.sort((a, b) => b.time.compareTo(a.time));
      update();
    });
  }

  //go to deteale page of a random movie or a show in the favourites list
  void randomnav() {
    if (_newList.isEmpty) {
      snack('enter'.tr, '');
    } else {
      int length = _genreListAdd.isEmpty ? _newList.length : _postFilter.length;
      List<FirebaseSend> lst = _genreListAdd.isEmpty ? _newList : _postFilter;
      Random random = Random();
      int randomNumber = random.nextInt(length);
      navv(model: lst[randomNumber]);
    }
  }

  //delete from firestore
  void delete({required FirebaseSend fire}) async {
    FirestoreService()
        .upload(userId: _user.userId.toString(), fire: fire, count: 1);
  }

  //navigato to detale page
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

  //delete from local storage and firebase
  void localDelete(
      {required String id,
      required int index,
      required FirebaseSend send}) async {
    Get.dialog(
      AlertDialog(
        title: Text('delete'.tr),
        content: Text('sure'.tr),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: orangeColor,
            ),
            child: Text("answer".tr),
            onPressed: () async => {
              Get.back(),
              _newList.removeAt(index),
              await dbHelper.delete(DatabaseHelper.table, id),
              update(),
              delete(fire: send)
            },
          ),
        ],
      ),
    );
  }

  fromDetale({required FirebaseSend send, required bool addOrDelete}) {
    var str = [];
    if (addOrDelete == true) {
      _newList.insert(0, send);
    } else {
      for (var element in _newList) {
        str.add(element.id);
      }
      _newList.removeAt(str.indexOf(send.id));
    }
    update();
  }

  // get the genres
  void getGenres({required List<dynamic> lst}) {
    for (var i = 0; i < lst.length; i++) {
      if (!_genreList.contains(lst[i].toString())) {
        _genreList.add(lst[i].toString());
      }
    }
  }

  // switch between genre filter and no genre filter
  void genreFilter() {
    _filtering = !filtering;
    _genreListAdd.clear();
    update();
  }

  // chip is selected
  bool chip({required String genre}) {
    if (_genreListAdd.contains(genre)) {
      return true;
    } else {
      return false;
    }
  }

  // filter the list
  void filterMainList() {
    _postFilter = [];
    if (_newList.isNotEmpty) {
      for (var i = 0; i < _newList.length; i++) {
        if (_newList[i].genres.toSet().containsAll(_genreListAdd)) {
          _postFilter.add(_newList[i]);
        }
      }
    }
  }

  // add selected genre to list
  void addSelected({required String genre}) {
    if (_genreListAdd.contains(genre)) {
      _genreListAdd.remove(genre);
      filterMainList();
    } else {
      _genreListAdd.add(genre);
      filterMainList();
    }
    update();
  }
}
