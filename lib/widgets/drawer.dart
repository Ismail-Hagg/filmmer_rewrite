import 'dart:io';

import '../controllers/auth_controller.dart';
import '../controllers/home_controller.dart';
import '../pages/favorites_page/favourites_page.dart';
import '../pages/keeping_page/keeping_page_android.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/constants.dart';
import '../models/profile_model.dart';
import '../models/user_model.dart';
import '../pages/chat_list_page/chat_list_page.dart';
import '../pages/profile_page/profile_page.dart';
import '../pages/settings_page/settings_page.dart';
import '../pages/watchlist_page/watchlist_page.dart';
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
        height: height * 0.28,
        color: mainColor,
        child: model.isPicLocal == true
            ? FittedBox(
                child: Padding(
                  padding: EdgeInsets.all(height * 0.01),
                  child: CircleContainer(
                      isFit: true,
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
                        isFit: true,
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
                          isFit: true,
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
              Get.to(() => const ProfilePage(),
                  arguments: ProfileModel(
                      usreId: Get.find<HomeController>()
                          .userModel
                          .userId
                          .toString(),
                      usreName: Get.find<HomeController>()
                          .userModel
                          .userName
                          .toString(),
                      pic: Get.find<HomeController>()
                          .userModel
                          .onlinePicPath
                          .toString(),
                      token: Get.find<HomeController>()
                          .userModel
                          .messagingToken
                          .toString(),
                      favList: [],
                      watchList: [],
                      nowList: []));
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
              Get.to(() => const WatchListPage());
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
              Get.to(() => const FavoritesPage());
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
              Get.to(() => const KeepingPageAndtoid());
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
              Get.to(() => const ChatListPage());
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
              Get.to(
                () => const SettingsPage(),
              );
            },
            icon: Icons.settings_outlined,
          ),
        ],
      ),
    ),
  );
}
