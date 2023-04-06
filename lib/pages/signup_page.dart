import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../controllers/auth_controller.dart';
import '../helper/constants.dart';
import '../widgets/circle_container.dart';
import '../widgets/input_rounded.dart';
import '../widgets/round_button.dart';
import '../widgets/under_part.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          var width = constraints.maxWidth;
          var height = constraints.maxHeight;
          return SizedBox(
            height: height,
            child: Stack(
              children: [
                Container(
                  height: (height * 0.5),
                  color: mainColor,
                ),
                Positioned(
                    bottom: 0,
                    child: Container(
                      height: height * 0.7,
                      width: width,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 214, 211, 211),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50))),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  child: GetBuilder<AuthController>(
                                    init: controller,
                                    builder: (controller) => Stack(
                                      children: [
                                        CircleContainer(
                                          isPicOk: controller.isPicked,
                                          image: Image.file(controller.image)
                                              .image,
                                          fit: BoxFit.cover,
                                          shadow: true,
                                          color: mainColor,
                                          height: width * 0.35,
                                          width: width * 0.35,
                                          icon: Icons.person,
                                          borderWidth: 2,
                                          borderColor: orangeColor,
                                          iconColor: orangeColor,
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: width * 0.03,
                                          child: GestureDetector(
                                            onTap: () =>
                                                controller.openImagePicker(),
                                            child: CircleContainer(
                                              isPicOk: false,
                                              iconColor: whiteColor,
                                              shadow: false,
                                              color: orangeColor,
                                              height: width * 0.08,
                                              width: width * 0.08,
                                              icon: controller.isPicked == false
                                                  ? Icons.add
                                                  : Icons.delete,
                                              borderWidth: 1,
                                              borderColor: orangeColor,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                InputRounded(
                                  isIos: isIos,
                                  action: TextInputAction.next,
                                  isTrailing: false,
                                  width: width,
                                  height: 50,
                                  isPass: false,
                                  hint: 'name'.tr,
                                  color: mainColor,
                                  textColor: orangeColor,
                                  leading: const Icon(
                                    Icons.person,
                                    color: orangeColor,
                                  ),
                                  type: TextInputType.name,
                                  controller: controller.userController,
                                ),
                                InputRounded(
                                  isIos: isIos,
                                  action: TextInputAction.next,
                                  isTrailing: false,
                                  width: width,
                                  height: 50,
                                  isPass: false,
                                  color: mainColor,
                                  textColor: orangeColor,
                                  leading: const Icon(
                                    Icons.email,
                                    color: orangeColor,
                                  ),
                                  hint: 'email'.tr,
                                  type: TextInputType.emailAddress,
                                  controller: controller.emailController,
                                ),
                                InputRounded(
                                  isIos: isIos,
                                  action: TextInputAction.done,
                                  isTrailing: false,
                                  width: width,
                                  height: 50,
                                  isPass: false,
                                  color: mainColor,
                                  textColor: orangeColor,
                                  leading: const Icon(
                                    Icons.lock,
                                    color: orangeColor,
                                  ),
                                  hint: 'pass'.tr,
                                  type: TextInputType.text,
                                  controller: controller.passController,
                                ),
                                RoundButton(
                                    isIos: isIos,
                                    width: width * 0.8,
                                    titleSize: width * 0.05,
                                    text: 'make'.tr,
                                    press: () => controller.loginSignin(
                                        context: context,
                                        isIos: isIos,
                                        method: 'email-sign')),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: UnderParat(
                                    isIos: isIos,
                                    titleSize: width * 0.04,
                                    titele: 'already'.tr,
                                    navigatorText: 'Login'.tr,
                                    tap: () => controller.moving(method: ''),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ))
              ],
            ),
          );
        }),
      ),
    );
  }
}
