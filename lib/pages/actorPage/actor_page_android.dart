import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/actor_controller.dart';
import '../../controllers/home_controller.dart';
import '../../helper/constants.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/image_network.dart';

class ActorPageAndroid extends StatelessWidget {
  const ActorPageAndroid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var height = constraints.maxHeight;
        var width = constraints.maxWidth;
        var safePadding = MediaQuery.of(context).padding.top;
        return GetBuilder<ActorController>(
          init: Get.find<ActorController>(),
          builder: (controller) => Column(
            children: [
              Container(
                width: width,
                height: height * 0.3,
                color: mainColor,
                child: Column(
                  children: [
                    SafeArea(
                      child: SizedBox(
                        height: (height * 0.3) * 0.17,
                        width: width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                                splashRadius: 15,
                                onPressed: () => controller.back(),
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: whiteColor,
                                ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: (height * 0.3) * 0.83 - safePadding,
                      child: Row(
                        children: [
                          SizedBox(
                            width: width * 0.4,
                            child: GestureDetector(
                              onTap: () => controller.getImages(
                                  isIos: false,
                                  height: height,
                                  width: width,
                                  isActor: true,
                                  id: controller.detales.id.toString(),
                                  language:
                                      controller.detales.language.toString(),
                                  isShow: controller.detales.isShow as bool),
                              child: ImageNetwork(
                                  link:
                                      controller.detales.posterPath.toString(),
                                  height: width * 0.4,
                                  width: width * 0.4,
                                  color: secondaryColor,
                                  fit: BoxFit.cover,
                                  isMovie: false,
                                  isShadow: false,
                                  borderColor: orangeColor,
                                  borderWidth: 2),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, bottom: 6),
                                  child: SizedBox(
                                    width: width * 0.6,
                                    child: CustomText(
                                      align: TextAlign.center,
                                      text: controller.detales.actorName,
                                      color: orangeColor,
                                      size: width * 0.05,
                                      maxline: 2,
                                      flow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.6,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 12),
                                    child: CustomText(
                                      align: TextAlign.center,
                                      maxline: 1,
                                      text:
                                          '${'age'.tr} : ${controller.detales.age}',
                                      color: orangeColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: width,
                height: height * 0.7,
                color: secondaryColor,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: width,
                        height: (height * 0.7) * 0.3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: mainColor),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 6),
                          child: controller.loader == 1
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: orangeColor,
                                  ),
                                )
                              : GestureDetector(
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: CustomText(
                                      text: controller.detales.bio != ''
                                          ? controller.detales.bio
                                          : 'nobio'.tr,
                                      size: width * 0.044,
                                      color: whiteColor.withOpacity(0.6),
                                      align: controller.detales.bio != ''
                                          ? TextAlign.left
                                          : TextAlign.center,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        width: width,
                        height: (height * 0.7) * 0.15 - 16,
                        child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return FittedBox(
                                child: SizedBox(
                                  width: width * 0.3,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomText(
                                            align: TextAlign.center,
                                            text: controller.awardMap[index]
                                                    ['count']
                                                .toString(),
                                            size: width * 0.04,
                                            color: Colors.white),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        CustomText(
                                          maxline: 2,
                                          text: controller.awardMap[index]
                                                  ['awardName']
                                              .toString(),
                                          size: width * 0.03,
                                          color: orangeColor,
                                          flow: TextOverflow.ellipsis,
                                          align: TextAlign.center,
                                        )
                                      ]),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: width * 0.01,
                              );
                            },
                            itemCount: controller.awardMap.length),
                      ),
                    ),
                    SizedBox(
                      width: width,
                      height: (height * 0.7) * 0.55 - 16,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Material(
                                color: secondaryColor,
                                child: InkWell(
                                  onTap: () => controller.switchMovie(0),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            ((height * 0.7) * 0.7 - 16) * 0.14,
                                        width: width * 0.5,
                                        child: Center(
                                          child: CustomText(
                                            text: 'movies'.tr,
                                            color: controller.flip == 0
                                                ? orangeColor
                                                : orangeColor.withOpacity(0.5),
                                            size: width * 0.04,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height:
                                            ((height * 0.7) * 0.7 - 16) * 0.007,
                                        width: width * 0.5,
                                        color: controller.flip == 0
                                            ? orangeColor
                                            : Colors.transparent,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Material(
                                color: secondaryColor,
                                child: InkWell(
                                  onTap: () => controller.switchMovie(1),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            ((height * 0.7) * 0.7 - 16) * 0.14,
                                        width: width * 0.5,
                                        child: Center(
                                          child: CustomText(
                                            text: 'shows'.tr,
                                            color: controller.flip != 0
                                                ? orangeColor
                                                : orangeColor.withOpacity(0.5),
                                            size: width * 0.04,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height:
                                            ((height * 0.7) * 0.7 - 16) * 0.007,
                                        width: width * 0.5,
                                        color: controller.flip != 0
                                            ? orangeColor
                                            : Colors.transparent,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: (height * 0.7) * 0.45 - 16,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemCount: controller.flip == 0
                                  ? controller.detales.movieResults == null
                                      ? 0
                                      : controller.detales.movieResults!.length
                                  : controller.detales.tvResults == null
                                      ? 0
                                      : controller.detales.tvResults!.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: GestureDetector(
                                      onTap: () => Get.find<HomeController>()
                                          .navToDetale(
                                              res: controller.flip == 0
                                                  ? controller.detales
                                                      .movieResults![index]
                                                  : controller.detales
                                                      .tvResults![index]),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          top: (height * 0.7) * 0.05 - 16,
                                        ),
                                        child: controller.flip == 0
                                            ? controller.detales.movieResults!
                                                    .isEmpty
                                                ? Center(
                                                    child: CustomText(
                                                      text: 'res'.tr,
                                                      color: orangeColor,
                                                      size: width * 0.045,
                                                    ),
                                                  )
                                                : ImageNetwork(
                                                    link: imagebase +
                                                        controller
                                                            .detales
                                                            .movieResults![
                                                                index]
                                                            .posterPath
                                                            .toString(),
                                                    height:
                                                        (height * 0.7) * 0.4 -
                                                            16,
                                                    width: width * 0.35,
                                                    color: orangeColor,
                                                    fit: BoxFit.cover,
                                                    borderColor: orangeColor,
                                                    borderWidth: 2,
                                                    isMovie: true,
                                                    isShadow: false,
                                                    rating: controller
                                                        .detales
                                                        .movieResults![index]
                                                        .voteAverage
                                                        .toString(),
                                                  )
                                            : controller.detales.tvResults!
                                                        .isEmpty ||
                                                    controller.detales
                                                            .tvResults ==
                                                        null
                                                ? Center(
                                                    child: CustomText(
                                                      text: 'res'.tr,
                                                      color: orangeColor,
                                                      size: width * 0.045,
                                                    ),
                                                  )
                                                : ImageNetwork(
                                                    link: imagebase +
                                                        controller
                                                            .detales
                                                            .tvResults![index]
                                                            .posterPath
                                                            .toString(),
                                                    height:
                                                        (height * 0.7) * 0.4 -
                                                            16,
                                                    width: width * 0.35,
                                                    color: orangeColor,
                                                    fit: BoxFit.cover,
                                                    borderColor: orangeColor,
                                                    borderWidth: 2,
                                                    isMovie: true,
                                                    isShadow: false,
                                                    rating: controller
                                                        .detales
                                                        .tvResults![index]
                                                        .voteAverage
                                                        .toString(),
                                                  ),
                                      )),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
