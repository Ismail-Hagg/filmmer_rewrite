import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/search_more_controller.dart';
import '../../helper/constants.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/image_network.dart';

class SearchMoreAndroid extends StatelessWidget {
  const SearchMoreAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    SearchMoreController controller = Get.find<SearchMoreController>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mainColor,
      appBar: controller.argumentData.isSearch == true
          ? AppBar(
              backgroundColor: mainColor,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: TextField(
                      focusNode: controller.myFocusNode,
                      controller: controller.txt,
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
                      onSubmitted: (val) {
                        if (val.trim() != '') {
                          controller.searchReady(query: val);
                        }
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      controller.clearFocus();
                    },
                    splashRadius: 15,
                  ),
                  GetBuilder<SearchMoreController>(
                      init: controller,
                      builder: (builder) => builder.pageLoad == 1
                          ? const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: orangeColor,
                                ),
                              ),
                            )
                          : Container())
                ],
              ))
          : AppBar(
              elevation: 0,
              backgroundColor: mainColor,
              centerTitle: true,
              title: CustomText(
                  text: controller.argumentData.title,
                  color: orangeColor,
                  size: MediaQuery.of(context).size.width * 0.045),
              actions: [
                GetBuilder<SearchMoreController>(
                    init: controller,
                    builder: (builder) => builder.pageLoad == 1
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: orangeColor,
                              ),
                            ),
                          )
                        : Container())
              ],
            ),
      body: GetBuilder<SearchMoreController>(
        init: controller,
        builder: (builder) => LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          return builder.indicator == 1
              ? const Center(
                  child: CircularProgressIndicator(
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
                                text: 'res'.tr,
                                size: constraints.maxWidth * 0.05,
                                color: orangeColor,
                              ),
                            )
                          : SizedBox(
                              height: constraints.maxHeight,
                              width: constraints.maxWidth,
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
                                            child: ImageNetwork(
                                              borderWidth: 2,
                                              borderColor: orangeColor,
                                              rating: builder.model
                                                  .results?[index].voteAverage
                                                  .toString(),
                                              link: imagebase +
                                                  (builder.model.results?[index]
                                                          .posterPath)
                                                      .toString(),
                                              height:
                                                  constraints.maxHeight * 0.29,
                                              width:
                                                  constraints.maxWidth * 0.32,
                                              isMovie: true,
                                              isShadow: false,
                                              color: orangeColor,
                                              fit: BoxFit.contain,
                                            ),
                                          );
                                        }))
                                  ])));
        }),
      ),
    );
  }
}
