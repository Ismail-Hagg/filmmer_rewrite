import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/watchlist_controller.dart';
import '../../helper/constants.dart';
import '../../widgets/custom_text.dart';

class WatchListPageAndroid extends StatelessWidget {
  final bool isIos;
  WatchListPageAndroid({super.key, required this.isIos});

  @override
  Widget build(BuildContext context) {
    final WatchlistController controll =
        Get.put(WatchlistController(context: context, isIos: isIos));
    var size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
        title: CustomText(
          text: 'watchList'.tr,
          color: orangeColor,
          size: size.width * 0.05,
        ),
        actions: [
          GetBuilder<WatchlistController>(
            init: Get.find<WatchlistController>(),
            builder: (bro) => IconButton(
              icon: CustomText(
                text: bro.count == 0
                    ? bro.genreListAddMovies.isEmpty
                        ? bro.movieList.length.toString()
                        : bro.postMoviesLocal.length.toString()
                    : bro.genreListAddShows.isEmpty
                        ? bro.showList.length.toString()
                        : bro.postShowLocal.length.toString(),
                size: size.width * 0.04,
              ),
              onPressed: null,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            splashRadius: 15,
            onPressed: () {
              controll.searching();
            },
          ),
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("random".tr),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    const Icon(
                      Icons.shuffle,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("filter".tr),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    const Icon(
                      Icons.filter_alt,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ];
          }, onSelected: (value) {
            if (value == 0) {
              controll.randomNav();
            } else if (value == 1) {
              controll.genreFilter();
            }
          }),
        ],
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var height = constraints.maxHeight;
        var width = constraints.maxWidth;
        return GetBuilder<WatchlistController>(
          init: Get.find<WatchlistController>(),
          builder: (builder) => Column(
            children: [
              SizedBox(
                height: height * 0.07,
                child: Row(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: height * 0.067,
                          child: InkWell(
                            onTap: () {
                              builder.change(count: 0);
                            },
                            child: SizedBox(
                              width: width * 0.5,
                              child: Center(
                                child: CustomText(
                                  text: 'movies'.tr,
                                  color: builder.count == 0
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.3),
                                  size: width * 0.04,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: height * 0.003,
                          color: builder.count == 0
                              ? orangeColor
                              : Colors.transparent,
                          width: width * 0.5,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: height * 0.067,
                          child: InkWell(
                            onTap: () {
                              builder.change(count: 1);
                            },
                            child: SizedBox(
                              width: width * 0.5,
                              child: Center(
                                child: CustomText(
                                  text: 'shows'.tr,
                                  color: builder.count == 1
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.3),
                                  size: width * 0.04,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: height * 0.003,
                          color: builder.count == 1
                              ? orangeColor
                              : Colors.transparent,
                          width: width * 0.5,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              builder.filtering
                  ? Row(
                      children: [
                        SizedBox(
                          height: height * 0.06,
                          width: width * 0.9,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: builder.count == 0
                                ? builder.genreListMovies.length
                                : builder.genreListShows.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.005,
                                    vertical: height * 0.01),
                                child: ChoiceChip(
                                    selectedColor: orangeColor,
                                    disabledColor: secondaryColor,
                                    onSelected: (value) => builder.addSelected(
                                          builder.count == 0
                                              ? builder.genreListMovies[index]
                                              : builder.genreListShows[index],
                                        ),
                                    label: CustomText(
                                        text: builder.count == 0
                                            ? builder.genreListMovies[index]
                                            : builder.genreListShows[index],
                                        color: mainColor),
                                    selected: builder.chip(builder.count == 0
                                        ? builder.genreListMovies[index]
                                        : builder.genreListShows[index])),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: height * 0.05,
                          width: width * 0.1,
                          child: Center(
                            child: GestureDetector(
                              onTap: () => builder.genreFilter(),
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
              SizedBox(
                  height: builder.filtering ? height * 0.86 : height * 0.93,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: builder.count == 0
                          ? builder.genreListAddMovies.isEmpty
                              ? builder.movieList.length
                              : builder.postMoviesLocal.length
                          : builder.genreListAddShows.isEmpty
                              ? builder.showList.length
                              : builder.postShowLocal.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            builder.navv(builder.count == 0
                                ? builder.genreListAddMovies.isEmpty
                                    ? builder.movieList[index]
                                    : builder.postMoviesLocal[index]
                                : builder.genreListAddShows.isEmpty
                                    ? builder.showList[index]
                                    : builder.postShowLocal[index]);
                          },
                          title: CustomText(
                              text: builder.count == 0
                                  ? builder.genreListAddMovies.isEmpty
                                      ? builder.movieList[index].name
                                      : builder.postMoviesLocal[index].name
                                  : builder.genreListAddShows.isEmpty
                                      ? builder.showList[index].name
                                      : builder.postShowLocal[index].name,
                              color: Colors.white,
                              size: width * 0.042),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            splashRadius: 15,
                            onPressed: () {
                              builder.delete(index: index);
                            },
                          ),
                        );
                      },
                    ),
                  ))
            ],
          ),
        );
      }),
    );
  }
}
