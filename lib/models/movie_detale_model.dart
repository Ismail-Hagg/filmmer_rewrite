import 'package:filmmer_rewrite/models/homepage_model.dart';

import '../helper/constants.dart';
import 'cast_model.dart';

class MovieDetaleModel {
  List<String>? genres;
  int? id;
  String? imdbId;
  String? overview;
  String? posterPath;
  String? releaseDate;
  int? runtime;
  String? status;
  String? title;
  double? voteAverage;
  bool? isShow;
  String? originCountry;
  CastModel? cast;
  HomePageModel? recomendation;
  bool? isError;
  String? errorMessage;

  MovieDetaleModel(
      {this.genres,
      this.id,
      this.imdbId,
      this.overview,
      this.posterPath,
      this.releaseDate,
      this.runtime,
      this.status,
      this.title,
      this.voteAverage,
      this.isShow,
      this.originCountry,
      this.cast,
      this.recomendation,
      this.isError,
      this.errorMessage});

  MovieDetaleModel.fromMap(Map<String, dynamic> json) {
    double voteAve = json['vote_average'] ?? 0.0;
    String relDate =
        json['release_date'] ?? json['first_air_date'] ?? 'unknown';
    // int seasonNumbrt = json['seasons'][0]['season_number'];
    // List<dynamic> seasons = json['seasons'];
    int run = json['runtime'] ?? json['seasons'][0]['season_number'];

    if (json['genres'] != null) {
      genres = <String>[];
      json['genres'].forEach((v) {
        genres!.add(v['name']);
      });
    }
    id = json['id'];
    imdbId = json['imdb_id'];
    overview = json['overview'];
    posterPath = json['poster_path'];

    releaseDate = relDate != 'unknown' && relDate != ''
        ? relDate.substring(0, 4)
        : relDate;
    status = json['status'];
    runtime = json['first_air_date'] == null
        ? run
        : run == 0
            ? json['seasons'].length - 1
            : json['seasons'].length;

    title = json['title'] ?? json['name'];
    voteAverage = double.parse(voteAve.toStringAsFixed(1));
    isShow = json['first_air_date'] == null ? false : true;
    originCountry = json['origin_country'] == null
        ? json['production_countries'][0]['name']
        : countries[json['origin_country'][0]];
    isError = false;
    errorMessage = '';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'genres': genres,
      'imdb_id': imdbId,
      'overview': overview,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'title': title,
      'runtime': runtime,
      'status': status,
      'vote_average': voteAverage
    };
  }
}
