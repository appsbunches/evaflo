import '../.env.dart';
import '../app_config.dart';
import '../utils/functions.dart';
import 'category_model.dart';
import 'product_details_model.dart';

class HomeScreenModel {
  Slider? slider;
  PromotionImage? promotionImage;
  StoreDescription? storeDescription;
  FeaturedProducts? featuredProducts;
  FeaturedProducts? featuredProducts2;
  FeaturedProducts? featuredProducts3;
  FeaturedProducts? featuredProducts4;
  FeaturedProducts? featuredProductsPromoted;
  FeaturedProducts? recentProducts;
  FeaturedProducts? onSaleProducts;
  FeaturedCategories? featuredCategories;
  Brands? brands;
  Testimonials? testimonials;
  List<ProductDetailsModel>? products;

  HomeScreenModel.fromJson(dynamic json) {
    if (json['default'] != null) {
      if (json['default']['products'] != null) {
        products = [];
        json['default']['products'].forEach((v) {
          products?.add(ProductDetailsModel.fromJson(v));
        });
      }
      /*
      products = (json['default']['products'] as List)
          .map((e) => ProductDetailsModel.fromJson(e))
          .toList();*/
      return;
    }
    slider = json['slider'] != null ? Slider.fromJson(json['slider']) : null;
    promotionImage = json['promotion_image'] != null
        ? PromotionImage.fromJson(json['promotion_image'])
        : null;
    storeDescription = json['store_description'] != null
        ? StoreDescription.fromJson(json['store_description'])
        : null;
    featuredProducts = json['featured_products'] != null
        ? FeaturedProducts.fromJson(json['featured_products'])
        : null;
    featuredProducts2 = json['featured_products_2'] != null
        ? FeaturedProducts.fromJson(json['featured_products_2'])
        : null;
    featuredProducts3 = json['featured_products_3'] != null
        ? FeaturedProducts.fromJson(json['featured_products_3'])
        : null;
    featuredProducts4 = json['featured_products_4'] != null
        ? FeaturedProducts.fromJson(json['featured_products_4'])
        : null;
    featuredProductsPromoted = json['featured_products_promoted'] != null
        ? FeaturedProducts.fromJson(json['featured_products_promoted'])
        : null;
    recentProducts = json['recent_products'] != null
        ? FeaturedProducts.fromJson(json['recent_products'])
        : null;
    onSaleProducts = json['on_sale_products'] != null
        ? FeaturedProducts.fromJson(json['on_sale_products'])
        : null;
    featuredCategories = json['featured_categories'] != null
        ? FeaturedCategories.fromJson(json['featured_categories'])
        : null;
    brands = json['brands'] != null ? Brands.fromJson(json['brands']) : null;
    testimonials = json['testimonials'] != null
        ? Testimonials.fromJson(json['testimonials'])
        : null;
  }
}

class Testimonials {
  bool? display;
  String? title;
  List<Items>? items;

  Testimonials.fromJson(dynamic json) {
    if(json == null) return;
    display = json['display'];
    title = json['title'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
  }
}

class Brands {
  bool? display;
  String? title;
  List<Items>? items;

  Brands({this.display, this.title, this.items});

  Brands.fromJson(dynamic json) {
    display = json['display'];
    title = json['title'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
  }
}

class FeaturedCategories {
  bool? display;
  String? title;
  List<CategoryModel>? items;

  FeaturedCategories({this.display, this.title, this.items});

  FeaturedCategories.fromJson(dynamic json) {
    display = json['display'];
    title = json['title'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(CategoryModel.fromJson(v));
      });
    }
  }
}

class On_sale_products {
  bool? display;
  String? title;
  MoreButton? moreButton;
  List<Items>? items;

  On_sale_products({this.display, this.title, this.moreButton, this.items});

  On_sale_products.fromJson(dynamic json) {
    display = json['display'];
    title = json['title'];
    moreButton = json['more_button'] != null
        ? MoreButton.fromJson(json['more_button'])
        : null;
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(Items.fromJson(v));
      });
    }
  }
}

class Items {
  String? id;
  String? icon;
  String? description;
  String? url;
  String? image;
  String? type;
  String? data;
  String? title;
  String? subtitle;
  String? btnText;
  String? des;
  String? text;
  String? reviews;
  String? content;
  String? link;
  String? sku;
  dynamic? parentId;
  String? name;
  String? author;
  String? customerName;
  String? customerReview;
  String? date;
  String? slug;
  double? price;
  double? salePrice;
  String? formattedPrice;
  String? formattedSalePrice;
  String? currency;
  String? currencySymbol;
  List<dynamic>? attributes;
  List<Categories>? categories;
  int? displayOrder;
  bool? hasOptions;
  bool? hasFields;
  List<Images>? images;
  bool? isDraft;
  int? quantity;
  bool? isInfinite;
  String? htmlUrl;
  Weight? weight;
  List<String>? keywords;
  bool? requiresShipping;
  bool? isTaxable;
  String? structure;
  Seo? seo;
  int? storeId;
  dynamic? soldProductsCount;
  String? createdAt;
  String? updatedAt;
  String? mobileImage;
  String? textColor;

