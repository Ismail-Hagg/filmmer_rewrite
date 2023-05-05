import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/search_more_controller.dart';
import '../../helper/constants.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/image_network.dart';

class SearchMoreIos extends StatelessWidget {
  const SearchMoreIos({super.key});

  @override
  Widget build(BuildContext context) {
    SearchMoreController controller = Get.find<SearchMoreController>();
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mainColor,
      navigationBar: CupertinoNavigationBar(
        border: const Border(bottom: BorderSide(color: Colors.transparent)),
        leading: CupertinoButton(
            padding: const EdgeInsets.all(0),
            alignment: Alignment.centerLeft,
            child: const Icon(
              CupertinoIcons.back,
              color: whiteColor,
            ),
            onPressed: () => Get.back()),
        backgroundColor: mainColor,
        middle: controller.argumentData.isSearch == true
            ? CupertinoSearchTextField(
                suffixMode: OverlayVisibilityMode.editing,
                itemColor: orangeColor,
                style: const TextStyle(color: orangeColor),
                placeholder: 'search'.tr,
                placeholderStyle:
                    TextStyle(color: orangeColor.withOpacity(0.9)),
                focusNode: controller.myFocusNode,
                controller: controller.txt,
                backgroundColor: secondaryColor,
                autofocus: true,
                onSubmitted: (val) {
                  if (val.trim() != '') {
                    controller.searchReady(query: val);
                  }
                },
              )
            : CustomText(
                color: orangeColor,
                text: controller.argumentData.title,
              ),
      ),
      child: GetBuilder<SearchMoreController>(
        init: controller,
        builder: (builder) => LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return builder.indicator == 1
              ? Center(
                  child: CupertinoActivityIndicator(
                  radius: constraints.maxWidth * 0.05,
                  color: orangeColor,
                ))
              : builder.model.results == null
                  ? Container()
                  : builder.model.isError == true
                      ? Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: builder.model.errorMessage,
                              color: orangeColor,
                              size: constraints.maxWidth * 0.05,
                              flow: TextOverflow.visible,
                            ),
                            GestureDetector(
                              onTap: () =>
                                  builder.searchReady(query: builder.query),
                              child: Icon(
                                Icons.refresh,
                                color: orangeColor,
                                size: constraints.maxWidth * 0.25,
                              ),
                            ),
                          ],
                        ))
                      : builder.model.totalResults == 0
                          ? Center(
                              child: CustomText(
                                isMat: true,
                                text: 'res'.tr,
                                size: constraints.maxWidth * 0.05,
                                color: orangeColor,
                              ),
                            )
                          : SizedBox(
                              height: constraints.maxHeight,
                              width: constraints.maxWidth,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: SingleChildScrollView(
                                    controller: builder.scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(children: [
                                      Wrap(
                                          alignment: WrapAlignment.center,
                                          direction: Axis.horizontal,
                                          spacing: 2,
                                          runSpacing: 2,
                                          children: List.generate(
                                              builder.model.results!.length,
                                              (index) {
                                            return GestureDetector(
                                              onTap: () =>
                                                  Get.find<HomeController>()
                                                      .navToDetale(
                                                          res: builder.model
                                                              .results![index]),
                                              child: Material(
                                                type: MaterialType.transparency,
                                                child: ImageNetwork(
                                                  borderWidth: 2,
                                                  borderColor: orangeColor,
                                                  rating: builder
                                                      .model
                                                      .results?[index]
                                                      .voteAverage
                                                      .toString(),
                                                  link: imagebase +
                                                      (builder
                                                              .model
                                                              .results?[index]
                                                              .posterPath)
                                                          .toString(),
                                                  height:
                                                      constraints.maxHeight *
                                                          0.29,
                                                  width: constraints.maxWidth *
                                                      0.32,
                                                  isMovie: true,
                                                  isShadow: false,
                                                  color: orangeColor,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            );
                                          }))
                                    ])),
                              ));
        }),
      ),
    );
  }
}
