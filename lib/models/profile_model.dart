import 'package:filmmer_rewrite/models/results_model.dart';

class ProfileModel {
  String usreId;
  String usreName;
  String pic;
  List<Results> favList;
  List<Results> watchList;
  List<Results> nowList;
  ProfileModel({
    required this.usreId,
    required this.usreName,
    required this.pic,
    required this.favList,
    required this.watchList,
    required this.nowList,
  });
}
