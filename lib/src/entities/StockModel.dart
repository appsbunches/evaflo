
class StockModel {

  StockModel.fromJson(dynamic json) {
    id = json['id'];
    location = json['location'] != null ? Location.fromJson(json['location']) : null;
    availableQuantity = json['available_quantity'];
    isInfinite = json['is_infinite'];
  }
  String? id;
  Location? location;
  int? availableQuantity;
  bool? isInfinite;

}

class Location {

  Location.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
  }
  String? id;
  String? name;
  String? type;


}