import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/utils.dart';
import '../local_storage/local_database.dart';
import '../models/fire_upload.dart';
import '../models/results_model.dart';
import '../models/user_model.dart';
import '../pages/search_page/search_page.dart';
import '../services/firestore_services.dart';
import 'home_controller.dart';

class WatchlistController extends GetxController {
  final BuildContext context;
  final bool isIos;
  WatchlistController({required this.context, required this.isIos});
  final List<String> _genreListMovies = [];
  List<String> get genreListMovies => _genreListMovies;

  final List<String> _genreListAddMovies = [];
  List<String> get genreListAddMovies => _genreListAddMovies;

  final List<String> _genreListShows = [];
  List<String> get genreListShows => _genreListShows;

  final List<String> _genreListAddShows = [];
  List<String> get genreListAddShows => _genreListAddShows;

  final UserModel _userModel = Get.find<HomeController>().userModel;
  UserModel get userModel => _userModel;

  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  DatabaseHelper get dbHelper => _dbHelper;

  int _count = 0;
  int get count => _count;

  final List<FirebaseSend> _moviesLocal = [];
  List<FirebaseSend> get movieList => _moviesLocal;

  final List<FirebaseSend> _showLocal = [];
  List<FirebaseSend> get showList => _showLocal;

  List<FirebaseSend> _postMoviesLocal = [];
  List<FirebaseSend> get postMoviesLocal => _postMoviesLocal;

  List<FirebaseSend> _postShowLocal = [];
  List<FirebaseSend> get postShowLocal => _postShowLocal;

  bool _filtering = false;
  bool get filtering => _filtering;

  @override
  void onInit() {
    super.onInit();
    loadDetales();
  }

  // get user data and watchlist from local storage
  void loadDetales() async {
    await dbHelper.queryAllRows(DatabaseHelper.movieTable).then((value) {
      for (var i = 0; i < value.length; i++) {
        _moviesLocal.add(FirebaseSend.fromMap(value[i]));
        getGenres(lst: _moviesLocal[i].genres, isMovies: true);
      }
      _moviesLocal.sort((a, b) => b.time.compareTo(a.time));
    });

    await dbHelper.queryAllRows(DatabaseHelper.showTable).then((value) {
      for (var i = 0; i < value.length; i++) {
        _showLocal.add(FirebaseSend.fromMap(value[i]));
        getGenres(lst: _showLocal[i].genres, isMovies: false);
      }
      _showLocal.sort((a, b) => b.time.compareTo(a.time));
    });
    update();
  }

  void change({required int count}) {
    _count = count;
    update();
  }

  // get the genres
  void getGenres({required List<dynamic> lst, required bool isMovies}) {
    for (var i = 0; i < lst.length; i++) {
      if (isMovies) {
        if (!_genreListMovies.contains(lst[i].toString())) {
          _genreListMovies.add(lst[i].toString());
        }
      } else {
        if (!_genreListShows.contains(lst[i].toString())) {
          _genreListShows.add(lst[i].toString());
        }
      }
    }
  }

