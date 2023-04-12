import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/movie_detale_controller.dart';
import '../helper/constants.dart';
import '../helper/utils.dart';
import '../models/comment_model.dart';
import '../models/profile_model.dart';
import 'circle_container.dart';
import 'custom_text.dart';
import 'image_network.dart';

class Comments extends StatelessWidget {
  final MovieDetaleController controller;
  final bool showView;
  final double width;
  CommentModel comment;
  final Function() like;
  final Function() disLike;
  final Function() delete;
  final Function() nav;
  Comments({
    Key? key,
    required this.width,
    required this.comment,
    required this.like,
    required this.delete,
    required this.nav,
    required this.disLike,
    required this.showView,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: nav,
        child: Container(
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: mainColor,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: (width - 16) * 0.2,
                child: GestureDetector(
                  onTap: () => Get.find<MovieDetaleController>().goToProfile(
                      profile: ProfileModel(
                          usreId: comment.userId,
                          usreName: comment.userName,
                          pic: comment.pic,
                          favList: [],
                          watchList: [],
                          nowList: [])),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: comment.isPicOnline == true
                        ? ImageNetwork(
                            link: comment.pic,
                            height: (width - 16) * 0.165,
                            width: (width - 16) * 0.165,
                            color: secondaryColor,
                            fit: BoxFit.cover,
                            borderColor: orangeColor,
                            borderWidth: 1,
                            isMovie: false,
                            isShadow: false,
                          )
                        : CircleContainer(
                            height: (width - 16) * 0.165,
                            width: (width - 16) * 0.165,
                            color: mainColor,
                            shadow: false,
                            icon: Icons.person,
                            iconColor: orangeColor,
                            borderWidth: 1,
                            borderColor: orangeColor,
                            isPicOk: false,
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: SizedBox(
                  width: (width - 16) * 0.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: ((width - 16) * 0.8) * 0.5,
                            child: GestureDetector(
                              onTap: () => Get.find<MovieDetaleController>()
                                  .goToProfile(
                                      profile: ProfileModel(
                                          usreId: comment.userId,
                                          usreName: comment.userName,
                                          pic: comment.pic,
                                          favList: [],
                                          watchList: [],
                                          nowList: [])),
                              child: CustomText(
                                  text: comment.userName,
                                  color: orangeColor,
                                  size: width * 0.045,
                                  flow: TextOverflow.ellipsis,
                                  weight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            width: ((width - 16) * 0.8) * 0.37,
                            child: CustomText(
                              text: timeAgo(comment.timeStamp),
                              color: orangeColor,
                              size: width * 0.037,
                              flow: TextOverflow.ellipsis,
                            ),
                          ),
                          comment.userId == controller.userModel.userId
                              ? SizedBox(
                                  width: ((width - 16) * 0.8) * 0.13,
                                  child: IconButton(
                                      splashRadius: 15,
                                      icon: Icon(Icons.delete,
                                          color: orangeColor,
                                          size: width * 0.06),
                                      onPressed: delete),
                                )
                              : Container(width: 0),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: CustomText(
                          text: comment.comment,
                          color: whiteColor,
                          size: width * 0.045,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: like,
                                child: Icon(Icons.thumb_up,
                                    color: controller.userModel.commentLikes
                                            .toString()
                                            .split(",")
                                            .contains(comment.postId)
                                        ? orangeColor
                                        : whiteColor,
                                    size: width * 0.06),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CustomText(
                                  text: comment.likeCount.toString(),
                                  color: whiteColor,
                                ),
                              ),
                              SizedBox(
                                width: width * 0.03,
                              ),
                              GestureDetector(
                                onTap: disLike,
                                child: Icon(Icons.thumb_down,
                                    color: controller.userModel.commentsDislikes
                                            .toString()
                                            .split(",")
                                            .contains(comment.postId)
                                        ? orangeColor
                                        : whiteColor,
                                    size: width * 0.06),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CustomText(
                                  text: comment.dislikeCount.toString(),
                                  color: whiteColor,
                                ),
                              ),
                            ],
                          ),
                          showView
                              ? comment.subComments.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: TextButton(
                                          style: TextButton.styleFrom(
                                            foregroundColor: orangeColor,
                                          ),
                                          onPressed: nav,
                                          child: CustomText(
                                              text:
                                                  '${comment.subComments.length} ${'replies'.tr}',
                                              color: orangeColor,
                                              size: width * 0.037)),
                                    )
                                  : Container()
                              : Container()
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
