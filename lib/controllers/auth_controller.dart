import 'dart:io';

import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filmmer_rewrite/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../helper/utils.dart';
import '../local_storage/local_data_pref.dart';
import '../local_storage/local_database.dart';
import '../models/fire_upload.dart';
import '../pages/control_page.dart';
import '../pages/signup_page.dart';
import '../services/firestore_services.dart';
import 'home_controller.dart';

class AuthController extends GetxController {
  final TextEditingController _userController = TextEditingController();
  TextEditingController get userController => _userController;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final TextEditingController _passController = TextEditingController();
  TextEditingController get passController => _passController;
  final GlobalKey _key = GlobalKey<FormState>();
  GlobalKey get formKey => _key;

  bool _isPasswordAbscured = true;
  bool get isPasswordAbscured => _isPasswordAbscured;

  final Rxn<User> _user = Rxn<User>();
  User? get user => _user.value;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  int _count = 0;
  int get count => _count;

  File _image = File('');
  File get image => _image;
  String _path = '';
  String get path => _path;
  bool _isPicked = false;
  bool get isPicked => _isPicked;

  final dbHelper = DatabaseHelper.instance;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _user.bindStream(_auth.authStateChanges());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  // login or sign in begins here
  void loginSignin(
      {required String method,
      required BuildContext context,
      required bool isIos}) async {
    String userName = _userController.text.trim();
    String email = _emailController.text.trim();
    String password = _passController.text.trim();
    FocusScope.of(context).unfocus();
    switch (method) {
      case 'google':
        {
          await googleSignIn(context: context, isIos: isIos);
        }
        break;

      case 'email-log':
        {
          if (email == '' || password == '') {
            platformAlert(
                isIos: isIos,
                title: 'error'.tr,
                body: 'complete'.tr,
                context: context);
          } else {
            await emailLogin(
                isIos: isIos,
                email: email,
                password: password,
                context: context);
          }
        }
        break;

      case 'email-sign':
        {
          if (userName == '' || email == '' || password == '') {
            platformAlert(
                isIos: isIos,
                title: 'error'.tr,
                body: 'complete'.tr,
                context: context);
          } else {
            await emailSignIn(
                isIos: isIos,
                email: email,
                userName: userName,
                password: password,
                context: context);
          }
        }
        break;
    }
  }

  // google sign in method
  Future<void> googleSignIn(
      {required BuildContext context, required bool isIos}) async {
    FocusScope.of(context).unfocus();
    try {
      await GoogleSignIn().signIn().then((value) async {
        if (value != null) {
          _count = 1;
          update();
          final GoogleSignInAuthentication gAuth = await value.authentication;

          final credential = GoogleAuthProvider.credential(
              accessToken: gAuth.accessToken, idToken: gAuth.idToken);

          await _auth.signInWithCredential(credential).then((user) async {
            FirestoreService()
                .getCurrentUser(userId: user.user!.uid)
                .then((value) async {
              if (value.data() == null) {
                // first time sign in with google
                await askToken().then((value) async {
                  UserModel model = UserModel(
                      userName: user.user!.displayName,
                      email: user.user!.email,
                      onlinePicPath: user.user!.photoURL,
                      localPicPath: '',
                      userId: user.user!.uid,
                      isPicLocal: false,
                      language: Get.deviceLocale.toString(),
                      isError: false,
                      messagingToken: value,
                      commentLikes: '',
                      commentsDislikes: '',
                      errorMessage: '');
                  await saveUserData(
                          model: model,
                          isFire: true,
                          context: context,
                          isIos: isIos)
                      .then((value) {
                    Get.offAll(() => const ControllerPage());
                    controllerClear();
                    _count = 0;
                  }).catchError((error) {
                    platformAlert(
                        isIos: isIos,
                        title: 'error'.tr,
                        body: error.toString(),
                        context: context);
                  });
                });
              } else {
                // signed in whith google before
                UserModel model =
                    UserModel.fromMap(value.data() as Map<dynamic, dynamic>);
                await saveUserData(
                        model: model,
                        isFire: false,
                        context: context,
                        isIos: isIos)
                    .then((value) async {
                  if (model.language.toString() !=
                      Get.deviceLocale.toString()) {
                    Get.updateLocale(Locale(
                        model.language.toString().substring(0, 2),
                        model.language.toString().substring(3, 5)));
                  }
                  await getDocs(userId: model.userId.toString())
                      .then((value) async {
                    Get.offAll(() => const ControllerPage());
                    controllerClear();
                    await updateToken(
                        userId: model.userId.toString(),
                        token: model.messagingToken.toString(),
                        model: model);
                    _count = 0;
                  });
                }).catchError((error) {
                  platformAlert(
                      isIos: isIos,
                      title: 'error'.tr,
                      body: error.toString(),
                      context: context);
                });
              }
            });
          });
        }
      });
    } on FirebaseAuthException catch (e) {
      platformAlert(
          isIos: isIos,
          title: 'error'.tr,
          body: getMessageFromErrorCode(e),
          context: context);
      _count = 0;
      update();
    } catch (e) {
      platformAlert(
          isIos: isIos,
          title: 'error'.tr,
          body: e.toString(),
          context: context);
      _count = 0;
      update();
    }
  }

