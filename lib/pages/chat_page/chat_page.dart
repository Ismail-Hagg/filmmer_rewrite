import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/chat_page_controller.dart';
import 'chat_page_android.dart';
import 'chat_page_ios.dart';

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
