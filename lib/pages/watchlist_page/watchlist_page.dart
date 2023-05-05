import '/pages/watchlist_page/watchlist_page_andtoid.dart';
import '/pages/watchlist_page/watchlist_page_ios.dart';
import 'package:flutter/material.dart';

class WatchListPage extends StatelessWidget {
  const WatchListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return isIos
        ? WatchListIos(isIos: isIos)
        : WatchListPageAndroid(isIos: isIos);
  }
}
