import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/keeping_controller.dart';
import '../../helper/constants.dart';
import '../../models/results_model.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/keeping_widget.dart';

class KeepingPageAndtoid extends StatelessWidget {
  const KeepingPageAndtoid({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
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
                                    height: height * 0.6,
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
                                                          isIos
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          16.0),
                                                                  child:
                                                                      CupertinoButton(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            100.0)),
                                                                    onPressed: () => control.counting(
                                                                        control
                                                                            .models[index]
                                                                            .myEpisode!
                                                                            .toInt(),
                                                                        index,
                                                                        'add',
                                                                        true),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(0),
                                                                    color: orangeColor
                                                                        .withOpacity(
                                                                            0.7),
                                                                    child:
                                                                        const Icon(
                                                                      CupertinoIcons
                                                                          .add,
                                                                      color:
                                                                          whiteColor,
                                                                    ),
                                                                  ),
                                                                )
                                                              : MaterialButton(
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
                                                                  child:
                                                                      const Icon(
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
                                                          isIos
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          16.0),
                                                                  child:
                                                                      CupertinoButton(
                                                                    onPressed: () => control.counting(
                                                                        control
                                                                            .models[index]
                                                                            .myEpisode!
                                                                            .toInt(),
                                                                        index,
                                                                        'sub',
                                                                        true),
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            100.0)),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(0),
                                                                    color: orangeColor
                                                                        .withOpacity(
                                                                            0.7),
                                                                    child:
                                                                        const Icon(
                                                                      CupertinoIcons
                                                                          .minus,
                                                                      color:
                                                                          whiteColor,
                                                                    ),
                                                                  ),
                                                                )
                                                              : MaterialButton(
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
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .remove,
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
                                                          isIos
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          16.0),
                                                                  child:
                                                                      CupertinoButton(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            100.0)),
                                                                    onPressed: () => control.counting(
                                                                        control
                                                                            .models[index]
                                                                            .mySeason!
                                                                            .toInt(),
                                                                        index,
                                                                        'add',
                                                                        false),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(0),
                                                                    color: orangeColor
                                                                        .withOpacity(
                                                                            0.7),
                                                                    child:
                                                                        const Icon(
                                                                      CupertinoIcons
                                                                          .add,
                                                                      color:
                                                                          whiteColor,
                                                                    ),
                                                                  ),
                                                                )
                                                              : MaterialButton(
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
                                                                  child:
                                                                      const Icon(
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
                                                          isIos
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          16.0),
                                                                  child:
                                                                      CupertinoButton(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            100.0)),
                                                                    onPressed: () => control.counting(
                                                                        control
                                                                            .models[index]
                                                                            .mySeason!
                                                                            .toInt(),
                                                                        index,
                                                                        'sub',
                                                                        false),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(0),
                                                                    color: orangeColor
                                                                        .withOpacity(
                                                                            0.7),
                                                                    child:
                                                                        const Icon(
                                                                      CupertinoIcons
                                                                          .minus,
                                                                      color:
                                                                          whiteColor,
                                                                    ),
                                                                  ),
                                                                )
                                                              : MaterialButton(
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
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .remove,
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
                                                  child: CustomText(
                                                    align: TextAlign.start,
                                                    text:
                                                        '${'lastepisode'.tr}  :  ${'episode'.tr} ${control.models[index].episode} - ${'season'.tr} ${control.models[index].season}',
                                                    color: orangeColor,
                                                    size: width * 0.04,
                                                    isFit: true,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: CustomText(
                                                    text:
                                                        '${'nextepisode'.tr}   :   ${control.models[index].nextepisode == 0 ? 'unknown'.tr : '${'episode'.tr} ${control.models[index].nextepisode} - ${'season'.tr} ${control.models[index].nextSeason}'}',
                                                    color: orangeColor,
                                                    size: width * 0.04,
                                                    isFit: true,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: CustomText(
                                                    text:
                                                        '${'nextepisodedate'.tr}   :   ${control.models[index].nextepisode == 0 ? 'unknown'.tr : control.models[index].nextEpisodeDate}',
                                                    color: orangeColor,
                                                    size: width * 0.04,
                                                    isFit: true,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8),
                                                  child: CustomText(
                                                    text:
                                                        '${'status'.tr}   :   ${control.showStatus(control.models[index].status.toString())}',
                                                    color: orangeColor,
                                                    size: width * 0.04,
                                                    isFit: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        isIos
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: CupertinoButton(
                                                  onPressed: () => control
                                                      .updateEpisode(index),
                                                  color: orangeColor
                                                      .withOpacity(0.7),
                                                  child: CustomText(
                                                    text: 'edit'.tr,
                                                    color: whiteColor,
                                                    size: width * 0.04,
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 12),
                                                width: width,
                                                height: (height * 0.55) * 0.15,
                                                child: MaterialButton(
                                                  onPressed: () => control
                                                      .updateEpisode(index),
                                                  color: orangeColor
                                                      .withOpacity(0.7),
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
                          child: KeepingWidget(
                              isEnglish: control.userModel.language == 'en_US'
                                  ? true
                                  : false,
                              func: () {
                                Get.find<HomeController>().navToDetale(
                                    res: Results(
                                  posterPath: imagebase +
                                      control.models[index].pic.toString(),
                                  voteAverage:
                                      control.models[index].voteAverage,
                                  overview: control.models[index].overView,
                                  id: control.models[index].id,
                                  releaseDate:
                                      control.models[index].releaseDate,
                                  title: control.models[index].name,
                                  isShow: true,
                                ));
                              },
                              even: control.models[index].myEpisode ==
                                          control.models[index].episode &&
                                      control.models[index].mySeason ==
                                          control.models[index].season
                                  ? true
                                  : false,
                              width: width,
                              height: height,
                              title: control.models[index].name.toString(),
                              pic: control.models[index].pic.toString(),
                              episode: int.parse(
                                  control.models[index].myEpisode.toString()),
                              season: int.parse(
                                  control.models[index].mySeason.toString()),
                              id: int.parse(
                                  control.models[index].id.toString()),
                              next: control.models[index].nextEpisodeDate
                                  .toString()),
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
