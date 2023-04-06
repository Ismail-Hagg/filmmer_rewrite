// model of the user data that is going to be saved locally and in firebase

class UserModel {
  String? userName;
  String? email;
  String? onlinePicPath;
  String? localPicPath;
  String? userId;
  bool? isPicLocal;
  String? language;
  bool? isError;
  String? errorMessage;
  String? messagingToken;
  String? commentLikes;
  String? commentsDislikes;

  UserModel(
      {this.userName,
      this.email,
      this.onlinePicPath,
      this.localPicPath,
      this.userId,
      this.isPicLocal,
      this.language,
      this.isError,
      this.messagingToken,
      this.commentLikes,
      this.commentsDislikes,
      this.errorMessage});

  toMap() {
    return <String, dynamic>{
      'userName': userName,
      'email': email,
      'onlinePicPath': onlinePicPath,
      'localPicPath': localPicPath,
      'userId': userId,
      'isPicLocal': isPicLocal,
      'language': language,
      'isError': isError,
      'messagingToken': messagingToken,
      'commentLikes': commentLikes,
      'commentsDislikes': commentsDislikes,
      'errorMessage': errorMessage
    };
  }

  factory UserModel.fromMap(Map<dynamic, dynamic> map) {
    return UserModel(
        userName: map['userName'],
        email: map['email'],
        onlinePicPath: map['onlinePicPath'],
        localPicPath: map['localPicPath'],
        userId: map['userId'],
        isPicLocal: map['isPicLocal'],
        language: map['language'],
        isError: map['isError'],
        messagingToken: map['messagingToken'],
        commentLikes: map['commentLikes'],
        commentsDislikes: map['commentsDislikes'],
        errorMessage: map['errorMessage']);
  }
}
