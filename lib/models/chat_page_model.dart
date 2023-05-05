import '../models/user_model.dart';

class ChatPageModel {
  String userId;
  bool fromList;
  String userName;
  UserModel? userModel;
  ChatPageModel({
    required this.userId,
    required this.fromList,
    required this.userName,
    this.userModel,
  });
}
