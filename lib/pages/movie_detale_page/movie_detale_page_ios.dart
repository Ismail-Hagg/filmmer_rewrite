import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
import '../../widgets/menu_widget.dart';

class MovieDetalePageIos extends StatelessWidget {
  const MovieDetalePageIos({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: secondaryColor,
      child: GetBuilder<MovieDetaleController>(
          init: Get.put(MovieDetaleController()),
          builder: (controll) => LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                var height = constraints.maxHeight;
                var width = constraints.maxWidth;
                return GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(
                          height: height * 0.44,
                          child: Stack(
                            children: [
                              SizedBox(
                                  height: height * 0.4,
                                  child: GestureDetector(
                                    onTap: () {
                                      controll.getImages(
                                        isIos: true,
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
                                        child: ShapeOfView(
                                            elevation: 25,
                                            shape: ArcShape(
                                                direction: ArcDirection.Outside,
                                                height: 50,
                                                position: ArcPosition.Bottom),
                                            child: CachedNetworkImage(
                                                imageUrl: imagebase +
                                                    controll.detales.posterPath
                                                        .toString(),
                                                imageBuilder: (context,
                                                        imageProvider) =>
                                                    Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ))),
                                                placeholder: (context, url) =>
                                                    Shimmer.fromColors(
                                                      period: const Duration(
                                                          seconds: 1),
                                                      baseColor: mainColor,
                                                      highlightColor:
                                                          secondaryColor,
                                                      child: Container(
                                                        height: height * 0.4,
                                                        color: mainColor,
                                                      ),
                                                    ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                          height: height * 0.4,
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: Image.asset(
                                                                          'assets/images/no_image.png')
                                                                      .image)),
                                                        )))),
                                  )),
                              Positioned(
                                right: 0,
                                left: 0,
                                bottom: 0,
                                child: Material(
                                  color: whiteColor,
                                  shape: const CircleBorder(),
                                  elevation: 12,
                                  child: CupertinoButton(
                                    padding: const EdgeInsets.all(10),
                                    onPressed: () =>
                                        controll.goToTrailer(context: context),
                                    child: controll.loader == 1
                                        ? Center(
                                            child: CupertinoActivityIndicator(
                                                radius: width * 0.06,
                                                color: orangeColor),
                                          )
                                        : Icon(Icons.play_arrow,
                                            color: orangeColor,
                                            size: width * 0.13),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        controll.detales.isShow == false
                                            ? CupertinoButton(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                child: Icon(Icons.add,
                                                    color: orangeColor,
                                                    size: width * 0.08),
                                                onPressed: () => controll.watch(
                                                    context: context))
                                            : Menu(
                                                ios: true,
                                                titles: [
                                                  "addtowatch".tr,
                                                  "addkeep".tr
                                                ],
                                                funcs: [
                                                  () => {
                                                        Get.back(),
                                                        controll.watch(
                                                            context: context)
                                                      },
                                                  () => {
                                                        Get.back(),
                                                        controll.addKeeping(
                                                            context: context)
                                                      }
                                                ],
                                                child: Icon(Icons.add,
                                                    color: orangeColor,
                                                    size: width * 0.08),
                                              ),
                                        Material(
                                          type: MaterialType.transparency,
                                          child: CustomText(
                                            text: controll.detales.voteAverage!
                                                .toString(),
                                            color: orangeColor,
                                            size: width * 0.065,
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                              SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CupertinoButton(
                                          alignment: Alignment.centerLeft,
                                          padding: const EdgeInsets.all(0),
                                          onPressed: () => Get.back(),
                                          child: const Icon(
                                            CupertinoIcons.back,
                                            color: whiteColor,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () => controll.favouriteUpload(
                                              context: context),
                                          child: controll.heart == 0
                                              ? Icon(CupertinoIcons.heart,
                                                  color: whiteColor,
                                                  size: width * 0.08)
                                              : Icon(CupertinoIcons.heart_fill,
                                                  color: orangeColor,
                                                  size: width * 0.08),
                                        ),
                                      ]),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 12),
                          child: CustomText(
                              isMat: true,
                              text: controll.detales.title.toString(),
                              color: whiteColor,
                              size: width * 0.055,
                              maxline: 2,
                              flow: TextOverflow.ellipsis,
                              weight: FontWeight.w500),
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
                                      isMat: true,
                                      text: controll.detales.genres == null
                                          ? 'genre'.tr
                                          : controll.detales.genres![index],
                                      color: orangeColor,
                                      size: width * 0.045);
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return CustomText(
                                      isMat: true,
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
                                        isMat: true,
                                        text: 'Year'.tr,
                                        color: whiteColor,
                                        size: width * 0.04,
                                        flow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 3),
                                      FittedBox(
                                        child: CustomText(
                                          isMat: true,
                                          text: controll.detales.releaseDate
                                              .toString(),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            isMat: true,
                                            text: 'country'.tr,
                                            color: whiteColor,
                                            size: width * 0.04,
                                            flow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 3),
                                          FittedBox(
                                            child: CustomText(
                                              isMat: true,
                                              align: TextAlign.center,
                                              text: controll.detales
                                                          .originCountry ==
                                                      ''
                                                  ? 'country'.tr
                                                  : controll
                                                      .detales.originCountry,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CustomText(
                                            isMat: true,
                                            text: controll.detales.isError ==
                                                    false
                                                ? controll.detales.isShow ==
                                                        false
                                                    ? 'length'.tr
                                                    : 'seasons'.tr
                                                : controll.detales.isShow ==
                                                        false
                                                    ? 'length'.tr
                                                    : 'seasons'.tr,
                                            color: whiteColor,
                                            size: width * 0.04,
                                            flow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 3),
                                          FittedBox(
                                            child: CustomText(
                                              isMat: true,
                                              text: controll.detales.isShow ==
                                                      false
                                                  ? getTimeString(controll
                                                      .detales.runtime as int)
                                                  : controll.detales.runtime
                                                      .toString(),
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
                                  isMat: true,
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
                        controll.detales.cast!.isError == false &&
                                controll.detales.cast!.cast!.isNotEmpty
                            ? controll.detales.cast!.cast![0].id != 0
                                ? Material(
                                    type: MaterialType.transparency,
                                    child: ContentScrolling(
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
                                        loading: controll.loader),
                                  )
                                : Material(
                                    type: MaterialType.transparency,
                                    child: ContentScrolling(
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
                                        loading: controll.loader),
                                  )
                            : controll.detales.cast!.isError == false &&
                                    controll.detales.cast!.cast!.isEmpty
                                ? Container()
                                : Material(
                                    type: MaterialType.transparency,
                                    child: ContentScrolling(
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
                                        reload: () => controll.getData(
                                            res: controll.detales),
                                        textColor: whiteColor,
                                        isFirstPage: false,
                                        height: constraints.maxHeight * 0.2,
                                        loading: controll.loader),
                                  ),
                        controll.detales.recomendation!.isError == false
                            ? controll.detales.recomendation == null ||
                                    controll
                                        .detales.recomendation!.results!.isEmpty
                                ? Container()
                                : controll.detales.recomendation!.results![0]
                                            .id !=
                                        0
                                    ? Material(
                                        type: MaterialType.transparency,
                                        child: ContentScrolling(
                                            color: orangeColor,
                                            borderColor: orangeColor,
                                            inHeight:
                                                constraints.maxHeight * 0.27,
                                            inWidth:
                                                constraints.maxWidth * 0.37,
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
                                            loading: controll.loader),
                                      )
                                    : Container()
                            : Container(),
                        controll.detales.isError == false
                            ? Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                            child: CupertinoTextField(
                                          placeholderStyle: TextStyle(
                                              color: orangeColor,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04),
                                          placeholder: 'comments'.tr,
                                          controller: controll.txtControlller,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: null,
                                          cursorColor: orangeColor,
                                          decoration: const BoxDecoration(
                                              color: mainColor),
                                          style: TextStyle(
                                              color: orangeColor,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04),
                                        )),
                                        controll.commentLoader == 0
                                            ? CupertinoButton(
                                                child: Icon(
                                                    CupertinoIcons.paperplane,
                                                    color: orangeColor,
                                                    size: width * 0.06),
                                                onPressed: () =>
                                                    controll.uploadComment(
                                                        context: context,
                                                        movieId: controll
                                                            .detales.id
                                                            .toString(),
                                                        comment: controll
                                                            .txtControlller.text
                                                            .trim()))
                                            : const Center(
                                                child:
                                                    CupertinoActivityIndicator(
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
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: CupertinoActivityIndicator(
                                              color: orangeColor,
                                            ),
                                          );
                                        }
                                        controll.modelComments(
                                            lst: snapshot.data!.docs);
                                        return Column(
                                            children: List.generate(
                                                controll.commentsList.length,
                                                (index) => Material(
                                                      type: MaterialType
                                                          .transparency,
                                                      child: Comments(
                                                          isIos: true,
                                                          controller: controll,
                                                          showView: true,
                                                          width: width,
                                                          comment: controll
                                                                  .commentsList[
                                                              index],
                                                          like: () => controll.likeSystem(
                                                              true,
                                                              controll
                                                                  .commentsList[
                                                                      index]
                                                                  .postId,
                                                              controll
                                                                  .detales.id
                                                                  .toString(),
                                                              snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id,
                                                              controll
                                                                  .commentsList[
                                                                      index]
                                                                  .likeCount),
                                                          delete: () => controll.deleteComment(
                                                              context: context,
                                                              movieId: controll
                                                                  .detales.id
                                                                  .toString(),
                                                              postId: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id),
                                                          nav: () => controll.navToSubComment(
                                                              controller: controll,
                                                              movieId: controll.detales.id.toString(),
                                                              postId: controll.commentsList[index].postId,
                                                              firePostId: snapshot.data!.docs[index].id,
                                                              userId: controll.commentsList[index].userId,
                                                              token: controll.commentsList[index].token),
                                                          disLike: () => controll.likeSystem(false, controll.commentsList[index].postId, controll.detales.id.toString(), snapshot.data!.docs[index].id, controll.commentsList[index].dislikeCount)),
                                                    )));
                                      }),
                                ],
                              )
                            : Container()
                      ],
                    ),
                  ),
                );
              })),
    );
  }
}
