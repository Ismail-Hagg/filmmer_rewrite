class AwardModel {
  String? imDbId;
  String? name;
  String? description;
  List<Items>? items;
  String? nameAwardsHtml;
  String? errorMessage;
  bool? isError;
  String? localErrorMessage;

  AwardModel(
      {this.imDbId,
      this.name,
      this.description,
      this.items,
      this.nameAwardsHtml,
      this.errorMessage,
      this.isError,
      this.localErrorMessage});

  AwardModel.fromJson(Map<String, dynamic> json) {
    isError = false;
    localErrorMessage = '';
    imDbId = json['imDbId'];
    name = json['name'];
    description = json['description'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    nameAwardsHtml = json['nameAwardsHtml'];
    errorMessage = json['errorMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imDbId'] = imDbId;
    data['name'] = name;
    data['description'] = description;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['nameAwardsHtml'] = nameAwardsHtml;
    data['errorMessage'] = errorMessage;
    return data;
  }
}

class Items {
  String? eventTitle;
  List<NameAwardEventDetails>? nameAwardEventDetails;

  Items({this.eventTitle, this.nameAwardEventDetails});

  Items.fromJson(Map<String, dynamic> json) {
    eventTitle = json['eventTitle'];
    if (json['nameAwardEventDetails'] != null) {
      nameAwardEventDetails = <NameAwardEventDetails>[];
      json['nameAwardEventDetails'].forEach((v) {
        nameAwardEventDetails!.add(NameAwardEventDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['eventTitle'] = eventTitle;
    if (nameAwardEventDetails != null) {
      data['nameAwardEventDetails'] =
          nameAwardEventDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NameAwardEventDetails {
  String? image;
  String? title;
  String? forr;
  String? description;

  NameAwardEventDetails({this.image, this.title, this.forr, this.description});

  NameAwardEventDetails.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    title = json['title'];
    forr = json['for'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['title'] = title;
    data['for'] = forr;
    data['description'] = description;
    return data;
  }
}
