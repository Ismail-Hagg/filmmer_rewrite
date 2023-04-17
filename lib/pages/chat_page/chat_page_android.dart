import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';

import '../../controllers/chat_page_controller.dart';
import '../../helper/constants.dart';
import '../../widgets/custom_text.dart';

class ChatPageAndroid extends StatelessWidget {
  const ChatPageAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatPageController controller = Get.find<ChatPageController>();
    return Scaffold(
      backgroundColor: mainColor,
      appBar: AppBar(
        backgroundColor: mainColor,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: controller.otherUser.userName,
          flow: TextOverflow.ellipsis,
          color: orangeColor,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
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
              child: CircularProgressIndicator(
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
            builder: (thing) => Chat(
              onAvatarTap: (user) {
                Navigator.of(context).pop();
              },
              theme: const DarkChatTheme(
                  seenIcon: Icon(Icons.hourglass_bottom),
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
          );
        },
      ),
    );
  }
}
