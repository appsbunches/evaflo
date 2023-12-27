
class FilterModel {
  List<Attributes>? attributes;

  FilterModel.fromJson(dynamic json) {
    if (json['attributes'] != null) {
      attributes = [];
      json['attributes'].forEach((v) {
        attributes?.add(Attributes.fromJson(v));
      });
    }
  }

}

class Attributes {
  Attributes({
    this.name,
    this.slug,
    this.displayOrder,
    this.isEnabled,
    this.data,});

  Attributes.fromJson(dynamic json) {
    name = json['name'];
    slug = json['slug'];
    displayOrder = json['display_order'];
    isEnabled = json['is_enabled'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }
  String? name;
  String? slug;
  int? displayOrder;
  bool? isEnabled;
  List<Data>? data;

}
class Data {

  Data.fromJson(dynamic json) {
    id = json['id'];
    value = json['value'];
    type = json['type'];
    typeValue = json['type_value'];
    displayOrder = json['display_order'];
  }
  String? id;
  String? value;
  String? type;
  dynamic typeValue;
  int? displayOrder;



}