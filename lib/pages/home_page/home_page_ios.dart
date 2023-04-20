import 'package:filmmer_rewrite/helper/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../controllers/home_controller.dart';
import '../../widgets/content_scrolling.dart';
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
    return CupertinoPageScaffold(
      backgroundColor: mainColor,
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
          backgroundColor: mainColor,
          middle: Shimmer.fromColors(
              period: const Duration(seconds: 3),
              baseColor: orangeColor,
              highlightColor: Colors.yellow,
              child: const CustomText(
                text: 'Filmmer',
                size: 26,
                color: orangeColor,
              )),
          trailing: CupertinoButton(
              child: const Icon(
                CupertinoIcons.search,
                color: whiteColor,
              ),
              onPressed: () {})),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return GetBuilder<HomeController>(
            init: controller,
            builder: (builder) => builder.count == 0
                ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: controller.lists
                          .map((e) => ContentScrolling(
                              color: orangeColor,
                              borderColor: orangeColor,
                              inHeight: constraints.maxHeight * 0.3,
                              inWidth: constraints.maxWidth * 0.37,
                              paddingY: 4,
                              pageWidth: constraints.maxWidth,
                              borderWidth: 2,
                              isError: e.isError as bool,
                              isArrow: true,
                              isTitle: true,
                              isMovie: true,
                              isShadow: false,
                              title: translation[controller.lists.indexOf(e)],
                              fit: BoxFit.cover,
                              reload: () => Get.find<HomeController>().apiCall(
                                  language: Get.find<HomeController>()
                                      .userModel
                                      .language
                                      .toString()),
                              textColor: whiteColor,
                              isFirstPage: true,
                              height: constraints.maxHeight * 0.31,
                              model: e,
                              link:
                                  controller.urls[controller.lists.indexOf(e)],
                              loading: controller.count))
                          .toList(),
                    ))
                : const Center(
                    child: CupertinoActivityIndicator(
                    color: orangeColor,
                  )));
      }),
    );
  }
}
