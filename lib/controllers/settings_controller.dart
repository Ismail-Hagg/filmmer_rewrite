import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../helper/utils.dart';
import '../local_storage/local_data_pref.dart';
import '../models/comment_model.dart';
import '../models/user_model.dart';
import '../services/firebase_storage_service.dart';
import '../services/firestore_services.dart';
import 'auth_controller.dart';
import 'home_controller.dart';

class SettingsController extends GetxController {
  final UserModel _model = Get.find<HomeController>().userModel;
  UserModel get model => _model;
  // int counter = 0;
  File _image = File('');
  File get image => _image;

  final TextEditingController _txt = TextEditingController();
  TextEditingController get txt => _txt;

  String _path = '';
  String get path => _path;

  bool _checkPic = false;
  bool get checkPic => _checkPic;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    checking(pic: _model.localPicPath.toString());
  }

  // go to social
  Future<void> openUrl(
      {required String url, required BuildContext context}) async {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    Uri link = Uri.parse(url);
    try {
      await launchUrl(link, mode: LaunchMode.externalApplication);
    } catch (e) {
      platformAlert(
          isIos: isIos,
          title: 'error'.tr,
          body: e.toString(),
          context: context);
    }
  }

  // change user image
  Future<void> changeImage() async {
    final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jpg', 'jpeg']);

    if (result != null) {
      _path = result.files.single.path.toString();
      _image = File(_path.toString());

      _model.isPicLocal = true;
      _model.localPicPath = _path;

      // change local user data
      await UserDataPref().setUser(_model).then((_) async {
        update();
        // upload new image
        await FirebaseStorageService()
            .uploade(id: _model.userId.toString(), file: _image)
            .then((value) async {
          _model.onlinePicPath = value;
          await UserDataPref().setUser(_model);
          // change user data on firebase
          await FirestoreService().userUpdate(
              userId: _model.userId.toString(),
              map: {
                'isPicLocal': true,
                'localPicPath': _path,
                'onlinePicPath': value
              });
          secChange(key: 'pic', newVal: value, isChangeUserName: false);
        });
      });
    }
  }

  // change user name
  void changeUsername() async {
    Get.back();
    if (_txt.text.isNotEmpty) {
      // change username locally
      _model.userName = _txt.text.trim();
      await UserDataPref().setUser(_model).then((value) async {
        update();
        // change username on firebase
        await FirestoreService().userUpdate(
            userId: _model.userId.toString(),
            map: {'userName': _model.userName}).then((value) {
          // change username in comments
          secChange(
              key: 'userName',
              newVal: _model.userName.toString(),
              isChangeUserName: true);
          _txt.clear();
        });
      });
    }

    _txt.clear();
  }

  // change data in comments
  void secChange(
      {required String key,
      required String newVal,
      required bool isChangeUserName}) async {
    late CommentModel commentModel;
    List<dynamic> lst = [];
    await FirestoreService()
        .getCurrentUser(userId: _model.userId.toString())
        .then((value) {
      try {
        lst = value.get('ref');
        for (var i = 0; i < lst.length; i++) {
          DocumentReference docRef = lst[i]['ref'];
          if (lst[i]['isSub'] == false) {
            docRef.update({key: newVal});
          }
          if (isChangeUserName == false) {
            docRef.update({'isPicOnline': true});
          }
          docRef.get().then((value) {
            if ((value.data() as Map<String, dynamic>)['subComments']
                .isNotEmpty) {
              commentModel =
                  CommentModel.fromMap(value.data() as Map<String, dynamic>);
              docRef.update({
                'subComments': refactorThings(
                        model: commentModel,
                        newVal: newVal,
                        myId: _model.userId.toString(),
                        userChange: isChangeUserName)
                    .subComments
              });
            }
            changeChats(_model.userId.toString(),
                isChangeUserName ? 'userNsme' : 'onlinePath', newVal);
          });
        }
      } catch (e) {
        print('=============>>========= $e');
      }
    });
  }

  CommentModel refactorThings(
      {required CommentModel model,
      required String newVal,
      required String myId,
      required bool userChange}) {
    for (var i = 0; i < model.subComments.length; i++) {
      if (model.subComments[i]['userId'] == myId) {
        userChange
            ? model.subComments[i]['userName'] = newVal
            : model.subComments[i]['pic'] = newVal;
      }
    }
    return model;
  }

  // change data in chats
  void changeChats(String userId, String key, String val) async {
    await FirestoreService()
        .getChatCollections(userId: userId)
        .then((value) async {
      DocumentReference ref;
      for (var i = 0; i < value.docs.length; i++) {
        ref = value.docs[i]['ref'];
        ref.update({key: val});
      }
    });
  }

  // about
  void about({required BuildContext context, required Widget child}) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    platforMulti(
        isIos: isIos,
        title: "about".tr,
        buttonTitle: ['ok'.tr],
        body: '',
        func: [
          () {
            Get.back();
          }
        ],
        context: context,
        field: true,
        child: child);
  }

  // change username
  void usernameChange({required BuildContext context}) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    platforMulti(
        isIos: isIos,
        title: "changeuser".tr,
        hint: 'newuser'.tr,
        controller: _txt,
        field: true,
        buttonTitle: ['cancel'.tr, 'answer'.tr],
        body: '',
        func: [
          () {
            Get.back();
            _txt.clear();
          },
          changeUsername
        ],
        context: context);
  }

  //change the app's language
  void langChange({required BuildContext context}) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    String lang = _model.language == 'en_US' ? 'ar_SA' : 'en_US';
    platforMulti(
        isIos: isIos,
        title: 'changelanguage'.tr,
        buttonTitle: ['cancel'.tr, 'answer'.tr],
        body: _model.language == 'en_US'
            ? ' Change To Arabic '
            : ' التغيير الى الانجليزي ',
        func: [
          () {
            Get.back();
          },
          () async {
            Get.back();
            Get.updateLocale(
                Locale(lang.substring(0, 2), lang.substring(3, 5)));
            _model.language = lang;
            await UserDataPref().setUser(_model);
            await FirestoreService().userUpdate(
                userId: _model.userId.toString(), map: {'language': lang});
            Get.find<HomeController>().loadUser();
          }
        ],
        context: context);
  }

  // logout
  void logOut({
    required BuildContext context,
  }) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    platforMulti(
        isIos: isIos,
        title: "logoutq".tr,
        buttonTitle: ['cancel'.tr, "answer".tr],
        body: '',
        func: [
          () {
            Get.back();
          },
          () async {
            Get.back();
            await Get.find<AuthController>().signOut();
          }
        ],
        context: context);
  }

  // check if the profile pic is in the phone
  void checking({required String pic}) async {
    await File(pic).exists().then((value) {
      _checkPic = value;
      update();
    });
  }
}
