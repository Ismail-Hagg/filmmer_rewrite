import '../pages/control_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'firebase_options.dart';
import 'helper/translation.dart';
import 'local_storage/local_data_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Get.put(AuthController());
  await UserDataPref().getUserData().then((user) {
    user.isError == true
        ? Get.deviceLocale.toString() != 'ar_SA' &&
                Get.deviceLocale.toString() != 'en_US' &&
                Get.deviceLocale.toString() != 'en'
            ? runApp(MyApp(locale: const Locale('en', 'US')))
            : Get.deviceLocale.toString() == 'en'
                ? runApp(MyApp(locale: const Locale('en', 'US')))
                : runApp(MyApp(
                    locale: Locale(Get.deviceLocale.toString().substring(0, 2),
                        Get.deviceLocale.toString().substring(3, 5))))
        : runApp(MyApp(
            locale: Locale(user.language.toString().substring(0, 2),
                user.language.toString().substring(3, 5)),
          ));
  });
}

class MyApp extends StatelessWidget {
  Locale locale;
  MyApp({super.key, required this.locale});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Translation(),
      title: 'Filmmer',
      locale: locale,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ControllerPage(),
    );
  }
}
