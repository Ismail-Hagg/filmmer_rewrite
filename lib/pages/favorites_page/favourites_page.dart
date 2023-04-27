import 'package:filmmer_rewrite/pages/favorites_page/favorites_page_android.dart';
import 'package:filmmer_rewrite/pages/favorites_page/favorites_page_ios.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return isIos ? const FavoritesPageIos() : const FavoritesPageAndroid();
  }
}
