import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:filmmer_rewrite/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import '../models/chat_message_model.dart';
import '../models/chat_page_model.dart';
import '../models/user_model.dart';
import '../services/firestore_services.dart';
import 'home_controller.dart';

class ChatPageController extends GetxController {
  final BuildContext context;
  final bool isIos;
  ChatPageController({required this.context, required this.isIos});

  final ChatPageModel _otherUser = Get.arguments as ChatPageModel;
  ChatPageModel get otherUser => _otherUser;

  final UserModel _userModel = Get.find<HomeController>().userModel;
  UserModel get userModel => _userModel;

  late Stream<QuerySnapshot> _chatStream;
  Stream<QuerySnapshot> get straem => _chatStream;

  List<types.Message> _messages = [];
  List<types.Message> get messages => _messages;

  late types.User _user;
  types.User get user => _user;

  List<Map<String, dynamic>> _dino = [];
  List<Map<String, dynamic>> get dino => _dino;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserData();
    _chatStream = FirestoreService().getUserChat(
        userId: _userModel.userId.toString(), otherId: _otherUser.userId);
    _user = types.User(id: _userModel.userId.toString());
  }

  // get user data if coming from list page
  void getUserData() async {
    await FirestoreService().getCurrentUser(userId: _otherUser.userId).then(
        (value) => _otherUser.userModel =
            UserModel.fromMap(value.data() as Map<String, dynamic>));
  }

  // send message
  void sendMessage(types.PartialText message) async {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );
    dino.add(textMessage.toJson());

    await FirestoreService()
        .sendMessage(
            model: ChatMessageModel(
                userId: _userModel.userId.toString(),
                otherId: _otherUser.userId,
                isPicOnline:
                    _otherUser.userModel!.onlinePicPath != '' ? true : false,
                change: Timestamp.now(),
                messages: dino,
                onlinePath: _otherUser.userModel!.onlinePicPath.toString(),
                userNsme: _otherUser.userName,
                token: _otherUser.userModel!.messagingToken.toString(),
                ref: FirestoreService()
                    .ref
                    .doc(_otherUser.userId)
                    .collection('chats')
                    .doc(_userModel.userId),
                isUpdated: false))
        .then((value) async {
      await FirestoreService().sendMessage(
          model: ChatMessageModel(
              userId: _otherUser.userId,
              otherId: _userModel.userId.toString(),
              isPicOnline: _userModel.onlinePicPath != '' ? true : false,
              change: Timestamp.now(),
              messages: dino,
              onlinePath: _userModel.onlinePicPath.toString(),
              userNsme: _userModel.userName.toString(),
              token: _userModel.messagingToken.toString(),
              ref: FirestoreService()
                  .ref
                  .doc(_userModel.userId)
                  .collection('chats')
                  .doc(_otherUser.userId),
              isUpdated: true));
    }).then((_) async {
      try {
        HttpsCallable callable =
            FirebaseFunctions.instance.httpsCallable('sendNotifications');
        await callable.call(<String, dynamic>{
          'title': _userModel.userName,
          'body': _otherUser.userModel!.language == 'en_US'
              ? 'new message from'
              : 'رساله جديده من',
          'token': _otherUser.userModel!.messagingToken.toString(),
          'payload': json.encode({
            'action': 'chat',
            'userNsme': _userModel.userName,
            'userId': _userModel.userId,
          })
        });
      } catch (e) {
        print('========  $e');
      }
    }).catchError((error, stackTrace) {
      platformAlert(
          isIos: isIos,
          title: 'error'.tr,
          body: error.toString(),
          context: context);
    });
  }

  // get messages from firebase
  void getMessages(List<dynamic> lst) {
    _messages = [];
    _dino = [];
    for (var i = 0; i < lst.length; i++) {
      _messages.insert(0, types.TextMessage.fromJson(lst[i]));
      _dino.add(lst[i]);
    }
    update();
    //print(lst);
  }

  // clear the isupdated flag
  void clearIsUpdated() async {
    await FirestoreService().clearIsUpdates(
        userId: _userModel.userId.toString(),
        collection: 'chats',
        clearAll: false,
        chatId: _otherUser.userId);
  }

  // go back
  void back() {
    Get.back();
  }
}
