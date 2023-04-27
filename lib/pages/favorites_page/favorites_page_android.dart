import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/favorites_controller.dart';
import '../../helper/constants.dart';
import '../../widgets/custom_text.dart';
import '../search_page/search_page.dart';

class FavoritesPageAndroid extends StatelessWidget {
  const FavoritesPageAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final FavouritesController controller = Get.put(FavouritesController());
    return Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
          backgroundColor: mainColor,
          elevation: 0,
          title: CustomText(
            text: 'favourite'.tr,
            color: orangeColor,
          ),
          actions: [
            IconButton(
              icon: GetBuilder<FavouritesController>(
                init: Get.find<FavouritesController>(),
                builder: (controller) => CustomText(
                  color: whiteColor,
                  text: controller.genreListAdd.isEmpty
                      ? controller.newList.length.toString()
                      : controller.postFilter.length.toString(),
                ),
              ),
              onPressed: null,
            ),
            IconButton(
              icon: const Icon(Icons.search),
              splashRadius: 15,
              onPressed: () {
                Get.to(() => SearchPage(lst: controller.newList));
              },
            ),
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem<int>(
                  value: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("random".tr),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      const Icon(
                        Icons.shuffle,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
                PopupMenuItem<int>(
                  value: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("filter".tr),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      const Icon(
                        Icons.filter_alt,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
              ];
            }, onSelected: (value) {
              if (value == 0) {
                Get.find<FavouritesController>()
                    .randomnav(isIos: isIos, context: context);
              } else if (value == 1) {
                controller.genreFilter();
              }
            }),
          ],
        ),
        body: LayoutBuilder(
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
                                              genre:
                                                  controller.genreList[index],
                                            ),
                                        label: CustomText(
                                            text: controller.genreList[index],
                                            color: mainColor),
                                        selected: controller.chip(
                                            genre:
                                                controller.genreList[index])),
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
                SizedBox(
                  height: controller.filtering ? height * 0.95 : height,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.genreListAdd.isEmpty
                          ? controller.newList.length
                          : controller.postFilter.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            trailing: IconButton(
                              icon:
                                  const Icon(Icons.delete, color: Colors.white),
                              splashRadius: 15,
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
                                size: width * 0.045),
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
            ),
          );
        }));
  }
}
