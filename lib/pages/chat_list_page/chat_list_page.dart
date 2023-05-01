import 'package:filmmer_rewrite/pages/chat_list_page/chat_list_page_android.dart';

import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    // final ChatPageController controller =
    //     Get.put(ChatPageController(context: context, isIos: isIos));
    return ChatListPageAndroid(isIos: isIos);
  }
}
