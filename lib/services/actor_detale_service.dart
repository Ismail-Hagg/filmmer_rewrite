import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/actor_detale_model.dart';

class ActorDetaleService {
  Future<ActorDetaleModel> getActorInfo({required String link}) async {
    ActorDetaleModel model = ActorDetaleModel();
    dynamic result = '';
    var url = Uri.parse(link);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
        model = ActorDetaleModel.fromJson(result);
      } else {
        model = ActorDetaleModel(
            isError: true, errorMessage: 'status code not 200');
      }
      return model;
    } catch (e) {
      return ActorDetaleModel(isError: true, errorMessage: e.toString());
    }
  }
}
