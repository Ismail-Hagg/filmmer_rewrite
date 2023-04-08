import 'package:filmmer_rewrite/pages/home_page/home_page_android.dart';
import 'package:filmmer_rewrite/pages/home_page/home_page_ios.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    final HomeController controller =
        Get.put(HomeController(context: context, isIos: isIos));
    return isIos ? const HomePageIos() : const HomePageAndroid();
  }
}
