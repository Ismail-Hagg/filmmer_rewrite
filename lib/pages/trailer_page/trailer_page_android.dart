import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pod_player/pod_player.dart';
import 'package:youtube/youtube_thumbnail.dart';

import '../../controllers/trailer_controller.dart';
import '../../helper/constants.dart';
import '../../widgets/cupertino_inkwell.dart';
import '../../widgets/custom_text.dart';

class TrailerPageAndroid extends StatelessWidget {
  const TrailerPageAndroid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: mainColor,
      body: SafeArea(
        child: GetBuilder<TrailerController>(
          init: Get.put(TrailerController()),
          builder: (controller) => Column(children: [
            Stack(children: [
              PodVideoPlayer(controller: controller.controller),
              Positioned(
                top: 0,
                //left: 0,
                child: isIos
                    ? CupertinoButton(
                        padding: const EdgeInsets.all(0),
                        onPressed: () => controller.backing(),
                        child: const Icon(
                          CupertinoIcons.back,
                          color: whiteColor,
                        ),
                      )
                    : IconButton(
                        onPressed: () => controller.backing(),
                        splashRadius: 15,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: whiteColor,
                        )),
              )
            ]),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomText(
                text: controller.title,
                color: whiteColor,
                size: size.width * 0.04,
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: controller.lst.length,
                itemBuilder: (context, index) {
                  return !isIos
                      ? InkWell(
                          onTap: () {
                            controller.change(
                              controller.lst[index].key.toString(),
                              controller.lst[index].name.toString(),
                            );
                          },
                          child: SizedBox(
                            height: ((size.height * 0.648) - 20) * 0.2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.3,
                                    child: Image.network(
                                      YoutubeThumbnail(
                                              youtubeId:
                                                  controller.lst[index].key)
                                          .hd(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: (size.width * 0.7) - 40,
                                    height: ((size.height * 0.648) - 20) * 0.3,
                                    child: CustomText(
                                      text: controller.lst[index].name,
                                      color: Colors.white,
                                      size: size.width * 0.04,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : CupertinoInkWell(
                          onPressed: () {
                            controller.change(
                              controller.lst[index].key.toString(),
                              controller.lst[index].name.toString(),
                            );
                          },
                          child: SizedBox(
                            height: ((size.height * 0.648) - 20) * 0.2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.3,
                                    child: Image.network(
                                      YoutubeThumbnail(
                                              youtubeId:
                                                  controller.lst[index].key)
                                          .hd(),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    width: (size.width * 0.7) - 40,
                                    height: ((size.height * 0.648) - 20) * 0.3,
                                    child: CustomText(
                                      text: controller.lst[index].name,
                                      color: Colors.white,
                                      size: size.width * 0.04,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