  //navigato to detale page
  void navv(FirebaseSend model) {
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

  void fromDetale({required FirebaseSend send, required bool isShow}) {
    if (isShow == true) {
      showList.insert(0, send);
    } else {
      movieList.insert(0, send);
    }
    update();
  }

  //delete from local storage and from firebase
  void delete({required int index}) async {
    String id = '';
    platforMulti(
        isIos: isIos,
        title: 'delete'.tr,
        buttonTitle: ["cancel".tr, "answer".tr],
        body: 'sure'.tr,
        func: [
          () {
            Get.back();
          },
          () async {
            Get.back();
            if (_count == 1) {
              id = _showLocal[index].id;
              _showLocal.removeAt(index);
              await dbHelper.delete(DatabaseHelper.showTable, id);
              update();
              FirestoreService().delete(
                  uid: _userModel.userId.toString(),
                  id: id,
                  collection: 'showWatchList');
            } else {
              id = _moviesLocal[index].id;
              _moviesLocal.removeAt(index);
              await dbHelper.delete(DatabaseHelper.movieTable, id);
              update();
              FirestoreService().delete(
                  uid: _userModel.userId.toString(),
                  id: id,
                  collection: 'movieWatchList');
            }
          }
        ],
        context: context);
  }

  // go to search page
  void searching() {
    if (_count == 0) {
      Get.to(() => SearchPage(lst: _moviesLocal));
    } else {
      Get.to(() => SearchPage(
            lst: _showLocal,
          ));
    }
  }

  // random movie or a show
  void randomNav() {
    Random random = Random();
    if (_count == 0) {
      if (_moviesLocal.isNotEmpty) {
        int length = _genreListAddMovies.isEmpty
            ? _moviesLocal.length
            : _postMoviesLocal.length;
        List<FirebaseSend> lst =
            _genreListAddMovies.isEmpty ? _moviesLocal : _postMoviesLocal;
        int randomNumber = random.nextInt(length);
        Get.find<HomeController>().navToDetale(
            res: Results(
          id: int.parse(lst[randomNumber].id),
          posterPath: lst[randomNumber].posterPath,
          overview: lst[randomNumber].overView,
          voteAverage: lst[randomNumber].voteAverage,
          title: lst[randomNumber].name,
          isShow: lst[randomNumber].isShow,
          releaseDate: lst[randomNumber].releaseDate,
        ));
      } else {
        platformAlert(
            isIos: isIos, title: 'enter'.tr, body: '', context: context);
      }
    } else {
      if (_showLocal.isNotEmpty) {
        int length = _genreListAddShows.isEmpty
            ? _moviesLocal.length
            : _postShowLocal.length;
        List<FirebaseSend> lst =
            _genreListAddShows.isEmpty ? _moviesLocal : _postShowLocal;

        int randomNumber = random.nextInt(length);
        Get.find<HomeController>().navToDetale(
            res: Results(
          id: int.parse(lst[randomNumber].id),
          posterPath: lst[randomNumber].posterPath,
          overview: lst[randomNumber].overView,
          voteAverage: lst[randomNumber].voteAverage,
          title: lst[randomNumber].name,
          isShow: lst[randomNumber].isShow,
          releaseDate: lst[randomNumber].releaseDate,
        ));
      } else {
        platformAlert(
            isIos: isIos, title: 'enter'.tr, body: '', context: context);
      }
    }
  }

  // switch between genre filter and no genre filter
  void genreFilter() {
    _filtering = !filtering;
    _genreListAddMovies.clear();
    _genreListAddShows.clear();
    update();
  }

  // chip is selected
  bool chip(String genre) {
    if (_count == 0) {
      if (_genreListAddMovies.contains(genre)) {
        return true;
      } else {
        return false;
      }
    } else {
      if (_genreListAddShows.contains(genre)) {
        return true;
      } else {
        return false;
      }
    }
  }

  // add selected genre to list
  void addSelected(String genre) {
    if (_count == 0) {
      if (_genreListAddMovies.contains(genre)) {
        _genreListAddMovies.remove(genre);
        filterMainList();
      } else {
        _genreListAddMovies.add(genre);
        filterMainList();
      }
    } else {
      if (_genreListAddShows.contains(genre)) {
        _genreListAddShows.remove(genre);
        filterMainList();
      } else {
        _genreListAddShows.add(genre);
        filterMainList();
      }
    }

    update();
  }

  void filterMainList() {
    if (_count == 0) {
      _postMoviesLocal = [];
      if (_moviesLocal.isNotEmpty) {
        for (var i = 0; i < _moviesLocal.length; i++) {
          if (_moviesLocal[i].genres.toSet().containsAll(_genreListAddMovies)) {
            _postMoviesLocal.add(_moviesLocal[i]);
          }
        }
      }
    } else {
      _postShowLocal = [];
      if (_showLocal.isNotEmpty) {
        for (var i = 0; i < _showLocal.length; i++) {
          if (_showLocal[i].genres.toSet().containsAll(_genreListAddShows)) {
            _postShowLocal.add(_showLocal[i]);
          }
        }
      }
    }
  }
}
