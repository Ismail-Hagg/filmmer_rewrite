import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../helper/constants.dart';
import '../helper/utils.dart';
import '../local_storage/local_data_pref.dart';
import '../models/comment_model.dart';
import '../models/user_model.dart';
import '../services/firestore_services.dart';
import 'home_controller.dart';
import 'movie_detale_controller.dart';

class SubCommentControllrt extends GetxController {
  List<CommentModel> _commentsList = [];
  List<CommentModel> get commentsList => _commentsList;

  var uuid = const Uuid();

  final UserModel _userModel = Get.find<HomeController>().userModel;
  UserModel get userModel => _userModel;

  final TextEditingController _txtControlller = TextEditingController();
  TextEditingController get txtControlller => _txtControlller;

  final FocusNode _myFocusNode = FocusNode();
  FocusNode get myFocusNode => _myFocusNode;

  int _loader = 0;
  int get loader => _loader;

  CommentModel _mainComment = CommentModel(
      comment: '',
      dislikeCount: 0,
      isPicOnline: false,
      isSpoilers: false,
      isSub: false,
      likeCount: 0,
      pic: '',
      postId: '',
      subComments: [],
      timeStamp: DateTime.now(),
      token: '',
      userId: '',
      userName: '');
  CommentModel get mainComment => _mainComment;

  CommentModel _modelSend = CommentModel(
      comment: '',
      dislikeCount: 0,
      isPicOnline: false,
      isSpoilers: false,
      isSub: false,
      likeCount: 0,
      pic: '',
      postId: '',
      subComments: [],
      timeStamp: DateTime.now(),
      token: '',
      userId: '',
      userName: '');
  CommentModel get modelSend => _modelSend;

  // model the comments in the streambuilder
  void modelComments(List<QueryDocumentSnapshot<Object?>> lst, String postId) {
    _commentsList = [];
    if (lst.isNotEmpty) {
      for (var i = 0; i < lst.length; i++) {
        if ((lst[i].data() as Map<String, dynamic>)['postId'] == postId) {
          _mainComment =
              CommentModel.fromMap(lst[i].data() as Map<String, dynamic>);
          if ((lst[i].data() as Map<String, dynamic>)['subComments']
              .isNotEmpty) {
            _commentsList = [];
            List<dynamic> list =
                (lst[i].data() as Map<String, dynamic>)['subComments'];
            for (var x = 0; x < list.length; x++) {
              _commentsList.insert(0, CommentModel.fromMap(list[x]));
            }
          }
        }
      }
    }
  }

