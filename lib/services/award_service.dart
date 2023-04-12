import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/award_model.dart';

class AwardsService {
  Future<AwardModel> getAward({required String link}) async {
    AwardModel model = AwardModel();
    dynamic result = '';
    var url = Uri.parse(link);
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        result = jsonDecode(response.body);
        print(link);
        model = AwardModel.fromJson(result);
      } else {
        model = AwardModel(
            isError: true, errorMessageConnection: 'status code not 200');
      }
      return model;
    } catch (e) {
      return AwardModel(isError: true, errorMessageConnection: e.toString());
    }
  }
}
