import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../helper/constants.dart';
import '../models/user_model.dart';

class UserDataPref {
  // save user data
  Future<void> setUser(UserModel model) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(userDataKey, json.encode(model.toMap()));
  }

  // save user data

  // retrieve user data
  Future<UserModel> getUserData() async {
    UserModel model = UserModel();
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      var value = pref.getString(userDataKey);
      model = UserModel.fromMap(json.decode(value.toString()));
      return model;
    } catch (e) {
      model.isError = true;
      model.errorMessage = e.toString();
      return model;
    }
  }

  // delete user data
  Future<void> deleteUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear().then((value) => print('data wiped status ====> $value'));
  }
}
