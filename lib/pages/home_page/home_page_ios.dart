import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../controllers/home_controller.dart';
import '../../helper/constants.dart';
import '../../widgets/content_scroll_ios.dart';
import '../../widgets/custom_text.dart';

class HomePageIos extends StatelessWidget {
  const HomePageIos({super.key});

  @override
  Widget build(BuildContext context) {
    var translation = [
      'upcoming'.tr,
      'popularMovies'.tr,
      'popularShows'.tr,
      'topMovies'.tr,
      'topShowa'.tr,
    ];
    HomeController controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: mainColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
        title: Shimmer.fromColors(
            period: const Duration(seconds: 3),
            baseColor: orangeColor,
            highlightColor: Colors.yellow,
            child: const CustomText(
              text: 'Filmmer',
              size: 26,
              color: orangeColor,
            )),
        actions: [
          CupertinoButton(
              child: const Icon(
                CupertinoIcons.search,
                color: whiteColor,
              ),
              onPressed: () =>
                  controller.goToSearch(isSearch: true, link: '', title: '')),
        ],
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var height = constraints.maxHeight;
        var width = constraints.maxWidth;
        return GetBuilder<HomeController>(
            init: controller,
            builder: (builder) => builder.count == 0
                ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: controller.lists
                          .map((e) => ContentScrollIos(
                                isFirstPage: true,
                                isError: e.isError as bool,
                                reload: () => Get.find<HomeController>()
                                    .apiCall(
                                        language: Get.find<HomeController>()
                                            .userModel
                                            .language
                                            .toString()),
                                title: translation[controller.lists.indexOf(e)],
                                link: controller
                                    .urls[controller.lists.indexOf(e)],
                                height: height,
                                width: width,
                                isMovie: true,
                                textColor: whiteColor,
                                isArrow: true,
                                loading: builder.count,
                                model: e,
                              ))
                          .toList(),
                    ))
                : Center(
                    child: CupertinoActivityIndicator(
                    color: orangeColor,
                    radius: width * 0.06,
                  )));
      }),
    );
  }
}
