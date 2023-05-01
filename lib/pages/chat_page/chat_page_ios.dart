import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';

import '../../controllers/chat_page_controller.dart';
import '../../helper/constants.dart';
import '../../widgets/custom_text.dart';

class ChatPageIos extends StatelessWidget {
  const ChatPageIos({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatPageController controller = Get.find<ChatPageController>();
    return CupertinoPageScaffold(
      backgroundColor: mainColor,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: mainColor,
        middle: CustomText(
          text: controller.otherUser.userName,
          flow: TextOverflow.ellipsis,
          color: orangeColor,
        ),
        leading: CupertinoButton(
          padding: const EdgeInsets.all(0),
          onPressed: () => controller.back(),
          child: const Icon(
            CupertinoIcons.back,
            color: whiteColor,
          ),
        ),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: controller.straem,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: CustomText(
                text: 'error'.tr,
                color: whiteColor,
                size: 25,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(
                color: orangeColor,
              ),
            );
          }
          snapshot.data!.docs.isNotEmpty
              ? controller.getMessages(snapshot.data!.docs[0]['messages'])
              : () {};
          controller.clearIsUpdated();

          return GetBuilder<ChatPageController>(
            init: Get.find<ChatPageController>(),
            builder: (thing) => Material(
              type: MaterialType.transparency,
              child: Chat(
                onAvatarTap: (user) {
                  Navigator.of(context).pop();
                },
                theme: const DarkChatTheme(
                    seenIcon: Icon(CupertinoIcons.hourglass),
                    inputBackgroundColor: secondaryColor,
                    primaryColor: secondaryColor,
                    secondaryColor: secondaryColor,
                    backgroundColor: mainColor),
                messages: thing.messages,
                onSendPressed: thing.sendMessage,
                showUserAvatars: false,
                showUserNames: false,
                user: thing.user,
                scrollPhysics: const BouncingScrollPhysics(),
                useTopSafeAreaInset: true,
                disableImageGallery: true,
              ),
            ),
          );
        },
      ),
    );
  }
}
