import 'package:filmmer_rewrite/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../helper/constants.dart';
import '../../widgets/content_scrolling.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/drawer.dart';

class HomePageAndroid extends StatelessWidget {
  const HomePageAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find<HomeController>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mainColor,
      drawer: const Draw(),
      appBar: AppBar(
        backgroundColor: mainColor,
        centerTitle: true,
        elevation: 0,
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
          IconButton(
            icon: const Icon(Icons.search),
            splashRadius: 15,
            onPressed: () {
              Get.find<HomeController>()
                  .goToSearch(isSearch: true, title: '', link: '');
            },
          ),
        ],
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return GetBuilder<HomeController>(
            init: Get.find<HomeController>(),
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
                              title: controller
                                  .translation[controller.lists.indexOf(e)],
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
                    child: CircularProgressIndicator(
                    color: orangeColor,
                  )));
      }),
    );
  }
}
