import '/pages/search_more_page/search_more_ios.dart';
import '/pages/search_more_page/search_more_nadroid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/search_more_controller.dart';

class SearchMorePage extends StatelessWidget {
  const SearchMorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final SearchMoreController controller =
        Get.put(SearchMoreController(isIos: isIos, context: context));
    return isIos ? const SearchMoreIos() : const SearchMoreAndroid();
  }
}
