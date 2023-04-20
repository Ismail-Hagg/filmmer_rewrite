import 'package:filmmer_rewrite/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/constants.dart';
import 'image_network.dart';

class KeepingWidget extends StatelessWidget {
  final double width;
  final double height;
  final String title;
  final String pic;
  final int episode;
  final int season;
  final int id;
  final String next;
  final bool even;
  final bool isEnglish;
  final Function() func;

  const KeepingWidget(
      {super.key,
      required this.width,
      required this.height,
      required this.title,
      required this.pic,
      required this.episode,
      required this.season,
      required this.id,
      required this.next,
      required this.even,
      required this.func,
      required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: whiteColor.withOpacity(0.3),
            blurRadius: 4,
            spreadRadius: 0.1,
          )
        ],
        borderRadius: BorderRadius.circular(10),
        color: secondaryColor,
      ),
      height: height * 0.15,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            width: width * 0.25,
            child: ImageNetwork(
              link: imagebase + pic,
              height: (height * 0.17) * 0.95,
              width: ((width * 0.97) * 0.25) * 0.95,
              color: mainColor,
              fit: BoxFit.cover,
              isMovie: true,
              isShadow: false,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            width: width * 0.75,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: ((height * 0.15) - 12) * 0.28,
                  child: CustomText(
                    text: title,
                    color: orangeColor,
                    size: width * 0.05,
                    flow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: even
                        ? Colors.green.withOpacity(0.7)
                        : Colors.red.withOpacity(0.7),
                  ),
                  child: FittedBox(
                    child: CustomText(
                      text:
                          '${'episode'.tr}: $episode  -  ${'season'.tr}: $season',
                      color: whiteColor,
                      size: width * 0.05,
                      //isFit: true,
                      flow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: ((height * 0.15) - 12) * 0.22,
                      width: ((width * 0.75) - 12) * 0.85,
                      child: FittedBox(
                        alignment: isEnglish
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: CustomText(
                          align: TextAlign.left,
                          text: next == ''
                              ? ''
                              : '${'nextepisodedate'.tr} : $next',
                          color: whiteColor.withOpacity(0.5),
                          size: width * 0.045,
                          flow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Container(
                      width: ((width * 0.75) - 12) * 0.15,
                      child: GestureDetector(
                        onTap: func,
                        child: const Icon(
                          Icons.home,
                          color: orangeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
