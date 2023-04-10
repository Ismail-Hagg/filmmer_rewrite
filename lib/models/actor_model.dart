import 'package:filmmer_rewrite/models/results_model.dart';

class ActorModel {
  String? actorName;
  String? posterPath;
  String? language;
  String? id;
  String? bio;
  bool? isShow;
  int? age;
  List<Results>? movieResults;
  List<Results>? tvResults;
  bool? isError;
  String? errorMessage;
  String? imdb;
  ActorModel(
      {this.actorName,
      this.posterPath,
      this.language,
      this.id,
      this.bio,
      this.isShow,
      this.age,
      this.movieResults,
      this.tvResults,
      this.isError,
      this.errorMessage,
      this.imdb});
}
