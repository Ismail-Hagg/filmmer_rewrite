import 'package:filmmer_rewrite/models/user_model.dart';
import 'package:get/get.dart';

import '../local_storage/local_data_pref.dart';

class HomeController extends GetxController {
  UserModel _userModel = UserModel();
  UserModel get userModel => _userModel;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadUser();
  }

  void loadUser() async {
    await UserDataPref().getUserData().then((value) {
      _userModel = value;
      update();
    });
  }
}
