import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../helper/constants.dart';
import 'custom_text.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final Function() press;
  final double width;
  final double titleSize;
  final bool isIos;
  const RoundButton(
      {Key? key,
      required this.text,
      required this.press,
      required this.width,
      required this.titleSize,
      required this.isIos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: width,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: GetBuilder<AuthController>(
            init: Get.find<AuthController>(),
            builder: (controller) => isIos
                ? CupertinoButton(
                    onPressed: press,
                    color: secondaryColor,
                    child: controller.count == 1
                        ? const CupertinoActivityIndicator(
                            color: orangeColor,
                          )
                        : CustomText(
                            text: text,
                            color: orangeColor,
                            size: titleSize,
                          ),
                  )
                : ElevatedButton(
                    onPressed: press,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor,
                        padding: EdgeInsets.symmetric(vertical: width * 0.04),
                        textStyle: const TextStyle(
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        )),
                    child: controller.count == 1
                        ? const CircularProgressIndicator(
                            color: orangeColor,
                          )
                        : CustomText(
                            text: text,
                            color: orangeColor,
                            size: titleSize,
                          ),
                  ),
          ),
        ));
  }
}