  // upload reply
  void uploadReply(
      {required String comment,
      required String movieId,
      required String firePostId,
      required List<dynamic> subs,
      required String postId,
      required String token}) async {
    myFocusNode.unfocus();
    if (comment != '') {
      _loader = 1;

      _modelSend = CommentModel(
          comment: comment,
          dislikeCount: 0,
          isPicOnline: _userModel.onlinePicPath == '' ? false : true,
          isSpoilers: false,
          isSub: true,
          likeCount: 0,
          pic: _userModel.onlinePicPath.toString(),
          postId: uuid.v4(),
          subComments: <Map<String, dynamic>>[],
          timeStamp: DateTime.now(),
          userId: _userModel.userId.toString(),
          userName: _userModel.userName.toString(),
          token: _userModel.messagingToken.toString());
      subs.add(_modelSend.toMap());
      await FirestoreService()
          .updateCommentData(
              movieId: movieId,
              postId: firePostId,
              key: 'subComments',
              value: subs)
          .then((value) => {
                _loader = 0,
                update(),
                _txtControlller.clear(),
                Get.find<MovieDetaleController>().uploadRef(
                    uid: _userModel.userId.toString(),
                    movieId: movieId,
                    postId: firePostId,
                    isSub: true)
              })
          .catchError((e) => {print('============ $e')})
          .then((value) async {
        // sent notification
        try {
          HttpsCallable callable =
              FirebaseFunctions.instance.httpsCallable('sendNotifications');
          final resp = await callable.call(<String, dynamic>{
            'title': _userModel.userName,
            'body': 'commentmessage'.tr,
            'token': _userModel.messagingToken.toString(),
            'payload': '${{
              'action': 'comments',
              'movieId': movieId,
              'firePostId': firePostId,
              'postId': postId,
            }}'
          });
        } catch (_) {}
      });
    } else {
      _txtControlller.clear();
    }
  }

  // delete reply
  void deleteReply(
      {required CommentModel comment,
      required String movieId,
      required String firePostId,
      required String postId,
      required BuildContext context,
      required bool isSub}) async {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;
    platforMulti(
        buttonTitle: [
          'cancel'.tr,
          'answer'.tr,
        ],
        func: [
          () {
            Get.back();
          },
          () async {
            Get.back();
            if (isSub) {
              for (var i = 0; i < comment.subComments.length; i++) {
                _commentsList.remove(comment.subComments[i]);
                if (comment.subComments[i]['postId'] == postId) {
                  comment.subComments.remove(comment.subComments[i]);
                  await FirestoreService().updateCommentData(
                      movieId: movieId,
                      postId: firePostId,
                      key: 'subComments',
                      value: comment.subComments);
                }
              }
            }
          }
        ],
        isIos: true,
        title: 'delrep'.tr,
        body: 'deletereply'.tr,
        context: context);
  }

  void subLikeSystem(
      {required bool isLike,
      required String mainPostId,
      required String movieId,
      required String firePostId,
      required List<CommentModel> commentList,
      required int index}) async {
    if (isLike) {
      var lst = userModel.commentLikes.toString().split(',');
      var other = userModel.commentsDislikes.toString().split(',');
      if (lst.contains(commentList[index].postId)) {
        // there is already a like so remove
        lst.remove(commentList[index].postId);
        commentList[index].likeCount = commentList[index].likeCount - 1;
        _userModel.commentLikes = lst.join(',');
        saveLike(
            model: _userModel,
            key: 'commentLikes',
            value: _userModel.commentLikes.toString(),
            movieId: movieId,
            firePostId: firePostId,
            otherKey: 'subComments',
            otherVal: commentList);
      } else {
        // add a like
        // first if there's a dislike remove it
        if (other.contains(commentList[index].postId)) {
          other.remove(commentList[index].postId);
          commentList[index].dislikeCount = commentList[index].dislikeCount - 1;
          _userModel.commentsDislikes = other.join(',');
          saveLike(
              model: _userModel,
              key: 'commentsDislikes',
              value: _userModel.commentsDislikes.toString(),
              movieId: movieId,
              firePostId: firePostId,
              otherKey: 'subComments',
              otherVal: commentList);

          lst.add(commentList[index].postId);
          _userModel.commentLikes = lst.join(',');
          commentList[index].likeCount = commentList[index].likeCount + 1;
          saveLike(
              model: _userModel,
              key: 'commentLikes',
              value: _userModel.commentLikes.toString(),
              movieId: movieId,
              firePostId: firePostId,
              otherKey: 'subComments',
              otherVal: commentList);
        } else {
          // add a like
          lst.add(commentList[index].postId);
          _userModel.commentLikes = lst.join(',');
          commentList[index].likeCount = commentList[index].likeCount + 1;
          saveLike(
              model: _userModel,
              key: 'commentLikes',
              value: _userModel.commentLikes.toString(),
              movieId: movieId,
              firePostId: firePostId,
              otherKey: 'subComments',
              otherVal: commentList);

          // notify user that someone liked his comment
        }
      }
    } else {
      var lst = userModel.commentsDislikes.toString().split(',');
      var other = userModel.commentLikes.toString().split(',');
      if (lst.contains(commentList[index].postId)) {
        // there is already a dislike so remove
        lst.remove(commentList[index].postId);
        _userModel.commentsDislikes = lst.join(',');
        commentList[index].dislikeCount = commentList[index].dislikeCount - 1;
        saveLike(
            model: _userModel,
            key: 'commentsDislikes',
            value: _userModel.commentsDislikes.toString(),
            movieId: movieId,
            firePostId: firePostId,
            otherKey: 'subComments',
            otherVal: commentList);
      } else {
        // add a dislike
        // first if there's a like remove it
        if (other.contains(commentList[index].postId)) {
          other.remove(commentList[index].postId);
          _userModel.commentLikes = other.join(',');
          commentList[index].likeCount = commentList[index].likeCount - 1;
          saveLike(
              model: _userModel,
              key: 'commentLikes',
              value: _userModel.commentsDislikes.toString(),
              movieId: movieId,
              firePostId: firePostId,
              otherKey: 'subComments',
              otherVal: commentList);

          lst.add(commentList[index].postId);
          _userModel.commentsDislikes = lst.join(',');
          commentList[index].dislikeCount = commentList[index].dislikeCount + 1;
          saveLike(
              model: _userModel,
              key: 'commentsDislikes',
              value: _userModel.commentLikes.toString(),
              movieId: movieId,
              firePostId: firePostId,
              otherKey: 'subComments',
              otherVal: commentList);
        } else {
          lst.add(commentList[index].postId);
          _userModel.commentsDislikes = lst.join(',');
          commentList[index].dislikeCount = commentList[index].dislikeCount + 1;
          saveLike(
              model: _userModel,
              key: 'commentsDislikes',
              value: _userModel.commentLikes.toString(),
              movieId: movieId,
              firePostId: firePostId,
              otherKey: 'subComments',
              otherVal: commentList);
        }
      }
    }
  }

  void saveLike(
      {required UserModel model,
      required String key,
      required String value,
      required String movieId,
      required String firePostId,
      required String otherKey,
      required List<CommentModel> otherVal}) async {
    var lst = [];
    UserDataPref().setUser(model);
    await FirestoreService().userUpdate(userId: model.userId.toString(), map: {
      key: value
    }).then((value) async => {
          for (var i = 0; i < otherVal.length; i++)
            {lst.add(otherVal[i].toMap())},
          await FirestoreService().updateCommentData(
              movieId: movieId, postId: firePostId, key: otherKey, value: lst)
        });
  }
}
