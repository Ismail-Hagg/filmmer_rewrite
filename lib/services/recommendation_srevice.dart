import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/homepage_model.dart';

class RecommendationService {
  Future<HomePageModel> getHomeInfo({required String link}) async {
    HomePageModel model = HomePageModel();
    dynamic result = '';
    var url = Uri.parse(link);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
        model = HomePageModel.fromJson(result);
      } else {
        model =
            HomePageModel(isError: true, errorMessage: 'status code not 200');
      }
      return model;
    } catch (e) {
      return HomePageModel(isError: true, errorMessage: e.toString());
    }
  }
}
