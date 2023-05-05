import 'package:flutter/material.dart';

import 'chat_list_page_android.dart';

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
