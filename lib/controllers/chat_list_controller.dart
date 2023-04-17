import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

import '../helper/utils.dart';
import '../models/user_model.dart';
import '../services/firestore_services.dart';
import 'home_controller.dart';

class ChatListController extends GetxController {
  final UserModel _userModel = Get.find<HomeController>().userModel;
  UserModel get userModel => _userModel;
  late Stream<QuerySnapshot> _chatStream;
  Stream<QuerySnapshot> get straem => _chatStream;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _chatStream =
        FirestoreService().getChats(userId: _userModel.userId.toString());
  }

  // convert timestamp to datetime
  String formatTimestamp(DateTime timestamp) {
    return timeAgo(timestamp);
  }
}
