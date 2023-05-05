import 'package:flutter/material.dart';

import 'favorites_page_android.dart';
import 'favorites_page_ios.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return isIos ? const FavoritesPageIos() : const FavoritesPageAndroid();
  }
}
