import 'package:filmmer_rewrite/pages/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../helper/constants.dart';
import '../widgets/custom_text.dart';
import '../widgets/input_rounded.dart';
import '../widgets/round_button.dart';
import '../widgets/social_button.dart';
import '../widgets/under_part.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.find<AuthController>();
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(body: LayoutBuilder(
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
                child: Center(
                  child: Icon(
                    Icons.movie_rounded,
                    color: orangeColor,
                    size: width * 0.25,
                  ),
                )),
            Positioned(
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                    color: milkyColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                height: height * 0.6,
                width: width,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SocialButton(
                          isIos: isIos,
                          width: width * 0.8,
                          radius: 6,
                          press: () => controller.loginSignin(
                              isIos: isIos, context: context, method: 'google'),
                          text: 'google'.tr,
                          textColor: orangeColor,
                          titleSize: width * 0.03,
                          height: width * 0.1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                            text: 'emailuse'.tr,
                            color: blackClor,
                            size: width * 0.035,
                            weight: FontWeight.w600),
                      ),
                      GetBuilder<AuthController>(
                        init: controller,
                        builder: (build) => Column(
                          children: [
                            InputRounded(
                                isIos: isIos,
                                action: TextInputAction.next,
                                isTrailing: false,
                                width: width,
                                height: 50,
                                color: mainColor,
                                textColor: orangeColor,
                                leading: const Icon(
                                  Icons.email,
                                  color: orangeColor,
                                ),
                                hint: 'email'.tr,
                                type: TextInputType.emailAddress,
                                controller: controller.emailController,
                                isPass: false),
                            InputRounded(
                                isIos: isIos,
                                action: TextInputAction.done,
                                isTrailing: true,
                                width: width,
                                height: 50,
                                color: mainColor,
                                textColor: orangeColor,
                                leading: const Icon(
                                  Icons.lock,
                                  color: orangeColor,
                                ),
                                hint: 'pass'.tr,
                                type: TextInputType.name,
                                controller: controller.passController,
                                flip: () => build.passAbscure(),
                                isPass: controller.isPasswordAbscured),
                            RoundButton(
                                isIos: isIos,
                                width: width * 0.9,
                                titleSize: width * 0.05,
                                text: 'login'.tr,
                                press: () => controller.loginSignin(
                                    method: 'email-log',
                                    context: context,
                                    isIos: isIos)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: UnderParat(
                          isIos: isIos,
                          titleSize: width * 0.04,
                          titele: 'account'.tr,
                          navigatorText: 'make'.tr,
                          tap: () => controller.moving(method: 'forward'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }));
  }
}
