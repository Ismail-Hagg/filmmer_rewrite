import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/actor_cast_model.dart';

class ActorCastService {
  Future<ActorCastModel> getActorCast(
      {required String link, required String lan}) async {
    ActorCastModel model = ActorCastModel();
    dynamic result = '';
    var url = Uri.parse(link + lan.replaceAll('_', '-'));
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
        model = ActorCastModel.fromJson(result);
      } else {
        model =
            ActorCastModel(isError: true, errorMessage: 'status code not 200');
      }
      return model;
    } catch (e) {
      return ActorCastModel(isError: true, errorMessage: e.toString());
    }
  }
}
