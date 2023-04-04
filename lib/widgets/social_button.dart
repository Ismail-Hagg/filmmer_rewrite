import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helper/constants.dart';
import 'custom_text.dart';

class SocialButton extends StatelessWidget {
  final double width;
  final double radius;
  final Function() press;
  final String text;
  final Color textColor;
  final double titleSize;
  final double height;
  final bool isIos;
  const SocialButton(
      {Key? key,
      required this.width,
      required this.radius,
      required this.press,
      required this.text,
      required this.textColor,
      required this.titleSize,
      required this.height,
      required this.isIos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: isIos
            ? CupertinoButton(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: mainColor,
                onPressed: press,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: (width - 32) * 0.85,
                      height: height,
                      child: FittedBox(
                        child: CustomText(
                          text: text,
                          color: textColor,
                          size: titleSize,
                        ),
                      ),
                    ),
                    SvgPicture.asset('assets/images/google.svg',
                        width: height * 0.5, height: height * 0.5),
                  ],
                ),
              )
            : ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                onPressed: press,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: (width - 32) * 0.85,
                      child: FittedBox(
                        child: CustomText(
                          text: text,
                          color: textColor,
                          size: titleSize,
                        ),
                      ),
                    ),
                    FittedBox(
                      child: SvgPicture.asset('assets/images/google.svg',
                          width: height * 0.5, height: height * 0.5),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
