import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/search_page_controller.dart';
import '../../helper/constants.dart';
import '../../models/fire_upload.dart';
import '../../widgets/custom_text.dart';

class SearchPageIos extends StatelessWidget {
  final List<FirebaseSend> lst;
  const SearchPageIos({super.key, required this.lst});

  @override
  Widget build(BuildContext context) {
    final SearchController controller = Get.put(SearchController(list: lst));
    return CupertinoPageScaffold(
      backgroundColor: mainColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: mainColor,
        border: const Border(bottom: BorderSide(color: Colors.transparent)),
        leading: CupertinoButton(
            padding: const EdgeInsets.all(0),
            alignment: Alignment.centerLeft,
            child: const Icon(
              CupertinoIcons.back,
              color: whiteColor,
            ),
            onPressed: () => Get.back()),
        middle: CupertinoSearchTextField(
          suffixMode: OverlayVisibilityMode.editing,
          itemColor: orangeColor,
          style: const TextStyle(color: orangeColor),
          placeholder: 'search'.tr,
          placeholderStyle: TextStyle(color: orangeColor.withOpacity(0.9)),
          focusNode: controller.myFocusNode,
          controller: controller.txtControlller,
          backgroundColor: secondaryColor,
          autofocus: true,
          onChanged: (val) {
            controller.searching(query: val, lst: controller.list);
          },
        ),
      ),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var width = constraints.maxWidth;
        return GetBuilder<SearchController>(
            init: Get.find<SearchController>(),
            builder: (controller) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: controller.display.length,
                    itemBuilder: (context, index) {
                      return CupertinoListTile(
                          backgroundColorActivated: whiteColor.withOpacity(0.3),
                          title: CustomText(
                              text: controller.display[index].name,
                              color: whiteColor,
                              size: width * 0.045),
                          onTap: () {
                            controller.navv(model: controller.display[index]);
                          });
                    },
                  ),
                ));
      }),
    );
  }
}
