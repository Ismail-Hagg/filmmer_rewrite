import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shape_of_view_null_safe/shape_of_view_null_safe.dart';
import 'package:shimmer/shimmer.dart';

import '../../controllers/movie_detale_controller.dart';
import '../../helper/constants.dart';
import '../../helper/utils.dart';
import '../../widgets/comment_widget.dart';
import '../../widgets/content_scrolling.dart';
import '../../widgets/custom_text.dart';

class MovieDetalePageAndroid extends StatelessWidget {
  const MovieDetalePageAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: secondaryColor,
      body: GetBuilder<MovieDetaleController>(
        init: Get.put(MovieDetaleController()),
        builder: (controll) => LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          var height = constraints.maxHeight;
          var width = constraints.maxWidth;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.44,
                  child: Stack(children: [
                    SizedBox(
                      height: height * 0.4,
                      child: GestureDetector(
                        onTap: () {
                          controll.getImages(
                            height: height,
                            width: width,
                            isActor: false,
                            id: controll.detales.id.toString(),
                          );
                        },
                        child: ShapeOfView(
                            elevation: 25,
                            shape: ArcShape(
                                direction: ArcDirection.Outside,
                                height: 50,
                                position: ArcPosition.Bottom),
                            child: CachedNetworkImage(
                                imageUrl: imagebase +
                                    controll.detales.posterPath.toString(),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ))),
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                      period: const Duration(seconds: 1),
                                      baseColor: mainColor,
                                      highlightColor: secondaryColor,
                                      child: Container(
                                        height: height * 0.4,
                                        color: mainColor,
                                      ),
                                    ),
                                errorWidget: (context, url, error) => Container(
                                      height: height * 0.4,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: Image.asset(
                                                      'assets/images/no_image.png')
                                                  .image)),
                                    ))),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      left: 0,
                      bottom: 0,
                      child: RawMaterialButton(
                        padding: const EdgeInsets.all(10),
                        elevation: 12,
                        onPressed: () {
                          controll.goToTrailer(context: context);
                        },
                        shape: const CircleBorder(),
                        fillColor: whiteColor,
                        child: controll.loader == 1
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: orangeColor),
                              )
                            : Icon(Icons.play_arrow,
                                color: orangeColor, size: width * 0.13),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              controll.detales.isShow == true
                                  ? PopupMenuButton(
                                      splashRadius: 15,
                                      icon: Icon(Icons.add,
                                          color: orangeColor,
                                          size: width * 0.08),
                                      tooltip: '',
                                      itemBuilder: (context) {
                                        return [
                                          PopupMenuItem<int>(
                                            value: 0,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("addtowatch".tr),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem<int>(
                                            value: 1,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text("addkeep".tr),
                                              ],
                                            ),
                                          ),
                                        ];
                                      },
                                      onSelected: (value) {
                                        if (value == 0) {
                                          controll.watch(context: context);
                                        } else if (value == 1) {
                                          controll.addKeeping(context: context);
                                        }
                                      })
                                  : IconButton(
                                      splashRadius: 15,
                                      icon: Icon(Icons.add,
                                          color: orangeColor,
                                          size: width * 0.08),
                                      onPressed: () =>
                                          controll.watch(context: context)),
                              CustomText(
                                text: controll.detales.voteAverage!.toString(),
                                color: orangeColor,
                                size: width * 0.065,
                              )
                            ]),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(Icons.arrow_back,
                                    color: whiteColor, size: width * 0.067),
                              ),
                              GestureDetector(
                                onTap: () =>
                                    controll.favouriteUpload(context: context),
                                child: controll.heart == 0
                                    ? Icon(Icons.favorite_outline,
                                        color: whiteColor, size: width * 0.08)
                                    : Icon(Icons.favorite,
                                        color: orangeColor, size: width * 0.08),
                              ),
                            ]),
                      ),
                    )
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 12),
                  child: GestureDetector(
                    onTap: () {
                      bool test = Get.isRegistered<MovieDetaleController>();
                      print(test);
                    },
                    child: CustomText(
                        text: controll.detales.title.toString(),
                        color: whiteColor,
                        size: width * 0.055,
                        maxline: 2,
                        flow: TextOverflow.ellipsis,
                        weight: FontWeight.w500),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: SizedBox(
                      height: height * 0.05,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: controll.detales.genres != null
                            ? controll.detales.genres!.length
                            : 3,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return CustomText(
                              text: controll.detales.genres == null
                                  ? 'genre'.tr
                                  : controll.detales.genres![index],
                              color: orangeColor,
                              size: width * 0.045);
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return CustomText(
                              text: ' | ',
                              color: orangeColor,
                              size: width * 0.04);
                        },
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: (width - 32) * 0.2,
                            child: Column(children: [
                              CustomText(
                                text: 'Year'.tr,
                                color: whiteColor,
                                size: width * 0.04,
                                flow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              FittedBox(
                                child: CustomText(
                                  text: controll.detales.releaseDate.toString(),
                                  color: orangeColor,
                                  size: width * 0.04,
                                  weight: FontWeight.bold,
                                  flow: TextOverflow.ellipsis,
                                ),
                              )
                            ])),
                        SizedBox(
                            width: (width - 32) * 0.6,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: 'country'.tr,
                                    color: whiteColor,
                                    size: width * 0.04,
                                    flow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 3),
                                  FittedBox(
                                    child: CustomText(
                                      align: TextAlign.center,
                                      text: controll.detales.originCountry == ''
                                          ? 'country'.tr
                                          : controll.detales.originCountry,
                                      color: orangeColor,
                                      size: width * 0.04,
                                      weight: FontWeight.bold,
                                      flow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ])),
                        SizedBox(
                            width: (width - 32) * 0.2,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: controll.detales.isError == false
                                        ? controll.detales.isShow == false
                                            ? 'length'.tr
                                            : 'seasons'.tr
                                        : controll.detales.isShow == false
                                            ? 'length'.tr
                                            : 'seasons'.tr,
                                    color: whiteColor,
                                    size: width * 0.04,
                                    flow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 3),
                                  FittedBox(
                                    child: CustomText(
                                      text: controll.detales.isShow == false
                                          ? getTimeString(
                                              controll.detales.runtime as int)
                                          : controll.detales.runtime.toString(),
                                      color: orangeColor,
                                      size: width * 0.04,
                                      weight: FontWeight.bold,
                                    ),
                                  )
                                ])),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: SizedBox(
                    height: height * 0.13,
                    child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: CustomText(
                          text: controll.detales.overview.toString(),
                          size: width * 0.036,
                          color: whiteColor,
                          align: controll.userModel.language == 'ar_SA'
                              ? TextAlign.right
                              : TextAlign.left,
                        )),
                  ),
                ),
                const SizedBox(height: 12),
                controll.detales.cast!.isError == false
                    ? controll.detales.cast!.cast![0].id != 0
                        ? ContentScrolling(
                            color: mainColor,
                            inHeight: constraints.maxHeight * 0.12,
                            inWidth: constraints.maxHeight * 0.12,
                            paddingY: 4,
                            pageWidth: constraints.maxWidth,
                            isError: false,
                            isArrow: false,
                            isTitle: true,
                            isMovie: false,
                            isShadow: false,
                            title: 'cast'.tr,
                            fit: BoxFit.cover,
                            detales: controll.detales,
                            reload: () {},
                            textColor: whiteColor,
                            isFirstPage: false,
                            height: constraints.maxHeight * 0.2,
                            loading: controll.loader)
                        : ContentScrolling(
                            isWaiting: true,
                            color: mainColor,
                            inHeight: constraints.maxHeight * 0.12,
                            inWidth: constraints.maxHeight * 0.12,
                            paddingY: 4,
                            pageWidth: constraints.maxWidth,
                            isError: false,
                            isArrow: false,
                            isTitle: true,
                            isMovie: false,
                            isShadow: false,
                            title: 'cast'.tr,
                            fit: BoxFit.contain,
                            detales: controll.detales,
                            reload: () {},
                            textColor: whiteColor,
                            isFirstPage: false,
                            height: constraints.maxHeight * 0.2,
                            loading: controll.loader)
                    : ContentScrolling(
                        color: orangeColor,
                        inHeight: constraints.maxHeight * 0.12,
                        inWidth: constraints.maxHeight * 0.12,
                        paddingY: 4,
                        pageWidth: constraints.maxWidth,
                        isError: true,
                        isArrow: false,
                        isTitle: false,
                        isMovie: false,
                        isShadow: false,
                        fit: BoxFit.contain,
                        reload: () => controll.getData(res: controll.detales),
                        textColor: whiteColor,
                        isFirstPage: false,
                        height: constraints.maxHeight * 0.2,
                        loading: controll.loader),
                controll.detales.recomendation!.isError == false
                    ? controll.detales.recomendation == null ||
                            controll.detales.recomendation!.results!.isEmpty
                        ? Container()
                        : controll.detales.recomendation!.results![0].id != 0
                            ? ContentScrolling(
                                color: orangeColor,
                                borderColor: orangeColor,
                                inHeight: constraints.maxHeight * 0.27,
                                inWidth: constraints.maxWidth * 0.37,
                                paddingY: 4,
                                pageWidth: constraints.maxWidth,
                                borderWidth: 2,
                                isError: false,
                                isArrow: false,
                                isTitle: true,
                                isMovie: true,
                                isShadow: true,
                                title: 'recommendations'.tr,
                                fit: BoxFit.cover,
                                detales: controll.detales,
                                reload: () {},
                                textColor: whiteColor,
                                isFirstPage: false,
                                height: constraints.maxHeight * 0.3,
                                loading: controll.loader)
                            : Container()
                    : Container(),
                controll.detales.isError == false
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                    child: TextField(
                                  controller: controll.txtControlller,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  cursorColor: orangeColor,
                                  style: TextStyle(
                                      color: orangeColor,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'comments'.tr,
                                    hintStyle: const TextStyle(
                                      color: orangeColor,
                                    ),
                                  ),
                                )),
                                controll.commentLoader == 0
                                    ? IconButton(
                                        splashRadius: 15,
                                        icon: Icon(Icons.send,
                                            color: orangeColor,
                                            size: width * 0.06),
                                        onPressed: () => controll.uploadComment(
                                            context: context,
                                            movieId:
                                                controll.detales.id.toString(),
                                            comment: controll
                                                .txtControlller.text
                                                .trim()))
                                    : const Center(
                                        child: CircularProgressIndicator(
                                            color: orangeColor),
                                      ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Divider(
                              color: orangeColor,
                              height: 2,
                            ),
                          ),
                          StreamBuilder(
                              stream: controll.commentStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: orangeColor,
                                    ),
                                  );
                                }
                                controll.modelComments(
                                    lst: snapshot.data!.docs);
                                return Column(
                                    children: List.generate(
                                        controll.commentsList.length,
                                        (index) => Comments(
                                            controller: controll,
                                            showView: true,
                                            width: width,
                                            comment:
                                                controll.commentsList[index],
                                            like: () => controll.likeSystem(
                                                true,
                                                controll
                                                    .commentsList[index].postId,
                                                controll.detales.id.toString(),
                                                snapshot.data!.docs[index].id,
                                                controll.commentsList[index]
                                                    .likeCount),
                                            delete: () => controll.deleteComment(
                                                context: context,
                                                movieId: controll.detales.id
                                                    .toString(),
                                                postId: snapshot
                                                    .data!.docs[index].id),
                                            nav: () => controll.navToSubComment(
                                                controller: controll,
                                                movieId: controll.detales.id
                                                    .toString(),
                                                postId: controll
                                                    .commentsList[index].postId,
                                                firePostId: snapshot
                                                    .data!.docs[index].id,
                                                userId: controll.commentsList[index].userId,
                                                token: controll.commentsList[index].token),
                                            disLike: () => controll.likeSystem(false, controll.commentsList[index].postId, controll.detales.id.toString(), snapshot.data!.docs[index].id, controll.commentsList[index].dislikeCount))));
                              }),
                        ],
                      )
                    : Container()
              ],
            ),
          );
        }),
      ),
    );
  }
}
