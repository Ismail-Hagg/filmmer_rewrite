import 'package:filmmer_rewrite/helper/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';

class HomePageIos extends StatelessWidget {
  const HomePageIos({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find<HomeController>();
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: mainColor,
        middle: Text('Title Here'),
      ),
      child: Icon(CupertinoIcons.share),
    );
  }
}
