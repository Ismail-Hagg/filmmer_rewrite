import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/profile_controller.dart';
import '../../helper/constants.dart';
import '../../models/chat_page_model.dart';
import '../../models/user_model.dart';
import '../../widgets/cupertino_inkwell.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/image_network.dart';
import '../chat_page/chat_page.dart';
import '../settings_page/settings_page.dart';

class ProfilePageAndroid extends StatelessWidget {
  const ProfilePageAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    ProfileController controller =
        Get.put(ProfileController(context: context, isIos: isIos));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mainColor,
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var height = constraints.maxHeight;
        var width = constraints.maxWidth;
        return Column(
          children: [
            SizedBox(
              height: height * 0.35,
              width: width,
              child: Column(
                children: [
                  SizedBox(
                    height: (height * 0.35) * 0.8,
                    child: Stack(
                      children: [
                        Container(
                          height: ((height * 0.35) * 0.8) * 0.8,
                          decoration: const BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              )),
                        ),
                        Positioned(
                          bottom: 0,
                          left: width * 0.36,
                          child: ImageNetwork(
                            link: controller.detales.pic,
                            height: ((height * 0.35) * 0.8) * 0.5,
                            width: ((height * 0.35) * 0.8) * 0.5,
                            color: orangeColor,
                            fit: BoxFit.cover,
                            isMovie: false,
                            isShadow: false,
                            borderColor: orangeColor,
                            borderWidth: 1.5,
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                isIos
                                    ? CupertinoButton(
                                        padding: const EdgeInsets.all(0),
                                        child: const Icon(
                                          CupertinoIcons.back,
                                          color: whiteColor,
                                        ),
                                        onPressed: () => controller.goBack(),
                                      )
                                    : GestureDetector(
                                        onTap: () => controller.goBack(),
                                        child: Icon(
                                          Icons.arrow_back,
                                          color: whiteColor,
                                          size: width * 0.065,
                                        ),
                                      ),
                                isIos
                                    ? controller.detales.usreId !=
                                            controller.userModel.userId
                                        ? CupertinoButton(
                                            padding: const EdgeInsets.all(0),
                                            onPressed: () => Get.to(
                                                () => const ChatPage(),
                                                arguments: ChatPageModel(
                                                    userId: controller
                                                        .detales.usreId,
                                                    fromList: false,
                                                    userName: controller
                                                        .detales.usreName,
                                                    userModel: UserModel())),
                                            child: const Icon(
                                              CupertinoIcons.paperplane_fill,
                                              color: whiteColor,
                                            ),
                                          )
                                        : const SizedBox(
                                            width: 0,
                                            height: 0,
                                          )
                                    : GestureDetector(
                                        onTap: controller.detales.usreId !=
                                                controller.userModel.userId
                                            ? () => Get.to(
                                                () => const ChatPage(),
                                                arguments: ChatPageModel(
                                                    userId: controller
                                                        .detales.usreId,
                                                    fromList: false,
                                                    userName: controller
                                                        .detales.usreName,
                                                    userModel: UserModel()))
                                            : () => Get.to(
                                                () => const SettingsPage()),
                                        child: Icon(
                                          controller.detales.usreId ==
                                                  controller.userModel.userId
                                              ? Icons.settings
                                              : Icons.message,
                                          color: whiteColor,
                                          size: width * 0.065,
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: (height * 0.35) * 0.2,
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText(
                        text: controller.detales.usreName,
                        color: orangeColor,
                        size: width * 0.05,
                        align: TextAlign.center,
                        flow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                ],
              ),
            ),
            GetBuilder<ProfileController>(
              init: Get.find<ProfileController>(),
              builder: (controller) => SizedBox(
                height: height * 0.65,
                child: Column(
                  children: [
                    SizedBox(
                      height: (height * 0.65) * 0.1,
                      child: Row(
                        children: [
                          Column(
                            children: [
                              isIos
                                  ? CupertinoInkWell(
                                      onPressed: () => controller.flipper(0),
                                      child: SizedBox(
                                        height: ((height * 0.65) * 0.1) * 0.97,
                                        width: width / 3,
                                        child: Center(
                                          child: CustomText(
                                            text: 'favs'.tr,
                                            color: controller.counter == 0
                                                ? whiteColor
                                                : whiteColor.withOpacity(0.5),
                                            size: width * 0.04,
                                          ),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () => controller.flipper(0),
                                      child: SizedBox(
                                        height: ((height * 0.65) * 0.1) * 0.97,
                                        width: width / 3,
                                        child: Center(
                                          child: CustomText(
                                            text: 'favs'.tr,
                                            color: controller.counter == 0
                                                ? whiteColor
                                                : whiteColor.withOpacity(0.5),
                                            size: width * 0.04,
                                          ),
                                        ),
                                      ),
                                    ),
                              Container(
                                  height: ((height * 0.65) * 0.1) * 0.03,
                                  width: width / 3,
                                  color: controller.counter == 0
                                      ? orangeColor
                                      : Colors.transparent),
                            ],
                          ),
                          Column(
                            children: [
                              isIos
                                  ? CupertinoInkWell(
                                      onPressed: () => controller.flipper(1),
                                      child: SizedBox(
                                        height: ((height * 0.65) * 0.1) * 0.97,
                                        width: width / 3,
                                        child: Center(
                                          child: CustomText(
                                            text: 'wlist'.tr,
                                            color: controller.counter == 1
                                                ? whiteColor
                                                : whiteColor.withOpacity(0.5),
                                            size: width * 0.04,
                                          ),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () => controller.flipper(1),
                                      child: SizedBox(
                                        height: ((height * 0.65) * 0.1) * 0.97,
                                        width: width / 3,
                                        child: Center(
                                          child: CustomText(
                                            text: 'wlist'.tr,
                                            color: controller.counter == 1
                                                ? whiteColor
                                                : whiteColor.withOpacity(0.5),
                                            size: width * 0.04,
                                          ),
                                        ),
                                      ),
                                    ),
                              Container(
                                  height: ((height * 0.65) * 0.1) * 0.03,
                                  width: width / 3,
                                  color: controller.counter == 1
                                      ? orangeColor
                                      : Colors.transparent),
                            ],
                          ),
                          Column(
                            children: [
                              isIos
                                  ? CupertinoInkWell(
                                      onPressed: () => controller.flipper(2),
                                      child: SizedBox(
                                        height: ((height * 0.65) * 0.1) * 0.97,
                                        width: width / 3,
                                        child: Center(
                                          child: CustomText(
                                            text: 'watching'.tr,
                                            color: controller.counter == 2
                                                ? whiteColor
                                                : whiteColor.withOpacity(0.5),
                                            size: width * 0.04,
                                          ),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () => controller.flipper(2),
                                      child: SizedBox(
                                        height: ((height * 0.65) * 0.1) * 0.97,
                                        width: width / 3,
                                        child: Center(
                                          child: CustomText(
                                            text: 'watching'.tr,
                                            color: controller.counter == 2
                                                ? whiteColor
                                                : whiteColor.withOpacity(0.5),
                                            size: width * 0.04,
                                          ),
                                        ),
                                      ),
                                    ),
                              Container(
                                  height: ((height * 0.65) * 0.1) * 0.03,
                                  width: width / 3,
                                  color: controller.counter == 2
                                      ? orangeColor
                                      : Colors.transparent),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: (height * 0.65) * 0.9,
                      color: mainColor,
                      child: controller.loader == 0
                          ? SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Wrap(
                                      alignment: WrapAlignment.center,
                                      direction: Axis.horizontal,
                                      spacing: 2,
                                      runSpacing: 2,
                                      children: List.generate(
                                          controller.counter == 0
                                              ? controller
                                                  .detales.favList.length
                                              : controller.counter == 1
                                                  ? controller
                                                      .detales.watchList.length
                                                  : controller.detales.nowList
                                                      .length, (index) {
                                        return GestureDetector(
                                          onTap: () =>
                                              controller.navToDet(index: index),
                                          // Get.find<
                                          //         HomeController>()
                                          //     .navToDetale(
                                          //         res: controller.counter == 0
                                          //             ? controller.detales
                                          //                 .favList[index]
                                          //             : controller.counter == 1
                                          //                 ? controller.detales
                                          //                     .watchList[index]
                                          //                 : controller.detales
                                          //                     .nowList[index]),
                                          child: ImageNetwork(
                                            borderWidth: 1.5,
                                            borderColor: orangeColor,
                                            rating: controller.counter == 0
                                                ? controller.detales
                                                    .favList[index].voteAverage
                                                    .toString()
                                                    .substring(0, 3)
                                                : controller.counter == 1
                                                    ? controller
                                                        .detales
                                                        .watchList[index]
                                                        .voteAverage
                                                        .toString()
                                                        .substring(0, 3)
                                                    : controller
                                                        .detales
                                                        .nowList[index]
                                                        .voteAverage
                                                        .toString()
                                                        .substring(0, 3),
                                            link: controller.counter == 0
                                                ? imagebase +
                                                    controller
                                                        .detales
                                                        .favList[index]
                                                        .posterPath
                                                        .toString()
                                                : controller.counter == 1
                                                    ? imagebase +
                                                        controller
                                                            .detales
                                                            .watchList[index]
                                                            .posterPath
                                                            .toString()
                                                    : imagebase +
                                                        controller
                                                            .detales
                                                            .nowList[index]
                                                            .posterPath
                                                            .toString(),
                                            height: height * 0.24,
                                            width: constraints.maxWidth * 0.32,
                                            isMovie: true,
                                            isShadow: false,
                                            color: orangeColor,
                                            fit: BoxFit.contain,
                                          ),
                                        );
                                      })),
                                )
                              ]))
                          : const Center(
                              child: CircularProgressIndicator(
                                color: orangeColor,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
