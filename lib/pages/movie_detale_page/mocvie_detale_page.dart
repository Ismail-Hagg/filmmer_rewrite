import 'package:filmmer_rewrite/pages/movie_detale_page/movie_detale_page_ios.dart';
import 'package:flutter/material.dart';
import 'movie_detale_page_amdroid.dart';

class MovieDetalePage extends StatelessWidget {
  const MovieDetalePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return isIos ? const MovieDetalePageIos() : const MovieDetalePageAndroid();
  }
}
