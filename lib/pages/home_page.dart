import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
        body: GetBuilder<HomeController>(
      init: Get.find<HomeController>(),
      builder: (build) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(controller.userModel.userName.toString()),
          Text(controller.userModel.userId.toString()),
          Text(controller.userModel.onlinePicPath.toString()),
          isIos
              ? CupertinoButton.filled(
                  child: GetBuilder<AuthController>(
                      init: Get.find<AuthController>(),
                      builder: (controller) => controller.count == 0
                          ? const Text('login')
                          : const CupertinoActivityIndicator(
                              color: Colors.red,
                            )),
                  onPressed: () => Get.find<AuthController>().signOut(),
                )
              : ElevatedButton(
                  onPressed: () => Get.find<AuthController>().signOut(),
                  child: GetBuilder<AuthController>(
                      init: Get.find<AuthController>(),
                      builder: (controller) => controller.count == 0
                          ? const Text('login')
                          : const CircularProgressIndicator(color: Colors.red)),
                ),
          Container(
            color: Colors.greenAccent,
            height: 100,
            width: 100,
            child: FittedBox(
              child: Text(
                'things',
                style: TextStyle(fontSize: 400),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
