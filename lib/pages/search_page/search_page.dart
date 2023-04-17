import 'package:filmmer_rewrite/pages/search_page/search_page_android.dart';
import 'package:filmmer_rewrite/pages/search_page/search_page_ios.dart';
import 'package:flutter/material.dart';

import '../../models/fire_upload.dart';

class SearchPage extends StatelessWidget {
  final List<FirebaseSend> lst;
  const SearchPage({super.key, required this.lst});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return isIos ? const SearchPageIos() : SearchPageAndroid(lst: lst);
  }
}
