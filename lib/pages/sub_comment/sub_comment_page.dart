import '/pages/sub_comment/sub_comment_page_android.dart';
import 'package:flutter/material.dart';

import '../../controllers/movie_detale_controller.dart';

class SubCommentPage extends StatelessWidget {
  final MovieDetaleController pastController;
  final String movieId;
  final String mainPostId;
  final String firePostId;
  final String token;
  final String userId;
  const SubCommentPage(
      {super.key,
      required this.pastController,
      required this.movieId,
      required this.mainPostId,
      required this.firePostId,
      required this.token,
      required this.userId});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return SubbCommentPageAndroid(
        movieId: movieId,
        mainPostId: mainPostId,
        firePostId: firePostId,
        token: token,
        userId: userId,
        isIos: isIos,
        pastController: pastController);
  }
}
