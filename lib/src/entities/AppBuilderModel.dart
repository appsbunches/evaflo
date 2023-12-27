import 'home_screen_model.dart';

class AppBuilderModel {
  /* type
  * wideBanner
  * fixedImages
  * bannerTestimonails
  * sliderImages
   */
  String? type;

  /*showStyle
  * wideBanner
  * banner_fixed_image_two
  * banner_fixed_image_one
  * banner_slider_image_four
  * banner_testimonials_1
   */
  String? showStyle;
  String? title;
  String? dataString;
  Items? data;
  FeaturedProducts? products;
  List<Items>? dataList;

  AppBuilderModel.fromJson(dynamic json) {
    title = json['title'];
    type = json['type'];
    showStyle = json['show_style'];

    dataString = json['data'] != null
        ? json['data'] is String
            ? json['data']
            : null
        : null;
    data = json['data'] != null
        ? json['data'] is Items
            ? Items.fromJson(json['data'])
            : null
        : null;

    if (json['data'] != null) {
      if (json['data'] is List) {
        dataList = [];
        json['data'].forEach((v) {
          dataList?.add(Items.fromJson(v));
        });
      }
    }
  }
}

class Data {
  String? image;
  String? data;
  String? type;
  String? customer_name;
  String? reviews;
  String? date;

  Data.fromJson(dynamic json) {
    customer_name = json['customer_name'];
    reviews = json['reviews'];
    date = json['date'];
    image = json['image'];
    data = json['data'];
    type = json['type'];
  }
}
