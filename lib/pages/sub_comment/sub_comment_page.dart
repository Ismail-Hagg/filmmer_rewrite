import 'package:filmmer_rewrite/pages/sub_comment/sub_comment_page_android.dart';
import 'package:filmmer_rewrite/pages/sub_comment/sub_comment_page_ios.dart';
import 'package:flutter/material.dart';

import '../../controllers/movie_detale_controller.dart';

class SubCommentPage extends StatelessWidget {
  final MovieDetaleController pastController;
  final String movieId;
  final String mainPostId;
  final String firePostId;
  final String token;
  const SubCommentPage(
      {super.key,
      required this.pastController,
      required this.movieId,
      required this.mainPostId,
      required this.firePostId,
      required this.token});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return isIos
        ? const SubCommentPageIos()
        : SubbCommentPageAndroid(
            movieId: movieId,
            mainPostId: mainPostId,
            firePostId: firePostId,
            token: token,
            pastController: pastController);
  }
}
