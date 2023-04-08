import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/movie_detale_model.dart';

class MovieDetaleService {
  Future<MovieDetaleModel> getHomeInfo({required String link}) async {
    MovieDetaleModel model = MovieDetaleModel();
    dynamic result = '';
    var url = Uri.parse(link);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
        model = MovieDetaleModel.fromMap(result);
      } else {
        model = MovieDetaleModel(
            isError: true, errorMessage: 'status code not 200');
      }
      return model;
    } catch (e) {
      return MovieDetaleModel(isError: true, errorMessage: e.toString());
    }
  }
}
