import '../models/results_model.dart';

class ActorCastModel {
  List<Results>? res;
  String? errorMessage;
  bool? isError;
  ActorCastModel({
    this.res,
    this.errorMessage,
    this.isError,
  });

  ActorCastModel.fromJson(Map<String, dynamic> json) {
    errorMessage = '';
    isError = false;
    if (json['cast'] != null) {
      res = <Results>[];
      json['cast'].forEach((v) {
        res!.add(Results.fromMap(v));
      });
    }
  }
}
