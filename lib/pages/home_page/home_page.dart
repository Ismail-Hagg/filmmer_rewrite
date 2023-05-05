import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../../controllers/home_controller.dart';
import '../../helper/constants.dart';
import '../../widgets/drawer_item_widget.dart';
import 'home_page_android.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final HomeController controller =
        Get.put(HomeController(context: context, isIos: isIos));
    return isIos
        ? Scaffold(
            body: GetBuilder<HomeController>(
              init: controller,
              builder: (build) => build.wdgts[controller.currentIndex],
            ),
            bottomNavigationBar: GetBuilder<HomeController>(
              init: controller,
              builder: (build) => FittedBox(
                child: SalomonBottomBar(
                  backgroundColor: mainColor,
                  currentIndex: build.currentIndex,
                  onTap: (i) => build.indexUpdate(index: i),
                  items: [
                    SalomonBottomBarItem(
                      icon: const Icon(CupertinoIcons.home),
                      title: Text('home'.tr),
                      unselectedColor: whiteColor,
                      selectedColor: orangeColor,
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(CupertinoIcons.list_bullet),
                      title: Text('watchList'.tr),
                      selectedColor: orangeColor,
                      unselectedColor: whiteColor,
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(CupertinoIcons.heart),
                      unselectedColor: whiteColor,
                      title: Text('favourite'.tr),
                      selectedColor: orangeColor,
                    ),
                    SalomonBottomBarItem(
                      icon: DrawerItem(
                        collection: 'episodeKeeping',
                        height: 0,
                        width: 0,
                        alarm: true,
                        func: () {},
                        isIos: true,
                        icon: CupertinoIcons.tv,
                        titlel: '',
                      ),
                      unselectedColor: whiteColor,
                      title: Text('keeping'.tr),
                      selectedColor: orangeColor,
                    ),
                    SalomonBottomBarItem(
                      icon: DrawerItem(
                        collection: 'chats',
                        height: 0,
                        width: 0,
                        alarm: true,
                        func: () {},
                        isIos: true,
                        icon: CupertinoIcons.chat_bubble_2,
                        titlel: '',
                      ),
                      unselectedColor: whiteColor,
                      title: Text('chats'.tr),
                      selectedColor: orangeColor,
                    ),
                    SalomonBottomBarItem(
                      icon: const Icon(CupertinoIcons.settings),
                      unselectedColor: whiteColor,
                      title: Text('settings'.tr),
                      selectedColor: orangeColor,
                    ),
                  ],
                ),
              ),
            ),
          )
        : const HomePageAndroid();
  }
}
