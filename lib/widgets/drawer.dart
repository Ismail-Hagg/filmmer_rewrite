import 'dart:io';

import 'package:filmmer_rewrite/controllers/auth_controller.dart';
import 'package:filmmer_rewrite/controllers/home_controller.dart';
import 'package:filmmer_rewrite/widgets/image_network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/constants.dart';
import '../models/user_model.dart';
import 'circle_container.dart';
import 'drawer_item_widget.dart';

class Draw extends StatelessWidget {
  const Draw({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            header(constraints.maxHeight, constraints.maxWidth),
            drawItems(constraints.maxHeight, constraints.maxWidth)
          ],
        );
      }),
    );
  }
}

Widget header(double height, double width) {
  UserModel model = Get.find<HomeController>().userModel;
  return SafeArea(
      child: GestureDetector(
    onTap: () => Get.find<AuthController>().signOut(),
    child: Container(
        height: height * 0.27,
        color: mainColor,
        child: model.isPicLocal == true
            ? FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(height * 0.01),
                  child: CircleContainer(
                      flow: TextOverflow.ellipsis,
                      topSpacing: height * 0.017,
                      fit: BoxFit.cover,
                      borderWidth: 2,
                      borderColor: orangeColor,
                      char: model.email,
                      charColor: orangeColor,
                      charSize: width * 0.05,
                      name: model.userName,
                      nameColor: milkyColor,
                      nameSize: width * 0.07,
                      color: secondaryColor,
                      height: height * 0.15,
                      isPicOk: true,
                      shadow: false,
                      width: height * 0.15,
                      image: Image.file(File(model.localPicPath.toString()))
                          .image),
                ),
              )
            : model.onlinePicPath == ''
                ? FittedBox(
                    child: Padding(
                      padding: EdgeInsets.all(height * 0.01),
                      child: CircleContainer(
                        flow: TextOverflow.ellipsis,
                        color: secondaryColor,
                        height: height * 0.15,
                        isPicOk: false,
                        shadow: false,
                        width: height * 0.15,
                        icon: Icons.person,
                        iconColor: orangeColor,
                        borderWidth: 2,
                        borderColor: orangeColor,
                        char: model.email,
                        charColor: orangeColor,
                        charSize: width * 0.05,
                        name: model.userName,
                        nameColor: milkyColor,
                        nameSize: width * 0.07,
                        topSpacing: height * 0.017,
                      ),
                    ),
                  )
                : FittedBox(
                    child: Padding(
                      padding: EdgeInsets.all(height * 0.01),
                      child: CircleContainer(
                          flow: TextOverflow.ellipsis,
                          topSpacing: height * 0.017,
                          fit: BoxFit.cover,
                          borderWidth: 2,
                          borderColor: orangeColor,
                          char: model.email,
                          charColor: orangeColor,
                          charSize: width * 0.05,
                          name: model.userName,
                          nameColor: milkyColor,
                          nameSize: width * 0.07,
                          color: secondaryColor,
                          height: height * 0.15,
                          isPicOk: true,
                          shadow: false,
                          width: height * 0.15,
                          image: Image.network(model.onlinePicPath.toString())
                              .image),
                    ),
                  )),
  ));
}

Widget drawItems(double height, double width) {
  return Expanded(
    child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          DrawerItem(
            alarm: false,
            titlel: 'myaccount'.tr,
            width: width,
            height: height,
            func: () {
              Get.back();
              // Get.to(() => ProfilePage(),
              //     arguments: ProfileModel(
              //         usreId: Get.find<HomeController>().model.userId,
              //         usreName: Get.find<HomeController>().model.userName,
              //         pic: Get.find<HomeController>().model.onlinePicPath,
              //         favList: [],
              //         watchList: [],
              //         nowList: []));
            },
            icon: Icons.person_outline,
          ),
          DrawerItem(
            alarm: false,
            titlel: 'watchList'.tr,
            width: width,
            height: height,
            func: () {
              Get.back();
              //Get.to(() => WatchlistPage());
            },
            icon: Icons.list,
          ),
          DrawerItem(
            alarm: false,
            titlel: 'favourite'.tr,
            width: width,
            height: height,
            func: () {
              Get.back();
              //Get.to(() => FavouritesPage());
            },
            icon: Icons.favorite_outline,
          ),
          DrawerItem(
            alarm: true,
            collection: 'episodeKeeping',
            titlel: 'keeping'.tr,
            width: width,
            height: height,
            func: () {
              Get.back();
              //Get.to(() => EpisodeKeepingPage());
            },
            icon: Icons.tv_outlined,
          ),
          DrawerItem(
            alarm: true,
            titlel: 'chats'.tr,
            collection: 'chats',
            width: width,
            height: height,
            func: () {
              Get.back();
              //Get.to(() => ChatListPage());
            },
            icon: Icons.chat_outlined,
          ),
          DrawerItem(
            alarm: false,
            titlel: 'settings'.tr,
            width: width,
            height: height,
            func: () {
              Get.back();
              //Get.to(() => SettingsPage());
            },
            icon: Icons.settings_outlined,
          ),
        ],
      ),
    ),
  );
}
