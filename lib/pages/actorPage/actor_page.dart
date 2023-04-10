import 'package:filmmer_rewrite/pages/actorPage/actor_page_android.dart';
import 'package:flutter/material.dart';
import 'actor_page_ios.dart';

class ActorPage extends StatelessWidget {
  const ActorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return isIos ? const ActorPageIos() : const ActorPageAndroid();
  }
}
