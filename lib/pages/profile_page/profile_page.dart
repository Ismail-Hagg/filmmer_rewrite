import 'package:filmmer_rewrite/pages/profile_page/profile_page_android.dart';
import 'package:filmmer_rewrite/pages/profile_page/profile_page_ios.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return isIos ? const ProfilePageIos() : const ProfilePageAndroid();
  }
}
