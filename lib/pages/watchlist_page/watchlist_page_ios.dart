import 'package:filmmer_rewrite/controllers/home_controller.dart';
import 'package:filmmer_rewrite/widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/watchlist_controller.dart';
import '../../helper/constants.dart';
import '../../widgets/menu_widget.dart';

class WatchListIos extends StatelessWidget {
  final bool isIos;
  const WatchListIos({super.key, required this.isIos});

  @override
  Widget build(BuildContext context) {
    final WatchlistController controll =
        Get.put(WatchlistController(context: context, isIos: isIos));
    var size = MediaQuery.of(context).size;

    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mainColor,
      navigationBar: CupertinoNavigationBar(
        border: const Border(bottom: BorderSide(color: Colors.transparent)),
        backgroundColor: mainColor,
        middle: CustomText(
          text: 'watchList'.tr,
          color: orangeColor,
        ),
        leading: FittedBox(
          child: Row(
            children: [
              Menu(
                ios: true,
                titles: ["random".tr, "filter".tr],
                funcs: [
                  () {
                    Get.back();
                    controll.randomNav();
                  },
                  () {
                    Get.back();
                    controll.genreFilter();
                  },
                ],
                child: const Icon(
                  Icons.more_vert,
                  color: whiteColor,
                ),
              ),
              CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: const Icon(
                    CupertinoIcons.search,
                    color: whiteColor,
                  ),
                  onPressed: () => controll.searching())
            ],
          ),
        ),
        trailing: GetBuilder<WatchlistController>(
          init: Get.find<WatchlistController>(),
          builder: (bro) => CustomText(
            text: bro.count == 0
                ? bro.genreListAddMovies.isEmpty
                    ? bro.movieList.length.toString()
                    : bro.postMoviesLocal.length.toString()
                : bro.genreListAddShows.isEmpty
                    ? bro.showList.length.toString()
                    : bro.postShowLocal.length.toString(),
            size: size.width * 0.04,
            color: whiteColor,
            isMat: true,
          ),
        ),
      ),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var height = constraints.maxHeight;
        var width = constraints.maxWidth;
        return GetBuilder<WatchlistController>(
          init: Get.find<WatchlistController>(),
          builder: (controlling) => SizedBox(
            width: width,
            height: height,
            child: Column(
              children: [
                CupertinoSegmentedControl(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  borderColor: orangeColor,
                  children: {
                    0: Container(
                      color: mainColor,
                      height: width * 0.1,
                      width: width * 0.5,
                      child: Center(
                        child: CustomText(
                          isMat: true,
                          isFit: true,
                          text: 'movies'.tr,
                          color: controlling.count == 0
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ),
                    1: Container(
                      color: mainColor,
                      height: width * 0.1,
                      width: width * 0.5,
                      child: Center(
                        child: CustomText(
                          isMat: true,
                          isFit: true,
                          text: 'shows'.tr,
                          color: controlling.count == 1
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                        ),
                      ),
                    )
                  },
                  onValueChanged: (flip) {
                    controlling.change(count: flip);
                  },
                ),
                controlling.filtering
                    ? Row(
                        children: [
                          SizedBox(
                            height: height * 0.06,
                            width: width * 0.9,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: controlling.count == 0
                                  ? controlling.genreListMovies.length
                                  : controlling.genreListShows.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.005,
                                      vertical: height * 0.01),
                                  child: ChoiceChip(
                                      selectedColor: orangeColor,
                                      disabledColor: secondaryColor,
                                      onSelected: (value) =>
                                          controlling.addSelected(
                                            controlling.count == 0
                                                ? controlling
                                                    .genreListMovies[index]
                                                : controlling
                                                    .genreListShows[index],
                                          ),
                                      label: CustomText(
                                          text: controlling.count == 0
                                              ? controlling
                                                  .genreListMovies[index]
                                              : controlling
                                                  .genreListShows[index],
                                          color: mainColor),
                                      selected: controlling.chip(controlling
                                                  .count ==
                                              0
                                          ? controlling.genreListMovies[index]
                                          : controlling.genreListShows[index])),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: height * 0.05,
                            width: width * 0.1,
                            child: Center(
                              child: GestureDetector(
                                onTap: () => controlling.genreFilter(),
                                child: const Icon(
                                  Icons.cancel,
                                  color: orangeColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Container(),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controlling.count == 0
                        ? controlling.genreListAddMovies.isEmpty
                            ? controlling.movieList.length
                            : controlling.postMoviesLocal.length
                        : controlling.genreListAddShows.isEmpty
                            ? controlling.showList.length
                            : controlling.postShowLocal.length,
                    itemBuilder: (context, index) {
                      return CupertinoListTile(
                        backgroundColorActivated: whiteColor.withOpacity(0.3),
                        onTap: () {
                          controlling.navv(controlling.count == 0
                              ? controlling.genreListAddMovies.isEmpty
                                  ? controlling.movieList[index]
                                  : controlling.postMoviesLocal[index]
                              : controlling.genreListAddShows.isEmpty
                                  ? controlling.showList[index]
                                  : controlling.postShowLocal[index]);
                        },
                        title: CustomText(
                            text: controlling.count == 0
                                ? controlling.genreListAddMovies.isEmpty
                                    ? controlling.movieList[index].name
                                    : controlling.postMoviesLocal[index].name
                                : controlling.genreListAddShows.isEmpty
                                    ? controlling.showList[index].name
                                    : controlling.postShowLocal[index].name,
                            color: whiteColor,
                            size: width * 0.04),
                        trailing: CupertinoButton(
                          padding: const EdgeInsets.all(0),
                          onPressed: () {
                            controlling.delete(index: index);
                          },
                          child: Icon(CupertinoIcons.delete_solid,
                              color: whiteColor.withOpacity(0.8)),
                        ),
                      );
                    },
                  ),
                ))
              ],
            ),
          ),
        );
      }),
    );
  }
}
