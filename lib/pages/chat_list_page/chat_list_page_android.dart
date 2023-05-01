import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/chat_list_controller.dart';
import '../../helper/constants.dart';
import '../../models/chat_page_model.dart';
import '../../widgets/cupertino_inkwell.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/image_network.dart';
import '../chat_page/chat_page.dart';

class ChatListPageAndroid extends StatelessWidget {
  final bool isIos;
  const ChatListPageAndroid({super.key, required this.isIos});

  @override
  Widget build(BuildContext context) {
    final ChatListController controller = Get.put(ChatListController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: mainColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
        centerTitle: true,
        title: CustomText(
          text: 'chats'.tr,
          color: orangeColor,
        ),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        var height = constraints.maxHeight;
        var width = constraints.maxWidth;
        return StreamBuilder<QuerySnapshot>(
          stream: controller.straem,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: CustomText(
                  text: 'error'.tr,
                  color: whiteColor,
                  size: width * 0.05,
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: orangeColor,
                ),
              );
            }

            return ListView(
              physics: const BouncingScrollPhysics(),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return SizedBox(
                    height: height * 0.105,
                    width: width,
                    child: !isIos
                        ? InkWell(
                            onTap: () => Get.to(() => const ChatPage(),
                                transition: Transition.native,
                                arguments: ChatPageModel(
                                    userName: data['userNsme'],
                                    userId: data['userId'],
                                    fromList: true)),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: (height * 0.105) * 0.07),
                                  width: width * 0.19,
                                  child: ImageNetwork(
                                    link: data['onlinePath'],
                                    height: (height * 0.105) * 0.85,
                                    width: (height * 0.105) * 0.85,
                                    color: mainColor,
                                    fit: BoxFit.cover,
                                    isMovie: false,
                                    isShadow: false,
                                    borderColor: orangeColor,
                                    borderWidth: 1,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 6),
                                  width: data['isUpdated'] == true
                                      ? width * 0.6
                                      : width * 0.61,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        text: data['userNsme'],
                                        color: orangeColor,
                                        size: width * 0.043,
                                        flow: TextOverflow.ellipsis,
                                        align: TextAlign.start,
                                        maxline: 1,
                                      ),
                                      SizedBox(
                                        height: (height * 0.105) * 0.06,
                                      ),
                                      CustomText(
                                        text: data['messages'].last['text'],
                                        color: whiteColor.withOpacity(0.8),
                                        flow: TextOverflow.ellipsis,
                                        size: width * 0.035,
                                        maxline: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: data['isUpdated'] == true
                                      ? width * 0.21
                                      : width * 0.2,
                                  child: data['isUpdated'] == true
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              text: controller.formatTimestamp(
                                                  DateTime.parse(data['change']
                                                      .toDate()
                                                      .toString())),
                                              color:
                                                  whiteColor.withOpacity(0.8),
                                              size: width * 0.028,
                                              flow: TextOverflow.ellipsis,
                                            ),
                                            Container(
                                              height: width * 0.03,
                                              width: width * 0.03,
                                              decoration: const BoxDecoration(
                                                  color: orangeColor,
                                                  shape: BoxShape.circle),
                                            )
                                          ],
                                        )
                                      : Center(
                                          child: CustomText(
                                            text: controller.formatTimestamp(
                                                DateTime.parse(data['change']
                                                    .toDate()
                                                    .toString())),
                                            color: whiteColor.withOpacity(0.8),
                                            size: width * 0.028,
                                            flow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                )
                              ],
                            ),
                          )
                        : CupertinoInkWell(
                            onPressed: () => Get.to(() => const ChatPage(),
                                arguments: ChatPageModel(
                                    userName: data['userNsme'],
                                    userId: data['userId'],
                                    fromList: true)),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: (height * 0.105) * 0.07),
                                  width: width * 0.19,
                                  child: ImageNetwork(
                                    link: data['onlinePath'],
                                    height: (height * 0.105) * 0.85,
                                    width: (height * 0.105) * 0.85,
                                    color: mainColor,
                                    fit: BoxFit.cover,
                                    isMovie: false,
                                    isShadow: false,
                                    borderColor: orangeColor,
                                    borderWidth: 1,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 6),
                                  width: data['isUpdated'] == true
                                      ? width * 0.6
                                      : width * 0.61,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomText(
                                        text: data['userNsme'],
                                        color: orangeColor,
                                        size: width * 0.043,
                                        flow: TextOverflow.ellipsis,
                                        align: TextAlign.start,
                                        maxline: 1,
                                      ),
                                      SizedBox(
                                        height: (height * 0.105) * 0.06,
                                      ),
                                      CustomText(
                                        text: data['messages'].last['text'],
                                        color: whiteColor.withOpacity(0.8),
                                        flow: TextOverflow.ellipsis,
                                        size: width * 0.035,
                                        maxline: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: data['isUpdated'] == true
                                      ? width * 0.21
                                      : width * 0.2,
                                  child: data['isUpdated'] == true
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              text: controller.formatTimestamp(
                                                  DateTime.parse(data['change']
                                                      .toDate()
                                                      .toString())),
                                              color:
                                                  whiteColor.withOpacity(0.8),
                                              size: width * 0.028,
                                              flow: TextOverflow.ellipsis,
                                            ),
                                            Container(
                                              height: width * 0.03,
                                              width: width * 0.03,
                                              decoration: const BoxDecoration(
                                                  color: orangeColor,
                                                  shape: BoxShape.circle),
                                            )
                                          ],
                                        )
                                      : Center(
                                          child: CustomText(
                                            text: controller.formatTimestamp(
                                                DateTime.parse(data['change']
                                                    .toDate()
                                                    .toString())),
                                            color: whiteColor.withOpacity(0.8),
                                            size: width * 0.028,
                                            flow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                )
                              ],
                            ),
                          )

                    // : CupertinoListTile(
                    //     onTap: () => Get.to(() => const ChatPage(),
                    //         arguments: ChatPageModel(
                    //             userName: data['userNsme'],
                    //             userId: data['userId'],
                    //             fromList: true)),
                    //     title: CustomText(
                    //       text: data['userNsme'],
                    //       color: orangeColor,
                    //       size: width * 0.043,
                    //       flow: TextOverflow.ellipsis,
                    //       align: TextAlign.start,
                    //       maxline: 1,
                    //     ),
                    //     subtitle: CustomText(
                    //       text: data['messages'].last['text'],
                    //       color: whiteColor.withOpacity(0.8),
                    //       flow: TextOverflow.ellipsis,
                    //       size: width * 0.035,
                    //       maxline: 2,
                    //     ),
                    //     leading: FittedBox(
                    //       child: ImageNetwork(
                    //         link: data['onlinePath'],
                    //         height: (height * 0.105) * 0.85,
                    //         width: (height * 0.105) * 0.85,
                    //         color: mainColor,
                    //         fit: BoxFit.cover,
                    //         isMovie: false,
                    //         isShadow: false,
                    //         borderColor: orangeColor,
                    //         borderWidth: 1,
                    //       ),
                    //     ),
                    //   ),
                    );
              }).toList(),
            );
          },
        );
      }),
    );
  }
}
