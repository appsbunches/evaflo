class ExtraModel {
  bool? isExternalUrl;
  String? image;
  String? imgAltText;
  String? coverImage;
  String? sEOCategoryTitle;
  String? sEOCategoryDescription;
  String? description;
  int? productsCount;

  ExtraModel.fromJson(dynamic json) {
    isExternalUrl = json['is_external_url'];
    image = json['image'];
    imgAltText = json['img_alt_text'];
    coverImage = json['cover_image'];
    sEOCategoryTitle = json['SEO_category_title'];
    sEOCategoryDescription = json['SEO_category_description'];
    description = json['description'];
    productsCount = json['products_count'];
  }


}