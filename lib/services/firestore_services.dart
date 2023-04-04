import 'package:cloud_firestore/cloud_firestore.dart';

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
}