  // sign in with email and password
  Future<void> emailSignIn(
      {required BuildContext context,
      required bool isIos,
      required String email,
      required String userName,
      required String password}) async {
    _count = 1;
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        await askToken().then((value) async {
          UserModel model = UserModel(
              userName: userName,
              email: email,
              onlinePicPath: '',
              localPicPath: _path,
              userId: user.user!.uid,
              isPicLocal: _isPicked,
              language: lanDecide(),
              isError: false,
              messagingToken: value,
              commentLikes: '',
              commentsDislikes: '',
              errorMessage: '');

          await saveUserData(
                  model: model, isFire: true, context: context, isIos: isIos)
              .then((value) {
            Get.offAll(() => const ControllerPage());
            controllerClear();
            _count = 0;
          }).catchError((error) {
            platformAlert(
                isIos: isIos,
                title: 'error'.tr,
                body: error.toString(),
                context: context);
          });
        });
      });
    } on FirebaseAuthException catch (e) {
      _count = 0;
      //update();
      platformAlert(
          isIos: isIos,
          title: 'error'.tr,
          body: getMessageFromErrorCode(e),
          context: context);
    } catch (e) {
      _count = 0;
      update();
      platformAlert(
          isIos: isIos,
          title: 'error'.tr,
          body: e.toString(),
          context: context);
    }
  }

  // login with email and password
  Future<void> emailLogin(
      {required BuildContext context,
      required bool isIos,
      required String email,
      required String password}) async {
    _count = 1;
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) async => {
                await FirestoreService()
                    .getCurrentUser(userId: user.user!.uid)
                    .then((value) async {
                  UserModel model =
                      UserModel.fromMap(value.data() as Map<dynamic, dynamic>);
                  await saveUserData(
                          model: model,
                          isFire: false,
                          context: context,
                          isIos: isIos)
                      .then((value) async {
                    if (model.language.toString() !=
                        Get.deviceLocale.toString()) {
                      Get.updateLocale(Locale(
                          model.language.toString().substring(0, 2),
                          model.language.toString().substring(3, 5)));
                    }
                    await getDocs(userId: model.userId.toString())
                        .then((value) async {
                      Get.offAll(() => const ControllerPage());
                      controllerClear();
                      await updateToken(
                          userId: model.userId.toString(),
                          token: model.messagingToken.toString(),
                          model: model);
                      _count = 0;
                    });
                  });
                })
              });
    } on FirebaseAuthException catch (e) {
      _count = 0;
      platformAlert(
          isIos: isIos,
          title: 'error'.tr,
          body: getMessageFromErrorCode(e),
          context: context);
    } catch (e) {
      _count = 0;
      update();
      platformAlert(
          isIos: isIos,
          title: 'error'.tr,
          body: e.toString(),
          context: context);
    }
  }

  // logout
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
    Get.offAll(() => const ControllerPage());
    await dbHelper.deleteAll(DatabaseHelper.showTable);
    await dbHelper.deleteAll(DatabaseHelper.movieTable);
    await dbHelper.deleteAll(DatabaseHelper.table);
    await UserDataPref().deleteUser();
    Get.delete<HomeController>();
  }

  // save the user's data locally and in fireabase
  Future<void> saveUserData(
      {required UserModel model,
      required bool isFire,
      required bool isIos,
      required BuildContext context}) async {
    await UserDataPref().setUser(model).then((value) async {
      if (isFire) {
        await FirestoreService().addUsers(model).catchError((error) {
          platformAlert(
              isIos: isIos,
              title: 'error'.tr,
              body: getMessageFromErrorCode(error.toString()),
              context: context);
        });
      }
    });
  }

  // ask for token
  Future<String> askToken() async {
    String token = '';
    await AwesomeNotificationsFcm().isFirebaseAvailable.then((value) async {
      await AwesomeNotificationsFcm().requestFirebaseAppToken().then((value) {
        token = value;
      }).catchError((error) {
        token = '';
      });
    });
    return token;
  }

  //load favourites and watchlist from firestore for user
  Future<void> getDocs({required String userId}) async {
    var collections = ['Favourites', 'movieWatchList', 'showWatchList'];
    var dbTables = [
      DatabaseHelper.table,
      DatabaseHelper.movieTable,
      DatabaseHelper.showTable
    ];
    List<FirebaseSend> send = [];

    for (var i = 0; i < collections.length; i++) {
      await FirestoreService()
          .getSaved(userId: userId, collection: collections[i])
          .then((value) async {
        if (value.docs.isNotEmpty) {
          send = [];
          for (int i = 0; i < value.docs.length; i++) {
            var a = value.docs[i].data();
            send.add(FirebaseSend.fromMapPre(a as Map<String, dynamic>));
            await dbHelper.insert(send[i].toMapLocal(), dbTables[i]);
          }
        }
      });
    }
  }

  // update token
  Future<void> updateToken(
      {required String userId,
      required String token,
      required UserModel model}) async {
    await askToken().then((value) async {
      if (value != '' && token != value) {
        model.messagingToken = value;
        await UserDataPref().setUser(model).then((val) => FirestoreService()
            .userUpdate(userId: userId, map: {'messagingToken': value}));
      }
    });
  }

  // controll the password textfield abscured or not
  void passAbscure() {
    _isPasswordAbscured = !_isPasswordAbscured;
    update();
  }

  // select image from device
  Future<void> openImagePicker() async {
    if (_isPicked == true) {
      _isPicked = false;
      _image = File('');
      _path = '';
      update();
    } else {
      final result = await FilePicker.platform.pickFiles(
          allowMultiple: false,
          type: FileType.custom,
          allowedExtensions: ['png', 'jpg', 'jpeg']);

      if (result != null) {
        _path = result.files.single.path.toString();
        _image = File(_path.toString());
        _isPicked = true;
        update();
      }
    }
  }

  // decide on language
  String lanDecide() {
    String lan = '';

    Get.deviceLocale.toString() != 'ar_SA' &&
            Get.deviceLocale.toString() != 'en_US' &&
            Get.deviceLocale.toString() != 'en'
        ? lan = 'en_US'
        : lan = Get.deviceLocale.toString();

    return lan;
  }

  // platform alert
  void platformAlert(
      {required bool isIos,
      required String title,
      required String body,
      required BuildContext context}) {
    _count = 0;
    update();
    if (isIos) {
      showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                title: Text(
                  title,
                ),
                content: Text(
                  body,
                ),
                actions: [
                  CupertinoDialogAction(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        'ok'.tr,
                      ))
                ],
              ));
    } else {
      snack(title, body);
    }
  }

  // move between login and signup
  void moving({required String method}) {
    if (method == 'forward') {
      Get.to(() => const SignUpPage());
    } else {
      Get.back();
    }
    controllerClear();
    _isPicked = false;
    _image = File('');
    _path = '';
  }

  // clear textcontrolles
  void controllerClear() {
    _emailController.clear();
    _userController.clear();
    _passController.clear();
  }
}
