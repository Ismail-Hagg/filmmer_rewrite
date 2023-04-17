import 'package:filmmer_rewrite/controllers/chat_page_controller.dart';
import 'package:filmmer_rewrite/pages/chat_page/chat_page_android.dart';
import 'package:filmmer_rewrite/pages/chat_page/chat_page_ios.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/chat_page_model.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final ChatPageController controller =
        Get.put(ChatPageController(context: context, isIos: isIos));
    return isIos ? const ChatPageIos() : const ChatPageAndroid();
  }
}
