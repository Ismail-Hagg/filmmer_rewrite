import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/search_page_controller.dart';
import '../../helper/constants.dart';
import '../../models/fire_upload.dart';
import '../../widgets/custom_text.dart';

class SearchPageAndroid extends StatelessWidget {
  final List<FirebaseSend> lst;
  SearchPageAndroid({
    Key? key,
    required this.lst,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchController controller = Get.put(SearchController(list: lst));
    return Scaffold(
        backgroundColor: mainColor,
        appBar: AppBar(
            backgroundColor: mainColor,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextField(
                    controller: controller.txtControlller,
                    focusNode: controller.myFocusNode,
                    cursorColor: orangeColor,
                    autofocus: true,
                    style: TextStyle(
                        color: orangeColor,
                        fontSize: MediaQuery.of(context).size.width * 0.045),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'search'.tr,
                      hintStyle: const TextStyle(
                        color: orangeColor,
                      ),
                    ),
                    onChanged: (val) {
                      controller.searching(query: val, lst: controller.list);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clearThings();
                  },
                  splashRadius: 15,
                ),
              ],
            )),
        body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          var height = constraints.maxHeight;
          var width = constraints.maxWidth;

          return GetBuilder<SearchController>(
            init: Get.find<SearchController>(),
            builder: (controller) => Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.display.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: CustomText(
                          text: controller.display[index].name,
                          color: whiteColor,
                          size: width * 0.045),
                      onTap: () {
                        controller.navv(model: controller.display[index]);
                      });
                },
              ),
            ),
          );
        }));
  }
}
