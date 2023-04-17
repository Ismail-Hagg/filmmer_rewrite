import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_message_model.dart';
import '../models/comment_model.dart';
import '../models/episode_keeping_model.dart';
import '../models/fire_upload.dart';
import '../models/user_model.dart';

class FirestoreService {
  final CollectionReference _ref =
      FirebaseFirestore.instance.collection('Users');
  CollectionReference get ref => _ref;

  final CollectionReference _comRef =
      FirebaseFirestore.instance.collection('Comments');
  CollectionReference get comRef => _comRef;

  final CollectionReference _watchRef =
      FirebaseFirestore.instance.collection('Keeping');
  CollectionReference get watchRef => _watchRef;

  // get the current user's data
  Future<DocumentSnapshot> getCurrentUser({required String userId}) async {
    return await _ref.doc(userId).get();
  }

  // add user data to firebase
  Future<void> addUsers(UserModel model) async {
    return await _ref.doc(model.userId).set(model.toMap());
  }

  // get querysnapshot of second level
  Future<QuerySnapshot> getSaved(
      {required String userId, required String collection}) async {
    return _ref.doc(userId).collection(collection).get();
  }

  // update user data
  Future<void> userUpdate(
      {required String userId, required Map<String, dynamic> map}) async {
    _ref.doc(userId).update(map);
  }

  // stream updated chat or episode keeping
  Stream<QuerySnapshot> isUpdates(String userId, String collection) {
    return _ref
        .doc(userId)
        .collection(collection)
        .where('isUpdated', isEqualTo: true)
        .snapshots();
  }

  // add comment data to firebase
  Future<String> addComment(
      {required CommentModel model,
      required String movieId,
      required String userId}) async {
    var ref = _comRef.doc(movieId).collection('Comments').doc();
    await ref.set(model.toMap());
    return ref.id;
  }

  // stream to get comments
  Stream<QuerySnapshot> commentStream(
      {required String movieId, required String collection}) {
    return _comRef
        .doc(movieId)
        .collection(collection)
        .orderBy('timeStamp', descending: true)
        .snapshots();
  }

  // update comment data fields in firebase
  Future<void> updateCommentData(
      {required String movieId,
      required String postId,
      required String key,
      required dynamic value}) async {
    await _comRef
        .doc(movieId)
        .collection('Comments')
        .doc(postId)
        .update({key: value});
  }

  // upload favorites to firestore
  Future<void> upload(
      {required String userId,
      required FirebaseSend fire,
      required int count}) async {
    if (count == 1) {
      await _ref.doc(userId).collection('Favourites').doc(fire.id).delete();
    } else if (count == 0) {
      await _ref
          .doc(userId)
          .collection('Favourites')
          .doc(fire.id)
          .set(fire.toMap());
    }
  }

  // upload watchList to firestore
  Future<void> watchList(
      {required String userId,
      required FirebaseSend fire,
      required String isShow,
      required int count}) async {
    if (count == 1) {
      await _ref
          .doc(userId)
          .collection('${isShow}WatchList')
          .doc(fire.id)
          .delete();
    } else if (count == 0) {
      await _ref
          .doc(userId)
          .collection('${isShow}WatchList')
          .doc(fire.id)
          .set(fire.toMap());
    }
  }

  // delete a comment
  Future<void> deleteComment(
      {required String movieId, required String postId}) async {
    return await _comRef
        .doc(movieId)
        .collection('Comments')
        .doc(postId)
        .delete();
  }

  // add to episode keeping
  Future<void> addEpisode(
      {required String uid, required EpisodeModeL model}) async {
    await _ref
        .doc(uid)
        .collection('episodeKeeping')
        .doc(model.id.toString())
        .set(model.toMap())
        .then((value) {
      _watchRef.doc(model.id.toString()).get().then((value) {
        DocumentReference myRef =
            _ref.doc(uid).collection('episodeKeeping').doc(model.id.toString());
        if (value.exists) {
          List<dynamic> lst = value.get('refList');
          if (lst.contains(myRef) == false) {
            lst.add(myRef);
            _watchRef.doc(model.id.toString()).update({'refList': lst});
          }
        } else {
          model.refList = [myRef];
          _watchRef.doc(model.id.toString()).set(model.toMap());
        }
      });
    });
  }

  // delete from watchlist or favorites
  Future<void> delete(
      {required String uid,
      required String id,
      required String collection}) async {
    return _ref.doc(uid).collection(collection).doc(id).delete();
  }

  // get favorites or watchlist or watching now
  Future<QuerySnapshot> getThingz(
      {required String uid, required String collection}) async {
    return _ref.doc(uid).collection(collection).get();
  }

  // stream user document
  Stream<QuerySnapshot> getUserChat(
      {required String userId, required String otherId}) {
    return _ref
        .doc(userId)
        .collection('chats')
        .where('userId', isEqualTo: otherId)
        .snapshots();
  }

  // send chat message to firebase
  Future<void> sendMessage({required ChatMessageModel model}) async {
    await _ref
        .doc(model.userId)
        .collection('chats')
        .doc(model.otherId)
        .set(model.toMap());
  }

  // chear isUpdated
  Future<void> clearIsUpdates(
      {required String userId,
      required String collection,
      required bool clearAll,
      required String chatId}) {
    return clearAll
        ? _ref
            .doc(userId)
            .collection(collection)
            .where('isUpdated', isEqualTo: true)
            .get()
            .then((value) {
            if (value.docs.isNotEmpty) {
              for (var i = 0; i < value.docs.length; i++) {
                _ref
                    .doc(userId)
                    .collection(collection)
                    .doc(value.docs[i].id)
                    .update({'isUpdated': false});
              }
            }
          })
        : _ref
            .doc(userId)
            .collection(collection)
            .doc(chatId)
            .update({'isUpdated': false});
  }

  // get episodeKeeping data
  Future<QuerySnapshot> getKeeping({required String userId}) {
    return _ref
        .doc(userId)
        .collection('episodeKeeping')
        .orderBy('change', descending: true)
        .get();
  }

  // stream chat data
  Stream<QuerySnapshot> getChats({required String userId}) {
    return _ref
        .doc(userId)
        .collection('chats')
        .orderBy('change', descending: true)
        .snapshots();
  }

  // get chat collections
  Future<QuerySnapshot> getChatCollections({required String userId}) {
    return _ref.doc(userId).collection('chats').get();
  }
}
