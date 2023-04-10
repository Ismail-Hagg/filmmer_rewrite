import '../helper/utils.dart';

class ActorDetaleModel {
  String? biography;
  String? birthday;
  int? id;
  String? imdbId;
  String? name;
  String? profilePath;
  String? errorMessage;
  bool? isError;
  int? age;

  ActorDetaleModel(
      {this.biography,
      this.birthday,
      this.id,
      this.imdbId,
      this.name,
      this.profilePath,
      this.errorMessage,
      this.isError,
      this.age});

  ActorDetaleModel.fromJson(Map<String, dynamic> json) {
    biography = json['biography'];
    birthday = json['birthday'];
    id = json['id'];
    imdbId = json['imdb_id'];
    name = json['name'];
    profilePath = json['profile_path'];
    isError = false;
    errorMessage = '';
    age = json['birthday'] != null || json['birthday'] != ''
        ? calculateAge(json['birthday'])
        : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['biography'] = biography;
    data['birthday'] = birthday;
    data['id'] = id;
    data['imdb_id'] = imdbId;
    data['name'] = name;
    data['profile_path'] = profilePath;
    return data;
  }
}
