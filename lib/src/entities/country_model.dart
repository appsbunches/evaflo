import 'package:equatable/equatable.dart';

class CountryModel extends Equatable{
  int? id;
  String? isoCode2;
  String? isoCode3;
  String? name;
  String? arName;
  String? enName;
  String? code;
  String? countryCode;
  String? flag;
  List<CountryModel>? cities;
  String? symbol;
  CountryModel? country;


  CountryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isoCode2 = json['iso_code_2'];
    isoCode3 = json['iso_code_3'];
    name = json['name'];
    arName = json['ar_name'];
    enName = json['en_name'];
    code = json['code'];
    countryCode = json['country_code'];
    flag = json['flag'];
    if (json['cities'] != null) {
      cities = [];
      json['cities'].forEach((v) {
        cities?.add(CountryModel.fromJson(v));
      });
    }
    symbol = json['symbol'];
    country = json['country'] != null ? CountryModel.fromJson(json['country']) : null;

  }

  List<Object?> get props => [id];
}
