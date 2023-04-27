import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../helper/constants.dart';
import '../models/homepage_model.dart';
import '../models/movie_detale_model.dart';
import 'circle_container.dart';
import 'custom_text.dart';
import 'image_network.dart';

class ContentScrollIos extends StatelessWidget {
  final String? title;
  final HomePageModel? model;
  final MovieDetaleModel? detales;
  final Function() reload;
  final double height;
  final double width;
  final bool isMovie;
  final Color textColor;
  final bool isArrow;
  final String? link;
  final bool isError;
  final bool isFirstPage;
  final int loading;
  final bool? isWaiting;
  const ContentScrollIos(
      {super.key,
      this.title,
      this.model,
      this.detales,
      required this.reload,
      required this.height,
      required this.width,
      required this.isMovie,
      required this.textColor,
      required this.isArrow,
      this.link,
      required this.isError,
      required this.isFirstPage,
      required this.loading,
      this.isWaiting});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find<HomeController>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              title != null
                  ? Material(
                      type: MaterialType.transparency,
                      child: CustomText(
                        text: title ?? '',
                        size: width * 0.05,
                        color: textColor,
                        weight: FontWeight.bold,
                      ),
                    )
                  : Container(),
              isArrow
                  ? CupertinoButton(
                      onPressed: () {
                        controller.goToSearch(
                            isSearch: false,
                            link: link ?? '',
                            title: title ?? '');
                      },
                      child: Icon(CupertinoIcons.forward,
                          color: textColor, size: width * 0.065))
                  : Container()
            ],
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        isError == true
            ? SizedBox(
                height: height * 0.2,
                child: Center(
                    child: GestureDetector(
                  onTap: reload,
                  child: Icon(
                    Icons.refresh,
                    size: (height * 0.31) * 0.2,
                    color: textColor,
                  ),
                )),
              )
            : SizedBox(
                height: height * 0.31,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: isFirstPage
                        ? model!.results!.length
                        : isMovie
                            ? detales!.recomendation!.results!.length
                            : detales!.cast!.cast!.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Material(
                          type: MaterialType.transparency,
                          child: GestureDetector(
                              onTap: () {
                                isFirstPage
                                    ? Get.find<HomeController>().navToDetale(
                                        res: model!.results![index])
                                    : isMovie
                                        ? {
                                            FocusScope.of(context).unfocus(),
                                            Get.find<HomeController>()
                                                .navToDetale(
                                                    res: detales!.recomendation!
                                                        .results![index])
                                          }
                                        : loading == 0
                                            ? Get.find<HomeController>()
                                                .navToCast(
                                                    name: detales!
                                                        .cast!.cast![index].name
                                                        .toString(),
                                                    link: imagebase +
                                                        detales!
                                                            .cast!
                                                            .cast![index]
                                                            .profilePath
                                                            .toString(),
                                                    id: detales!
                                                        .cast!.cast![index].id
                                                        .toString(),
                                                    language: Get.find<
                                                            HomeController>()
                                                        .userModel
                                                        .language
                                                        .toString(),
                                                    isShow: false)
                                            : {};
                              },
                              child: isWaiting == null
                                  ? ImageNetwork(
                                      name: isFirstPage == false
                                          ? isMovie == false
                                              ? detales!.cast!.cast![index].name
                                              : ''
                                          : '',
                                      char: isFirstPage == false
                                          ? isMovie == false
                                              ? detales!
                                                  .cast!.cast![index].character
                                              : ''
                                          : '',
                                      nameColor: orangeColor,
                                      charColor: whiteColor,
                                      topSpacing: height * 0.05,
                                      nameSize: width * 0.033,
                                      charSize: width * 0.026,
                                      nameMax: 1,
                                      charMax: 1,
                                      flow: TextOverflow.ellipsis,
                                      align: TextAlign.center,
                                      borderWidth: 1,
                                      borderColor: orangeColor,
                                      rating: isFirstPage
                                          ? model!.results![index].voteAverage
                                              .toString()
                                          : isMovie
                                              ? detales!.recomendation!
                                                  .results![index].voteAverage
                                                  .toString()
                                              : '0.0',
                                      link: isFirstPage
                                          ? imagebase +
                                              (model!.results?[index]
                                                      .posterPath)
                                                  .toString()
                                          : isMovie
                                              ? imagebase +
                                                  (detales!
                                                          .recomendation!
                                                          .results![index]
                                                          .posterPath)
                                                      .toString()
                                              : imagebase +
                                                  (detales!.cast!.cast![index]
                                                          .profilePath)
                                                      .toString(),
                                      height: height * 0.4,
                                      width: width * 0.37,
                                      isMovie: isMovie,
                                      isShadow: false,
                                      color: orangeColor,
                                      fit: BoxFit.contain,
                                    )
                                  : isMovie == false
                                      ? CircleContainer(
                                          fit: BoxFit.contain,
                                          height: height * 0.3,
                                          width: width * 0.37,
                                          color: orangeColor,
                                          shadow: false,
                                          isPicOk: true,
                                          image: Image.asset(detales!
                                                  .cast!.cast![0].profilePath
                                                  .toString())
                                              .image,
                                          name: detales!.cast!.cast![0].name,
                                          char:
                                              detales!.cast!.cast![0].character,
                                          nameColor: orangeColor,
                                          charColor: whiteColor,
                                          topSpacing: height * 0.05,
                                          nameSize: width * 0.03,
                                          charSize: width * 0.02,
                                          nameMax: 1,
                                          charMax: 1,
                                          flow: TextOverflow.clip,
                                          align: TextAlign.center,
                                          weight: FontWeight.w600,
                                        )
                                      : Container()),
                        ),
                      );
                    }))
      ],
    );
  }
}