  String? buttonColor;
  String? buttonText;
  String? buttonTextColor;
  String? buttonLink;
  bool? fullBtnBorder;
  bool? showButton;

  //for(asayel theme)

  String? mainTitleBgClr;
  String? subTitleBgClr;
  String? descBgClr;
  String? subTitleClr;
  String? descClr;
  String? buttonBorderClr;
  String? buttonBgClr;
  String? buttonClr;
  String? firstBgClr;
  String? secondBgClr;

  Items.fromJson(dynamic json) {
    id = json['id'].toString();
    icon = json['icon'];
    description = json['description'];
    data = json['data'];
    showButton = json['show_button'];
    fullBtnBorder = json['full_btn_border'];
    customerName = (AppConfig.currentThemeId == monkeyThemeId
            ? json['client_name']
            : json['customer_name']) ??
        json['customerName'] ??
        json['client_name'];
    customerReview = json['customerReview'];
    content = json['content'];
    reviews = AppConfig.currentThemeId == monkeyThemeId
        ? json['client_opinion']
        : (json['reviews'] ?? json['client_opinion']);
    btnText = json['btn_text'] ?? json['text_button'];
    date = json['date'];
    buttonColor = json['button_color'];
    buttonTextColor = json['buttonTextColor'];
    buttonLink = json['buttonLink'];
    buttonText = json['button_text'] ?? json['buttonText'];
    textColor = json['text_color'] ?? json['textColor'];
    if (AppConfig.currentThemeId == asayelThemeId) {
      textColor = json['main_title_clr'];
      mainTitleBgClr = json['main_title_bg_clr'];
      subTitleBgClr = json['sub_title_bg_clr'];
      descBgClr = json['descBgClr'];
      subTitleClr = json['sub_title_clr'];
      descClr = json['desc_clr'];
      buttonBorderClr = json['button_border_clr'];
      buttonBgClr = json['button_bg_clr'];
      buttonClr = json['button_clr'];
      firstBgClr = json['first_bg_clr'];
      secondBgClr = json['second_bg_clr'];
    }
    subtitle = json['subtitle'] ?? json['sub_title'];
    mobileImage = json['mobile_image'] ??
        json['image_mobile'] ??
        json['img_slider_mobile']??
        json['img_slider'];
    des = json['des'] ?? json['desc'];
    type = json['type'] ?? json['slider_type'];
    sku = json['sku'];
    url = json['url'] ?? json['link'] ?? json['url_button'];
    parentId = json['parent_id'];
    name = json['name'];
    author = json[AppConfig.isSoreUseNewTheme ? 'name' : 'author'];
    slug = json['slug'];
    image = json['image'] ?? json['img'];
    text = json['text'];
    title = json['title'];
    link = AppConfig.isSoreUseNewTheme ? json['url'] : json['link'];
    formattedPrice = json['formatted_price'];
    formattedSalePrice = json['formatted_sale_price'];
    quantity = json['quantity'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images?.add(Images.fromJson(v));
      });
    }
    // if (json['img_slider_mobile'] != null &&
    //     AppConfig.currentThemeId == asayelThemeId) {
    //   imgSliderMobile = json['img_slider_mobile'];
    // }

    salePrice = checkDouble(json['sale_price'] ?? 0.0);
    price = checkDouble(json['price'] ?? 0.0);
    hasOptions = json['has_options'] ?? false;
    hasFields = json['has_fields'] ?? false;

    /*;
    currency = json['currency'];
    currencySymbol = json['currency_symbol'];
    if (json['attributes'] != null) {
      attributes = [];
      json['attributes'].forEach((v) {
        attributes?.add((v));
      });
    }
    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        categories?.add(Categories.fromJson(v));
      });
    }
    displayOrder = json['display_order'];
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images?.add((v));
      });
    }
    isDraft = json['is_draft'];
    isInfinite = json['is_infinite'];
    htmlUrl = json['html_url'];
    weight = json['weight'] != null ? Weight.fromJson(json['weight']) : null;
    keywords = json['keywords'] != null ? json['keywords'].cast<String>() : [];
    requiresShipping = json['requires_shipping'];
    isTaxable = json['is_taxable'];
    structure = json['structure'];
    seo = json['seo'] != null ? Seo.fromJson(json['seo']) : null;
    storeId = json['store_id'];
    soldProductsCount = json['sold_products_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];*/

    if (AppConfig.useAppBuilder) {
      url = buildUrl();
      link = buildUrl();
    }
  }

  String? buildUrl() {
    if (type == 'product-url') return 'products/$data';
    if (type == 'category-url') return 'categories/$data';
    if (type == 'external-url') return data;
    return null;
  }
}

