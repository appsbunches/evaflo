import 'category_model.dart';

class ProductsCategories {
  CategoryModel? category;

  ProductsCategories({this.category});

  ProductsCategories.fromJson(Map<String, dynamic> json) {
    category = json['category'] != null ? CategoryModel.fromJson(json['category']) : null;
  }

}

