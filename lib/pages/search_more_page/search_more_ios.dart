import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helper/constants.dart';

class SearchMoreIos extends StatelessWidget {
  const SearchMoreIos({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: mainColor,
        middle: Text('Title Here'),
      ),
      child: Icon(CupertinoIcons.share),
    );
  }
}