class Seo {
  String? title;
  String? description;

  Seo({this.title, this.description});

  Seo.fromJson(dynamic json) {
    title = json['title'];
    description = json['description'];
  }
}

class Weight {
  dynamic? value;
  String? unit;

  Weight({this.value, this.unit});

  Weight.fromJson(dynamic json) {
    value = json['value'];
    unit = json['unit'];
  }
}

class Categories {
  String? id;
  String? name;
  String? slug;
  String? description;
  dynamic? coverImage;
  dynamic? image;
  dynamic? displayOrder;

  Categories(
      {this.id,
      this.name,
      this.slug,
      this.description,
      this.coverImage,
      this.image,
      this.displayOrder});

  Categories.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    description = json['description'];
    coverImage = json['cover_image'];
    image = json['image'];
    displayOrder = json['display_order'];
  }
}

class MoreButton {
  String? text;
  String? url;

  MoreButton({this.text, this.url});

  MoreButton.fromJson(dynamic json) {
    text = json['text'];
    if ((text?.length ?? 0) > 20) AppConfig.showMoreTextInButton = true;
    url = json['url'];
  }
}

class FeaturedProducts {
  bool? display;
  String? url;
  String? title;
  String? id;
  String? moduleType;
  MoreButton? moreButton;
  List<ProductDetailsModel>? items;

  FeaturedProducts.fromJson(dynamic json) {
    display = json['display'];
    moduleType = json['module_type'];
    url = json['url'];
    id = json['id'].toString();
    title = AppConfig.isSoreUseNewTheme ? json['name'] : json['title'];
    moreButton = json['more_button'] != null
        ? MoreButton.fromJson(json['more_button'])
        : null;

    if (json[AppConfig.isSoreUseNewTheme ? 'products' : 'items'] != null) {
      items = [];
      json[AppConfig.isSoreUseNewTheme ? 'products' : 'items'].forEach((v) {
        if (v != null) {
          items?.add(ProductDetailsModel.fromJson(v));
        }
      });
    }
  }
}

class StoreDescription {
  bool? display;
  String? image;
  Style? style;
  String? title;
  String? text;
  bool? showSocialMediaIcons;
  SocialMediaIcons? socialMediaIcons;

  StoreDescription(
      {this.display,
      this.image,
      this.style,
      this.title,
      this.text,
      this.showSocialMediaIcons,
      this.socialMediaIcons});

  StoreDescription.fromJson(dynamic json) {
    display = json['display'];
    image = json['image'];
    style = json['style'] != null ? Style.fromJson(json['style']) : null;
    title = json['title'];
    text = json['text'];
    showSocialMediaIcons = json['show_social_media_icons'];
    socialMediaIcons = json['social_media_icons'] != null
        ? SocialMediaIcons.fromJson(json['social_media_icons'])
        : null;
  }
}

class SocialMediaIcons {
  String? facebook;
  String? twitter;
  String? tiktok;
  String? instagram;
  String? snapchat;
  String? maroof;
  String? phone;
  String? email;
  dynamic? website;

  SocialMediaIcons(
      {this.facebook,
      this.twitter,
      this.instagram,
      this.snapchat,
      this.maroof,
        this.phone,
        this.email,
      this.website});

  SocialMediaIcons.fromJson(dynamic json) {
    facebook = json['facebook'];
    twitter = json['twitter'];
    instagram = json['instagram'];
    tiktok = json['tiktok'];
    snapchat = json['snapchat'];
    maroof = json['maroof'];
    phone = json['phone'];
    email = json['email'];
    website = json['website'];
  }
}

class Style {
  String? foregroundColor;
  String? backgroundColor;

  Style({this.foregroundColor, this.backgroundColor});

  Style.fromJson(dynamic json) {
    foregroundColor = json['foreground_color'];
    backgroundColor = json['background_color'];
  }
}

class PromotionImage {
  bool? display;
  String? image;
  String? title;
  String? text;
  String? buttonText;
  String? link;
  Style? style;

  PromotionImage(
      {this.display,
      this.image,
      this.title,
      this.text,
      this.buttonText,
      this.link});

  PromotionImage.fromJson(dynamic json) {
    display = json['display'];
    image = json['image'];
    title = json['title'];
    text = json['text'];
    buttonText = json['button_text'];
    style = json['style'] != null ? Style.fromJson(json['style']) : null;
    link = json['link'];
  }
}

class Slider {
  bool? display;
  List<Items> items = [];

  Slider.fromJson(dynamic json) {
    if(json == null) return;
    display = json['display'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items.add(Items.fromJson(v));
      });
    }
  }
}
