import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/keeping_controller.dart';
import '../../helper/constants.dart';
import '../../models/results_model.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/image_network.dart';

class KeepingPageAndtoid extends StatelessWidget {
  const KeepingPageAndtoid({super.key});

  @override
  Widget build(BuildContext context) {
    final EpisodeKeepingColtroller controller =
        Get.put(EpisodeKeepingColtroller());
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: mainColor,
        elevation: 0,
        title: CustomText(
          text: 'keeping'.tr,
          flow: TextOverflow.ellipsis,
          color: orangeColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<EpisodeKeepingColtroller>(
          init: Get.find<EpisodeKeepingColtroller>(),
          builder: (control) => LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            var height = constraints.maxHeight;
            var width = constraints.maxWidth;
            return control.count == 1
                ? const Center(
                    child: CircularProgressIndicator(
                      color: orangeColor,
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: control.models.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: GestureDetector(
                          onTap: () {
                            controller.openBottomSheet(
                                GetBuilder<EpisodeKeepingColtroller>(
                                  init: Get.find<EpisodeKeepingColtroller>(),
                                  builder: (thing) => Container(
                                    color: secondaryColor,
                                    height: height * 0.55,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: (height * 0.55) * 0.85,
                                          child: SingleChildScrollView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CustomText(
                                                        text: 'episode'.tr,
                                                        color: orangeColor,
                                                        size: width * 0.05,
                                                      ),
                                                      Row(
                                                        children: [
                                                          MaterialButton(
                                                              shape:
                                                                  const CircleBorder(),
                                                              onPressed: () => control.counting(
                                                                  control
                                                                      .models[
                                                                          index]
                                                                      .myEpisode!
                                                                      .toInt(),
                                                                  index,
                                                                  'add',
                                                                  true),
                                                              color: orangeColor
                                                                  .withOpacity(
                                                                      0.7),
                                                              child: const Icon(
                                                                Icons.add,
                                                                color:
                                                                    whiteColor,
                                                              )),
                                                          CustomText(
                                                            text: control
                                                                .models[index]
                                                                .myEpisode
                                                                .toString(),
                                                            color: orangeColor,
                                                          ),
                                                          MaterialButton(
                                                              shape:
                                                                  const CircleBorder(),
                                                              onPressed: () => control.counting(
                                                                  control
                                                                      .models[
                                                                          index]
                                                                      .myEpisode!
                                                                      .toInt(),
                                                                  index,
                                                                  'sub',
                                                                  true),
                                                              color: orangeColor
                                                                  .withOpacity(
                                                                      0.7),
                                                              child: const Icon(
                                                                Icons.remove,
                                                                color:
                                                                    whiteColor,
                                                              ))
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CustomText(
                                                        text: 'season'.tr,
                                                        color: orangeColor,
                                                        size: width * 0.05,
                                                      ),
                                                      Row(
                                                        children: [
                                                          MaterialButton(
                                                              shape:
                                                                  const CircleBorder(),
                                                              onPressed: () => control.counting(
                                                                  control
                                                                      .models[
                                                                          index]
                                                                      .mySeason!
                                                                      .toInt(),
                                                                  index,
                                                                  'add',
                                                                  false),
                                                              color: orangeColor
                                                                  .withOpacity(
                                                                      0.7),
                                                              child: const Icon(
                                                                Icons.add,
                                                                color:
                                                                    whiteColor,
                                                              )),
                                                          CustomText(
                                                            text: control
                                                                .models[index]
                                                                .mySeason
                                                                .toString(),
                                                            color: orangeColor,
                                                          ),
                                                          MaterialButton(
                                                              //minWiCdth: width * 0.3,
                                                              shape:
                                                                  const CircleBorder(),
                                                              onPressed: () => control.counting(
                                                                  control
                                                                      .models[
                                                                          index]
                                                                      .mySeason!
                                                                      .toInt(),
                                                                  index,
                                                                  'sub',
                                                                  false),
                                                              color: orangeColor
                                                                  .withOpacity(
                                                                      0.7),
                                                              child: const Icon(
                                                                Icons.remove,
                                                                color:
                                                                    whiteColor,
                                                              ))
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Divider(
                                                    color: orangeColor
                                                        .withOpacity(0.7),
                                                    thickness: 0.5,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CustomText(
                                                        text: 'lastepisode'.tr,
                                                        color: orangeColor,
                                                        size: width * 0.04,
                                                      ),
                                                      CustomText(
                                                        text:
                                                            '${'episode'.tr} ${control.models[index].episode} - ${'season'.tr} ${control.models[index].season}',
                                                        color: orangeColor,
                                                        size: width * 0.04,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CustomText(
                                                        text: 'nextepisode'.tr,
                                                        color: orangeColor,
                                                        size: width * 0.04,
                                                      ),
                                                      CustomText(
                                                        text: control
                                                                    .models[
                                                                        index]
                                                                    .nextepisode ==
                                                                0
                                                            ? 'unknown'.tr
                                                            : '${'episode'.tr} ${control.models[index].nextepisode} - ${'season'.tr} ${control.models[index].nextSeason}',
                                                        color: orangeColor,
                                                        size: width * 0.04,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CustomText(
                                                        text: 'nextepisodedate'
                                                            .tr,
                                                        color: orangeColor,
                                                        size: width * 0.04,
                                                      ),
                                                      CustomText(
                                                        text: control
                                                                    .models[
                                                                        index]
                                                                    .nextepisode ==
                                                                0
                                                            ? 'unknown'.tr
                                                            : control
                                                                .models[index]
                                                                .nextEpisodeDate,
                                                        color: orangeColor,
                                                        size: width * 0.04,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CustomText(
                                                        text: 'status'.tr,
                                                        color: orangeColor,
                                                        size: width * 0.04,
                                                      ),
                                                      CustomText(
                                                        text: control
                                                            .showStatus(control
                                                                .models[index]
                                                                .status
                                                                .toString()),
                                                        color: orangeColor,
                                                        size: width * 0.04,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 12),
                                          width: width,
                                          height: (height * 0.55) * 0.15,
                                          child: MaterialButton(
                                            onPressed: () =>
                                                control.updateEpisode(index),
                                            color: orangeColor.withOpacity(0.7),
                                            child: CustomText(
                                              text: 'edit'.tr,
                                              color: whiteColor,
                                              size: width * 0.04,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: whiteColor.withOpacity(0.3),
                                  blurRadius: 4,
                                  spreadRadius: 0.1,
                                )
                              ],
                              borderRadius: BorderRadius.circular(10),
                              color: secondaryColor,
                            ),
                            height: height * 0.15,
                            width: width * 0.97,
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: (height * 0.17) * 0.05,
                                      horizontal:
                                          ((width * 0.97) * 0.25) * 0.05),
                                  width: (width * 0.97) * 0.25,
                                  child: ImageNetwork(
                                    link: imagebase +
                                        control.models[index].pic.toString(),
                                    height: (height * 0.17) * 0.95,
                                    width: ((width * 0.97) * 0.25) * 0.95,
                                    color: mainColor,
                                    fit: BoxFit.cover,
                                    isMovie: true,
                                    isShadow: false,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: (height * 0.17) * 0.05,
                                      horizontal: 8),
                                  width: (width * 0.97) * 0.75,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: width * 3,
                                        child: CustomText(
                                          text: control.models[index].name,
                                          color: orangeColor,
                                          size: width * 0.05,
                                          flow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: control.models[index]
                                                          .myEpisode ==
                                                      control.models[index]
                                                          .episode &&
                                                  control.models[index]
                                                          .mySeason ==
                                                      control
                                                          .models[index].season
                                              ? Colors.green.withOpacity(0.7)
                                              : Colors.red.withOpacity(0.7),
                                        ),
                                        child: CustomText(
                                          text:
                                              '${'episode'.tr}: ${control.models[index].myEpisode}  -  ${'season'.tr}: ${control.models[index].mySeason}',
                                          color: whiteColor,
                                          size: width * 0.05,
                                          flow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: (((width * 0.97) * 0.75) *
                                                    0.8) -
                                                8,
                                            child: CustomText(
                                              text: control.models[index]
                                                          .nextEpisodeDate ==
                                                      ''
                                                  ? ''
                                                  : '${'nextepisodedate'.tr} : ${control.models[index].nextEpisodeDate}',
                                              color:
                                                  whiteColor.withOpacity(0.5),
                                              size: width * 0.04,
                                              flow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            width: (((width * 0.97) * 0.75) *
                                                    0.2) -
                                                8,
                                            child: GestureDetector(
                                              onTap: () =>
                                                  Get.find<HomeController>()
                                                      .navToDetale(
                                                          res: Results(
                                                posterPath: imagebase +
                                                    control.models[index].pic
                                                        .toString(),
                                                voteAverage: control
                                                    .models[index].voteAverage,
                                                overview: control
                                                    .models[index].overView,
                                                id: control.models[index].id,
                                                releaseDate: control
                                                    .models[index].releaseDate,
                                                title:
                                                    control.models[index].name,
                                                isShow: true,
                                              )),
                                              child: const Icon(
                                                Icons.home,
                                                color: orangeColor,
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
          }),
        ),
      ),
    );
  }
}
