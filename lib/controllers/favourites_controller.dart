import 'package:get/get.dart';

import '../models/fire_upload.dart';

class FavouritesController extends GetxController {
  final List<FirebaseSend> _newList = [];
  List<FirebaseSend> get newList => _newList;

  fromDetale({required FirebaseSend send, required bool addOrDelete}) {
    var str = [];
    if (addOrDelete == true) {
      _newList.insert(0, send);
    } else {
      for (var element in _newList) {
        str.add(element.id);
      }
      _newList.removeAt(str.indexOf(send.id));
    }
    update();
  }
}
