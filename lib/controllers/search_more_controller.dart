import 'package:filmmer_rewrite/controllers/auth_controller.dart';
import 'package:filmmer_rewrite/models/search_move_model.dart';
import 'package:filmmer_rewrite/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/constants.dart';
import '../helper/utils.dart';
import '../models/homepage_model.dart';
import '../services/home_page_service.dart';
import 'home_controller.dart';

class SearchMoreController extends GetxController {
  final bool isIos;
  final BuildContext context;
  SearchMoreController({required this.context, required this.isIos});

  final Move _argumentData = Get.arguments;
  Move get argumentData => _argumentData;

  final UserModel _userModel = Get.find<HomeController>().userModel;
  UserModel get userModel => _userModel;

  final FocusNode myFocusNode = FocusNode();
  TextEditingController txt = TextEditingController();

  HomePageModel _model = HomePageModel();
  HomePageModel get model => _model;

  int _page = 1;
  int get page => _page;

  int _pageLoad = 0;
  int get pageLoad => _pageLoad;

  int _indicator = 0;
  int get indicator => _indicator;

  String _query = '';
  String get query => _query;

  final ScrollController _scrollController = ScrollController();
  ScrollController get scrollController => _scrollController;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    firstLoad();
    scroll();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  // clear search field to make another search request
  void clearFocus() {
    txt.clear();
    myFocusNode.requestFocus();
  }

  // load more results when user reaches the end of the page
  void scroll() {
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        bool isTop = _scrollController.position.pixels == 0;
        if (isTop) {
        } else {
          pageUp();
        }
      }
    });
  }

  // search
  void searchReady({required String query}) {
    _query = '&query=${query.trim()}';
    getMovies(page: _page, query: _query);
  }

  // load the movies if isSearch == false
  void firstLoad() {
    if (_argumentData.isSearch == false) {
      getMovies(page: _page, query: '');
    } else {
      _argumentData.link = search;
    }
  }

  //load data from api
  void getMovies({required int page, required String query}) async {
    _indicator = 1;
    page = 1;
    update();
    await HomePageService()
        .getHomeInfo(
            link:
                '${_argumentData.link}${_userModel.language.toString().replaceAll('_', '-')}$query&page=',
            language: '$page')
        .then((value) {
      _model = value;
      _indicator = 0;
      update();
    });
  }

  // load the next result page from api
  void pageUp() async {
    if (_page == _model.totalPages) {
      platformAlert(
          isIos: isIos,
          title: 'error'.tr,
          body: 'moreres'.tr,
          context: context);
    } else {
      _page++;
      _pageLoad = 1;
      update();
      await HomePageService()
          .getHomeInfo(
              link:
                  '${_argumentData.link}${Get.find<HomeController>().userModel.language}$query&page=',
              language: '$page')
          .then((value) {
        if (value.isError == true) {
          platformAlert(
              isIos: isIos,
              title: 'error'.tr,
              body: 'wrong'.tr,
              context: context);

          _pageLoad = 0;
          update();
        } else {
          for (var i = 0; i < value.results!.length; i++) {
            _model.results!.add(value.results![i]);
          }
          _pageLoad = 0;
          update();
        }
      });
    }
  }
}
