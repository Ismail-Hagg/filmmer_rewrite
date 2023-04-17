import 'package:filmmer_rewrite/pages/keeping_page/keeping_page_android.dart';
import 'package:filmmer_rewrite/pages/keeping_page/keeping_page_ios.dart';
import 'package:flutter/material.dart';

class KeepingPage extends StatelessWidget {
  const KeepingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return isIos ? const KeepingPageIos() : const KeepingPageAndtoid();
  }
}
