import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/comment_model.dart';
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
}
