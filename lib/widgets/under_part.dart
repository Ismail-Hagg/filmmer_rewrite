import '../widgets/custom_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/constants.dart';

class UnderParat extends StatelessWidget {
  final String titele;
  final String navigatorText;
  final double titleSize;
  final Function()? tap;
  final bool isIos;
  const UnderParat(
      {Key? key,
      required this.titele,
      required this.navigatorText,
      this.tap,
      required this.titleSize,
      required this.isIos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomText(
            text: titele,
            color: mainColor,
            size: titleSize,
            weight: FontWeight.w600,
            flow: TextOverflow.ellipsis,
          ),
          const SizedBox(width: 10),
          isIos
              ? CupertinoButton(
                  onPressed: tap,
                  child: CustomText(
                    text: navigatorText,
                    color: orangeColor,
                    size: titleSize,
                    weight: FontWeight.w600,
                    flow: TextOverflow.ellipsis,
                  ),
                )
              : TextButton(
                  style: TextButton.styleFrom(foregroundColor: orangeColor),
                  onPressed: tap,
                  child: CustomText(
                    text: navigatorText,
                    color: orangeColor,
                    size: titleSize,
                    weight: FontWeight.w600,
                    flow: TextOverflow.ellipsis,
                  ),
                )
        ],
      ),
    );
  }
}
