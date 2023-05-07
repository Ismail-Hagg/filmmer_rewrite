// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../helper/constants.dart';
import '../services/firestore_services.dart';
import 'custom_text.dart';

class DrawerItem extends StatelessWidget {
  DrawerItem(
      {Key? key,
      required this.icon,
      required this.titlel,
      required this.func,
      required this.alarm,
      required this.height,
      required this.width,
      this.collection,
      this.isIos})
      : super(key: key);
  final IconData icon;
  final String titlel;
  final bool alarm;
  final double height;
  final double width;
  String? collection;
  final bool? isIos;
  final Function() func;

  @override
  Widget build(BuildContext context) {
    return isIos == null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(
                icon,
                color: orangeColor,
              ),
              title: CustomText(
                text: titlel,
                size: width * 0.045,
              ),
              trailing: alarm == true
                  ? StreamBuilder<QuerySnapshot>(
                      stream: FirestoreService().isUpdates(
                          Get.find<HomeController>()
                              .userModel
                              .userId
                              .toString(),
                          collection.toString()),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError ||
                            snapshot.connectionState ==
                                ConnectionState.waiting ||
                            snapshot.data!.docs.isEmpty) {
                          return const SizedBox(
                            height: 0,
                            width: 0,
                          );
                        }
                        return Container(
                          height: width * 0.095,
                          width: width * 0.095,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: orangeColor,
                          ),
                          child: Center(
                            child: CustomText(
                              text: snapshot.data!.docs.length.toString(),
                              color: whiteColor,
                              size: width * 0.045,
                            ),
                          ),
                        );
                      },
                    )
                  : const SizedBox(
                      height: 0,
                      width: 0,
                    ),
              onTap: func,
            ),
          )
        : Stack(
            children: [
              Icon(icon),
              StreamBuilder<QuerySnapshot>(
                  stream: FirestoreService().isUpdates(
                      Get.find<HomeController>().userModel.userId.toString(),
                      collection.toString()),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError ||
                        snapshot.connectionState == ConnectionState.waiting ||
                        snapshot.data!.docs.isEmpty) {
                      return const SizedBox(
                        height: 0,
                        width: 0,
                      );
                    }
                    return Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        height: 14,
                        width: 14,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: orangeColor,
                        ),
                        child: CustomText(
                          isFit: true,
                          text: snapshot.data!.docs.length.toString(),
                          color: whiteColor,
                        ),
                      ),
                    );
                  })
            ],
          );
  }
}
