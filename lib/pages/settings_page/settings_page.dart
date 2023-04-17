import 'package:filmmer_rewrite/pages/settings_page/settings_page_android.dart';
import 'package:filmmer_rewrite/pages/settings_page/settings_page_ios.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return isIos ? const SettingsPageIos() : const SettingsPageAndroid();
  }
}
