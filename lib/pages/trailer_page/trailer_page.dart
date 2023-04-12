import 'package:filmmer_rewrite/pages/trailer_page/trailer_page_android.dart';
import 'package:filmmer_rewrite/pages/trailer_page/trailer_page_ios.dart';
import 'package:flutter/material.dart';

class TrailerPage extends StatelessWidget {
  const TrailerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return isIos ? const TrailerPageIos() : const TrailerPageAndroid();
  }
}
