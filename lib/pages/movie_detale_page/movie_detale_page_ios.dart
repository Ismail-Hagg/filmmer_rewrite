import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helper/constants.dart';

class MovieDetalePageIos extends StatelessWidget {
  const MovieDetalePageIos({super.key});

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
