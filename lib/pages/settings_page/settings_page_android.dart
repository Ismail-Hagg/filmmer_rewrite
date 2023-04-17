import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/settings_controller.dart';
import '../../helper/constants.dart';
import '../../widgets/circle_container.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/image_network.dart';

class SettingsPageAndroid extends StatelessWidget {
  const SettingsPageAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: mainColor,
        appBar: AppBar(
          title: CustomText(
            text: 'settings'.tr,
            color: orangeColor,
          ),
          backgroundColor: mainColor,
          elevation: 0,
          centerTitle: true,
        ),
        body: GetBuilder<SettingsController>(
          init: Get.put(SettingsController()),
          builder: (controller) => LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            var height = constraints.maxHeight;
            var width = constraints.maxWidth;
            return Column(
              children: [
                Container(
                    height: height * 0.3,
                    width: width,
                    color: mainColor,
                    child: controller.model.isPicLocal == true
                        ? Padding(
                            padding: EdgeInsets.all(height * 0.01),
                            child: CircleContainer(
                                isFit: true,
                                flow: TextOverflow.ellipsis,
                                topSpacing: height * 0.017,
                                fit: BoxFit.cover,
                                borderWidth: 2,
                                borderColor: orangeColor,
                                char: controller.model.email,
                                charColor: orangeColor,
                                charSize: width * 0.045,
                                name: controller.model.userName,
                                nameColor: milkyColor,
                                nameSize: width * 0.06,
                                color: secondaryColor,
                                height: height * 0.17,
                                isPicOk: true,
                                shadow: false,
                                width: height * 0.17,
                                image: Image.file(File(controller
                                        .model.localPicPath
                                        .toString()))
                                    .image),
                          )
                        : controller.model.onlinePicPath == ''
                            ? Padding(
                                padding: EdgeInsets.all(height * 0.01),
                                child: CircleContainer(
                                  isFit: true,
                                  flow: TextOverflow.ellipsis,
                                  color: secondaryColor,
                                  height: height * 0.17,
                                  isPicOk: false,
                                  shadow: false,
                                  width: height * 0.17,
                                  icon: Icons.person,
                                  iconColor: orangeColor,
                                  borderWidth: 2,
                                  borderColor: orangeColor,
                                  char: controller.model.email,
                                  charColor: orangeColor,
                                  charSize: width * 0.045,
                                  name: controller.model.userName,
                                  nameColor: milkyColor,
                                  nameSize: width * 0.06,
                                  topSpacing: height * 0.017,
                                ),
                              )
                            : Padding(
                                padding: EdgeInsets.all(height * 0.01),
                                child: ImageNetwork(
                                  isFit: true,
                                  topSpacing: height * 0.015,
                                  flow: TextOverflow.ellipsis,
                                  char: controller.model.email,
                                  charColor: orangeColor,
                                  charSize: width * 0.045,
                                  name: controller.model.userName,
                                  nameColor: milkyColor,
                                  nameSize: width * 0.06,
                                  borderWidth: 2,
                                  borderColor: orangeColor,
                                  color: mainColor,
                                  fit: BoxFit.contain,
                                  height: height * 0.17,
                                  isMovie: false,
                                  isShadow: false,
                                  link:
                                      controller.model.onlinePicPath.toString(),
                                  width: height * 0.17,
                                ),
                              )),
                SizedBox(
                  height: constraints.maxHeight * 0.7,
                  child: Card(
                    color: secondaryColor,
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading:
                                const Icon(Icons.photo, color: orangeColor),
                            title: CustomText(
                                size: constraints.maxWidth * 0.04,
                                text: "changepic".tr,
                                color: whiteColor),
                            onTap: () => controller.changeImage(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            leading:
                                const Icon(Icons.language, color: orangeColor),
                            title: CustomText(
                                size: constraints.maxWidth * 0.04,
                                text: "changelanguage".tr,
                                color: whiteColor),
                            onTap: () => controller.langChange(
                              context: context,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                              leading:
                                  const Icon(Icons.person, color: orangeColor),
                              title: CustomText(
                                  size: constraints.maxWidth * 0.04,
                                  text: "changeuser".tr,
                                  color: whiteColor),
                              onTap: () =>
                                  controller.usernameChange(context: context)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                              leading:
                                  const Icon(Icons.info, color: orangeColor),
                              title: CustomText(
                                  size: constraints.maxWidth * 0.04,
                                  text: "about".tr,
                                  color: whiteColor),
                              onTap: () => controller.about(
                                    context: context,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CustomText(
                                            text: 'filmmer'.tr,
                                            size: constraints.maxWidth * 0.04),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0),
                                          child: CustomText(
                                              text:
                                                  '${"dev".tr} : ${"devname".tr}',
                                              size:
                                                  constraints.maxWidth * 0.04),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              GestureDetector(
                                                onTap: () => controller.openUrl(
                                                    context: context,
                                                    url:
                                                        'https://twitter.com/ESMAELNOOR'),
                                                child: Icon(
                                                  LineIcons.twitter,
                                                  color: orangeColor,
                                                  size: width * 0.08,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => controller.openUrl(
                                                    context: context,
                                                    url:
                                                        'https://github.com/Ismail-Hagg'),
                                                child: Icon(
                                                  LineIcons.github,
                                                  color: orangeColor,
                                                  size: width * 0.08,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => controller.openUrl(
                                                    context: context,
                                                    url:
                                                        'https://wa.me/966500258717'),
                                                child: Icon(
                                                  LineIcons.whatSApp,
                                                  color: orangeColor,
                                                  size: width * 0.08,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () => controller.openUrl(
                                                    context: context,
                                                    url: 'tel:+966500258717'),
                                                child: Icon(
                                                  LineIcons.phone,
                                                  color: orangeColor,
                                                  size: width * 0.08,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                              leading:
                                  const Icon(Icons.logout, color: orangeColor),
                              title: CustomText(
                                  size: constraints.maxWidth * 0.04,
                                  text: "logout".tr,
                                  color: whiteColor),
                              onTap: () {
                                Get.defaultDialog(
                                  title: '',
                                  content: Column(
                                    children: [
                                      CustomText(
                                          text: "logoutq".tr,
                                          size: constraints.maxWidth * 0.04),
                                      TextButton(
                                          onPressed: () {
                                            Get.find<AuthController>()
                                                .signOut();
                                          },
                                          child: CustomText(
                                            text: "answer".tr,
                                            size: constraints.maxWidth * 0.04,
                                            color: orangeColor,
                                          ))
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
        ));
  }
}
