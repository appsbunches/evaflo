import 'dart:developer';

import 'ExtraModel.dart';
import 'product_details_model.dart';
import 'package:flutter/cupertino.dart';

import '../utils/functions.dart';

/// id : 67
/// name : "Ila Carson"
/// slug : "test"
/// SEO_category_title : "Ila Carson"
/// SEO_category_description : "Voluptas commodo"
/// description : null
/// url : "http://catalog.zid/hammam95/categories/test"
/// image : null
/// img_alt_text : null
/// cover_image : null
/// products_count : 1
/// sub_categories : []
/// parent_id : 0
/// is_published : true

class CategoryModel {
  String? id;
  String? name;
  String? title;
  String? slug;
  String? sEOCategoryTitle;
  String? sEOCategoryDescription;
  String? description;
  String? url;
  String? image;
  String? icon;
  String? imgAltText;
  String? coverImage;
  int? productsCount;
  List<CategoryModel> subCategories = [];

  //List<CategoryModel>? items;
  List<String?> ids = [];
  int? parentId;
  bool? isPublished;
  GlobalKey globalKey = GlobalKey();
  List<ProductDetailsModel>? products;
  ExtraModel? extraModel;
  String? marka;

  CategoryModel.fromJson(dynamic json, {String? icon, List<CategoryModel>? items}) {
    id = json['id'].toString();
    name = json['title_mobile'] ??
        getLabelInString(json['name']) ??
        getLabelInString(json['title']);
    description = getLabelInString(json['description']);
    slug = json['slug'];
    title = json['title'];
    //   sEOCategoryTitle = json['SEO_category_title'];
    sEOCategoryDescription = json['SEO_category_description'];
    url = json['url_mobile'] ?? json['url'];
    image = json['image_mobile'] ?? json['image'] ?? json['image_full_size'];
    this.icon = icon ?? '';
    imgAltText = json['img_alt_text'];
    coverImage = json['cover_image'];
    productsCount = json['products_count'];
    if (json['sub_categories'] != null) {
      subCategories = [];
      json['sub_categories'].forEach((v) {
        var category = CategoryModel.fromJson(v);
        subCategories.add(category);
        ids.addAll(category.ids);
      });
    }
    ids.add(id);

    parentId = json['parent_id'];
    isPublished = json['is_published'];
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(ProductDetailsModel.fromJson(v));
      });
    }
    if (json['items'] != null) {
      subCategories = [];
      json['items'].forEach((v) {
        subCategories.add(CategoryModel.fromJson(v));
      });
    }
    if (items != null) {
      subCategories = items;
    }
    marka = json['marka'];
    // extraModel = json['extra'] is List? ? null : ExtraModel.fromJson(json['extra']);
  }
}
