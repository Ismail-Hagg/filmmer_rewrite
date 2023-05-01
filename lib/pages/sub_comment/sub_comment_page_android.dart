import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/movie_detale_controller.dart';
import '../../controllers/sub_comment_controller.dart';
import '../../helper/constants.dart';
import '../../widgets/comment_widget.dart';

class SubbCommentPageAndroid extends StatelessWidget {
  final MovieDetaleController pastController;
  final String movieId;
  final String mainPostId;
  final String firePostId;
  final String token;
  final String userId;
  final bool isIos;
  const SubbCommentPageAndroid(
      {Key? key,
      required this.movieId,
      required this.mainPostId,
      required this.firePostId,
      required this.pastController,
      required this.token,
      required this.userId,
      required this.isIos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SubCommentControllrt controller = Get.put(
      SubCommentControllrt(uid: userId),
    );
    return Scaffold(
        //resizeToAvoidBottomInset: false,
        backgroundColor: secondaryColor,
        body: SafeArea(
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            var width = constraints.maxWidth;
            var height = constraints.maxHeight;
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Comments')
                  .doc(movieId)
                  .collection('Comments')
                  .orderBy('timeStamp', descending: false)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: orangeColor,
                    ),
                  );
                }
                controller.modelComments(snapshot.data!.docs, mainPostId);
                return Column(
                  children: [
                    SizedBox(
                      height: height - 55,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Comments(
                              isIos: isIos,
                              controller: pastController,
                              showView: false,
                              width: width,
                              comment: controller.mainComment,
                              like: () => Get.find<MovieDetaleController>()
                                  .likeSystem(
                                      true,
                                      controller.mainComment.postId,
                                      movieId,
                                      firePostId,
                                      controller.mainComment.likeCount),
                              delete: () => controller.deleteReply(
                                context: context,
                                comment: controller.mainComment,
                                movieId: movieId,
                                firePostId: firePostId,
                                postId: controller.mainComment.postId,
                                isSub: controller.mainComment.isSub,
                              ),
                              nav: () {},
                              disLike: () => Get.find<MovieDetaleController>()
                                  .likeSystem(
                                      false,
                                      controller.mainComment.postId,
                                      movieId,
                                      firePostId,
                                      controller.mainComment.dislikeCount),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 16),
                              child: Divider(color: orangeColor, thickness: 2),
                            ),
                            Column(
                                children: List.generate(
                                    controller.commentsList.length, (index) {
                              return Comments(
                                isIos: isIos,
                                controller: pastController,
                                showView: false,
                                width: width,
                                comment: controller.commentsList[index],
                                like: () => controller.subLikeSystem(
                                    isLike: true,
                                    mainPostId: mainPostId,
                                    movieId: movieId,
                                    firePostId: firePostId,
                                    commentList: controller.commentsList,
                                    index: index),
                                delete: () => controller.deleteReply(
                                    context: context,
                                    comment: controller.mainComment,
                                    movieId: movieId,
                                    firePostId: firePostId,
                                    postId:
                                        controller.commentsList[index].postId,
                                    isSub:
                                        controller.commentsList[index].isSub),
                                nav: () {},
                                disLike: () => controller.subLikeSystem(
                                    isLike: false,
                                    mainPostId: mainPostId,
                                    movieId: movieId,
                                    firePostId: firePostId,
                                    commentList: controller.commentsList,
                                    index: index),
                              );
                            }))
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: orangeColor, width: 1)),
                      height: 55,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: isIos
                                    ? CupertinoTextField(
                                        placeholderStyle: const TextStyle(
                                          color: orangeColor,
                                        ),
                                        placeholder: 'comments'.tr,
                                        controller: controller.txtControlller,
                                        focusNode: controller.myFocusNode,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        cursorColor: orangeColor,
                                        style: TextStyle(
                                            color: orangeColor,
                                            fontSize: width * 0.04),
                                        decoration: const BoxDecoration(),
                                      )
                                    : TextField(
                                        controller: controller.txtControlller,
                                        focusNode: controller.myFocusNode,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: null,
                                        cursorColor: orangeColor,
                                        style: TextStyle(
                                            color: orangeColor,
                                            fontSize: width * 0.04),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'comments'.tr,
                                          hintStyle: const TextStyle(
                                            color: orangeColor,
                                          ),
                                        ),
                                      )),
                            GetBuilder(
                              init: controller,
                              builder: (thing) => controller.loader == 0
                                  ? isIos
                                      ? CupertinoButton(
                                          child: const Icon(
                                            CupertinoIcons.paperplane_fill,
                                            color: orangeColor,
                                          ),
                                          onPressed: () {
                                            controller.uploadReply(
                                                comment: controller
                                                    .txtControlller.text
                                                    .trim(),
                                                movieId: movieId,
                                                firePostId: firePostId,
                                                subs: controller
                                                    .mainComment.subComments,
                                                postId: mainPostId,
                                                token: token);
                                          })
                                      : IconButton(
                                          splashRadius: 15,
                                          icon: Icon(Icons.send,
                                              color: orangeColor,
                                              size: width * 0.06),
                                          onPressed: () {
                                            controller.uploadReply(
                                                comment: controller
                                                    .txtControlller.text
                                                    .trim(),
                                                movieId: movieId,
                                                firePostId: firePostId,
                                                subs: controller
                                                    .mainComment.subComments,
                                                postId: mainPostId,
                                                token: token);
                                          })
                                  : Center(
                                      child: isIos
                                          ? const CupertinoActivityIndicator(
                                              color: orangeColor)
                                          : const CircularProgressIndicator(
                                              color: orangeColor),
                                    ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }),
        ));
  }
}
