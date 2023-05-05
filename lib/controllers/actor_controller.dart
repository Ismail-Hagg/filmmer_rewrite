import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/constants.dart';
import '../models/actor_model.dart';
import '../models/award_model.dart';
import '../models/image_model.dart';
import '../models/results_model.dart';
import '../services/actor_cast_service.dart';
import '../services/actor_detale_service.dart';
import '../services/award_service.dart';
import '../services/image_service.dart';
import '../widgets/image_network.dart';

class ActorController extends GetxController {
  String _str = '';
  String get str => _str;
  int _it = 0;
  int get it => _it;

  late ActorModel _detales;
  ActorModel get detales => _detales;

  final RxInt _imagesCounter = 0.obs;
  int get imagesCounter => _imagesCounter.value;

  int _flip = 0;
  int get flip => _flip;

  int _loader = 0;
  int get loader => _loader;

  AwardModel _award = AwardModel();
  AwardModel get awardModel => _award;
  List<Map<String, String>> awardMapLate = [];
  List<Map<String, String>> awardMap = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _detales = Get.arguments ?? ActorModel(isError: true);
    getActor();
  }

  // call api to get actor information
  void getActor() async {
    _loader = 1;
    await ActorDetaleService()
        .getActorInfo(
            link:
                'https://api.themoviedb.org/3/person/${_detales.id}?api_key=$apiKey&language=${_detales.language.toString().replaceAll('_', '-')}')
        .then((value) {
      _detales.bio = value.isError == false ? value.biography : 'error'.tr;
      _detales.age = value.isError == false ? value.age : 0;
      _detales.imdb = value.isError == false ? value.imdbId : '';
      if (value.isError == false) {
        getAward(id: _detales.imdb.toString());
        getActorMovie();
      } else {
        _loader = 0;
        update();
      }
      _loader = 0;
    });
  }

  getActorMovie() async {
    var items = ['movie', 'tv'];
    for (var element in items) {
      await ActorCastService()
          .getActorCast(
              link:
                  'https://api.themoviedb.org/3/person/${_detales.id}/${element}_credits?api_key=$apiKey&language=',
              lan: _detales.language.toString())
          .then((value) {
        if (element == 'movie') {
          _detales.movieResults = value.res;
        } else {
          List<Results> lst = [];
          for (var element in value.res!) {
            if (!element.genreIds!.contains(10767) &&
                !element.genreIds!.contains(10763)) {
              lst.add(element);
            }
          }
          _detales.tvResults = lst;
        }
      });
    }
    update();
  }

  // load actor award data from imdb api
  void getAward({required String id}) async {
    await AwardsService()
        .getAward(link: 'https://imdb-api.com/en/API/NameAwards/$imdbKey/$id')
        .then((value) {
      _award = value;
      awardCount(model: _award);
      update();
    });
  }

  // formatt actor's awards
  void awardCount({required AwardModel model}) {
    awardMapLate = [];
    if (model.isError == false && model.errorMessage == '') {
      for (var i = 0; i < model.items!.length; i++) {
        _str = '';
        _it = 0;

        _str = model.items![i].eventTitle.toString();
        for (var x = 0;
            x < model.items![i].nameAwardEventDetails!.length;
            x++) {
          if (model.items![i].nameAwardEventDetails![x].title!
              .contains('Winner')) {
            _it++;
          }
        }

        if (it != 0) {
          awardMapLate.add({'awardName': str, 'count': it.toString()});
        }
      }
      awardMap = awardMapLate;
    }
  }

  // back button
  void back() {
    Get.back();
  }

  // call api to get images
  void getImages(
      {required double height,
      required double width,
      required bool isActor,
      required String id,
      required String language,
      required bool isIos,
      required bool isShow}) async {
    ImagesModel model = ImagesModel();
    _imagesCounter.value = 1;
    Get.dialog(Obx(
      () => Center(
        child: _imagesCounter.value == 1
            ? isIos
                ? const CupertinoActivityIndicator(
                    color: orangeColor,
                    radius: 25,
                  )
                : const CircularProgressIndicator(
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
    ));
    ImagesService()
        .getImages(
            media: isActor
                ? 'person'
                : isShow == true
                    ? 'tv'
                    : 'movie',
            id: id,
            lang: language.substring(0, language.indexOf('_')))
        .then((val) {
      model = val;
      _imagesCounter.value = 0;
    });
  }

  // switch between movie and tv
  void switchMovie(int counter) {
    _flip = counter;
    update();
  }
}
