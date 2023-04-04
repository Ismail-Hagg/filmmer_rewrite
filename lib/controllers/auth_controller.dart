import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:filmmer_rewrite/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../helper/utils.dart';
import '../local_storage/local_data_pref.dart';
import '../local_storage/local_database.dart';
import '../models/fire_upload.dart';
import '../pages/control_page.dart';
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

  final dbHelper = DatabaseHelper.instance;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _user.bindStream(_auth.authStateChanges());
  }

  // google sign in method
  Future<void> googleSignIn({required BuildContext context}) async {
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
                  await saveUserData(model: model, isFire: true).then((value) {
                    Get.offAll(() => const ControllerPage());
                    _count = 0;
                  }).catchError((error) {
                    snack('error'.tr, error.toString());
                  });
                });
              } else {
                // signed in wiht google before
                UserModel model =
                    UserModel.fromMap(value.data() as Map<dynamic, dynamic>);
                await saveUserData(model: model, isFire: false)
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
                    await updateToken(
                        userId: model.userId.toString(),
                        token: model.messagingToken.toString(),
                        model: model);
                    _count = 0;
                  });
                }).catchError((error) {
                  print('========>  $error');
                });
              }
            });
          });
        }
      });
    } on FirebaseAuthException catch (e) {
      snack('error'.tr, getMessageFromErrorCode(e));
      _count = 0;
      update();
    } catch (e) {
      snack('error'.tr, e.toString());
      _count = 0;
      update();
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
      {required UserModel model, required bool isFire}) async {
    await UserDataPref().setUser(model).then((value) async {
      if (isFire) {
        await FirestoreService().addUsers(model).catchError((error) {
          snack('error'.tr, getMessageFromErrorCode(error.toString()));
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
}
