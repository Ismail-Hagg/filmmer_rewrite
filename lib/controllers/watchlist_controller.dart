import 'package:get/get.dart';

import '../models/fire_upload.dart';

class WatchlistController extends GetxController {
  final List<FirebaseSend> _showLocal = [];
  List<FirebaseSend> get showList => _showLocal;

  final List<FirebaseSend> _moviesLocal = [];
  List<FirebaseSend> get movieList => _moviesLocal;

  void fromDetale({required FirebaseSend send, required bool isShow}) {
    if (isShow == true) {
      showList.insert(0, send);
    } else {
      movieList.insert(0, send);
    }
    update();
  }
}
