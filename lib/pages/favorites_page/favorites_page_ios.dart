import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/favorites_controller.dart';
import '../../helper/constants.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/menu_widget.dart';
import '../search_page/search_page.dart';

class FavoritesPageIos extends StatelessWidget {
  const FavoritesPageIos({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    var size = MediaQuery.of(context).size;
    final FavouritesController controller = Get.put(FavouritesController());
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mainColor,
      navigationBar: CupertinoNavigationBar(
        border: const Border(bottom: BorderSide(color: Colors.transparent)),
        backgroundColor: mainColor,
        middle: CustomText(
          text: 'favourite'.tr,
          color: orangeColor,
        ),
        trailing: GetBuilder<FavouritesController>(
          init: Get.find<FavouritesController>(),
          builder: (bro) => CustomText(
            color: whiteColor,
            text: controller.genreListAdd.isEmpty
                ? controller.newList.length.toString()
                : controller.postFilter.length.toString(),
            size: size.width * 0.04,
            isMat: true,
          ),
        ),
        leading: FittedBox(
          child: Row(
            children: [
              Menu(
                ios: true,
                titles: ["random".tr, "filter".tr],
                funcs: [
                  () {
                    Get.back();
                    Get.find<FavouritesController>()
                        .randomnav(context: context, isIos: isIos);
                  },
                  () {
                    Get.back();
                    controller.genreFilter();
                  },
                ],
                child: const Icon(
                  Icons.more_vert,
                  color: whiteColor,
                ),
              ),
              CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: const Icon(
                    CupertinoIcons.search,
                    color: whiteColor,
                  ),
                  onPressed: () =>
                      Get.to(() => SearchPage(lst: controller.newList)))
            ],
          ),
        ),
      ),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var height = constraints.maxHeight;
        var width = constraints.maxWidth;
        return GetBuilder<FavouritesController>(
            init: Get.find<FavouritesController>(),
            builder: (controller) => Column(
                  children: [
                    controller.filtering
                        ? SizedBox(
                            height: height * 0.05,
                            width: width,
                            child: Row(
                              children: [
                                SizedBox(
                                  height: height * 0.05,
                                  width: width * 0.9,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: controller.genreList.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.005),
                                        child: ChoiceChip(
                                            selectedColor: orangeColor,
                                            disabledColor: secondaryColor,
                                            onSelected: (value) =>
                                                controller.addSelected(
                                                  genre: controller
                                                      .genreList[index],
                                                ),
                                            label: CustomText(
                                                text:
                                                    controller.genreList[index],
                                                color: mainColor),
                                            selected: controller.chip(
                                                genre: controller
                                                    .genreList[index])),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.05,
                                  width: width * 0.1,
                                  child: Center(
                                    child: GestureDetector(
                                      onTap: () => controller.genreFilter(),
                                      child: const Icon(
                                        Icons.cancel,
                                        color: orangeColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.genreListAdd.isEmpty
                              ? controller.newList.length
                              : controller.postFilter.length,
                          itemBuilder: (context, index) {
                            return CupertinoListTile(
                                backgroundColorActivated:
                                    whiteColor.withOpacity(0.3),
                                trailing: CupertinoButton(
                                  padding: const EdgeInsets.all(0),
                                  child: Icon(CupertinoIcons.delete_solid,
                                      color: whiteColor.withOpacity(0.8)),
                                  onPressed: () {
                                    controller.localDelete(
                                      context: context,
                                      id: controller.genreListAdd.isEmpty
                                          ? controller.newList[index].id
                                          : controller.postFilter[index].id,
                                      index: index,
                                      send: controller.genreListAdd.isEmpty
                                          ? controller.newList[index]
                                          : controller.postFilter[index],
                                    );
                                  },
                                ),
                                title: CustomText(
                                    text: controller.genreListAdd.isEmpty
                                        ? controller.newList[index].name
                                        : controller.postFilter[index].name,
                                    color: whiteColor,
                                    size: width * 0.04),
                                onTap: () {
                                  controller.navv(
                                      model: controller.genreListAdd.isEmpty
                                          ? controller.newList[index]
                                          : controller.postFilter[index]);
                                });
                          },
                        ),
                      ),
                    ),
                  ],
                ));
      }),
    );
  }
}
