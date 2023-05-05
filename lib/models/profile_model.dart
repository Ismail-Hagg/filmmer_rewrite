// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../models/results_model.dart';

class ProfileModel {
  String usreId;
  String usreName;
  String pic;
  String token;
  List<Results> favList;
  List<Results> watchList;
  List<Results> nowList;
  ProfileModel({
    required this.usreId,
    required this.usreName,
    required this.pic,
    required this.token,
    required this.favList,
    required this.watchList,
    required this.nowList,
  });
}
