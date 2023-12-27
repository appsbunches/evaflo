import 'dart:developer';

import 'package:entaj/src/utils/functions.dart';

import '../.env.dart';
import '../app_config.dart';
import 'category_model.dart';
import 'faqs_store_features_model.dart';
import 'home_screen_model.dart';
import 'page_model.dart';
import 'products_categories_model.dart';

class ModuleModel {
  ModuleModel.fromJson(dynamic json, filename) {
    id = json['id'];
    storefrontThemeStoreId = json['storefront_theme_store_id'];
    storefrontThemeFileId = json['storefront_theme_file_id'];
    settings = json['settings'] != null
        ? json['settings'] is List
            ? null
            : Settings.fromJson(json['settings'])
        : null;
    isDraft = json['is_draft'];
    draftFor = json['draft_for'];
    isDeleted = json['is_deleted'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    fileName = filename;
  }

  String? id;
  String? storefrontThemeStoreId;
  String? storefrontThemeFileId;
  Settings? settings;
  int? isDraft;
  dynamic draftFor;
  int? isDeleted;
  String? createdAt;
  String? updatedAt;
  String? fileName;
}

class Settings {
  List<PageModel>? links1Links;
  List<PageModel>? links2Links;
  bool? links1Hide;
  bool? links2Hide;
  List<Items>? slider;
  List<Items>? bannerSliders;
  List<Items>? instagram;
  bool? displayMore;
  bool? hideDots;
  bool? announcementBarDisplay;
  String? links1Title;
  String? links2Title;
  String? textColor;
  bool? showSocial;
  String? bannerType;
  String? containerType;
  String? announcementBarText;
  String? announcementBarPageDisplay;
  String? announcementBarBackgroundColor;
  String? announcementBarTextColor;
  String? announcementBarUrl;
  String? headerLogo;
  String? moreText;
  List<dynamic>? headerOptions;
  String? colorsHeaderBackgroundColor;
  String? colorsHeaderTextColor;
  String? colorsFooterBackgroundColor;
  String? colorsFooterTextColor;
  String? fontsName;
  String? title;
  String? des;
  String? bg_clr_partners;
  String? main_title_clr;
  String? position_title;
  String? position_content;

  bool? hide_dots;
  bool? hide_navs;
  String? titleFeatureClr;
  String? contentFeatureClr;
  String? titleOffer;
  String? sectionTitle;
  String? sectionSubTitle;
  String? titleSectionClr;
  String? descSectionClr;
  String? catStyle;
  String? moreClr;
  bool? titleCenter;
  bool? showOnMobile;
  List<Items>? gallery;
  List<Items>? ads;
  List<Items>? storePartners;
  List<StoreFeatures>? storeFeatures;
  List<StoreFeatures>? features;
  int? order;
  FeaturedProducts? category;
  FeaturedProducts? products;
  FeaturedProducts? productsCustom;
  List<Items>? testimonials;
  List<Items>? reviews;
  List<Items>? bannerImages;
  List<Items>? infos;
  List<CategoryModel>? categories;
  List<ProductsCategories>? customProducts;
  String? video;
  String? bgColor;
  String? bgColorFeature;
  String? instagramAccount;
  bool? autoplay;
  bool? controls;
  bool? showButton;
  bool? textPositionRight;
  bool? displaySocialMedia;
  String? subtitle;
  String? image;
  String? mobileImage;
  String? buttonText;
  String? buttonBgColor;
  String? buttonTextColor;
  String? backgroundColor;
  String? url;
  String? about_us_title;
  String? about_us_des;
  String? color;
  Brands? brands;

  // For Monkey Store
  String? detailsTitle;
  String? detailsDesc;
  String? detailsBg;
  String? detailsVideo;
  String? detailsVideoImg;
  String? countdownImage;
  String? countdownDate;
  double? bannerSpeed;
  double? bannerHeight;

  // For Asayel Theme
  String? bgSection;
  String? productStyle;
  String? backgroundBanner;
  double? numberOnSm;
  bool? hideNavs;
  List<BannerImage>? bannerMobileImage;
  List<FaqsStoreFeaturesModel?>? faqsStoreFeatures;
  List<CategoryModel>? menuSettingslinks;
  List<CategoryModel>? menuSettingsMarkat;
  double? numberOnLg;
  double? numberOnMd;

  List<String>? navigationOptions;
  List<String>? MenuCategories_categoriesList;
  List<CategoryModel>? links_links;
  String? MenuIcons_allProducts;
  String? MenuIcons_allCategories;
  String? MenuIcons_newestProducts;
  String? MenuIcons_onSaleProducts;
  String? MenuIcons_CustomLinks;
  String? MenuIcons_DeliveryAndPayment;
  String? MenuIcons_ShoppingCart;
  bool? menuHideDiscount;

  Settings.fromJson(dynamic json) {
    menuHideDiscount = json['menuHideDiscount'];
    MenuIcons_allProducts = json['MenuIcons_allProducts'];
    MenuIcons_allCategories = json['MenuIcons_allCategories'];
    MenuIcons_newestProducts = json['MenuIcons_newestProducts'];
    MenuIcons_onSaleProducts = json['MenuIcons_onSaleProducts'];
    MenuIcons_CustomLinks = json['MenuIcons_CustomLinks'];
    MenuIcons_DeliveryAndPayment = json['MenuIcons_DeliveryAndPayment'];
    MenuIcons_ShoppingCart = json['MenuIcons_ShoppingCart'];
    numberOnMd = json['number_on_md'] == null ? null : checkDouble(json['number_on_md']);
    numberOnLg =json['number_on_lg'] == null ? null : checkDouble(json['number_on_lg']);
    numberOnSm = json['number_on_sm'] == null ? null :checkDouble(json['number_on_sm']);
    about_us_des = json['about_us_des'] ?? json['about_des'];
    about_us_title = json['about_us_title'] ?? json['about_title'];
    backgroundColor = json['background_color'];
    textPositionRight = json['text_position_right'];
    titleOffer = json['title_offer'];
    sectionTitle = json['sectionTitle'];
    sectionSubTitle = json['sectionSubTitle'] ?? json['desc'];
    displaySocialMedia = json['display_social_media'];
    image = json['image'] ?? json['img_banner'];
    des = json['des'] ?? json['desc'] ?? json['sub_title'];
    url = json['url'] ?? json['link'];
    countdownImage = json['countdownImage'] != null
        ? (json['countdownImage'] as List).isNotEmpty
            ? json['countdownImage'][0]['image']
            : null
        : null;
    countdownDate = json['countdownDate'];
    buttonTextColor = json['button_text_color'];
    buttonBgColor = json['button_bg_color'];
    buttonText = json['button_text'] ?? json['button'];
    showButton = json['show_button'];
    mobileImage = json['mobile_image'] ?? json['image_mobile'];
    subtitle = json['subtitle'];
    //for asayel theme
    bgSection = json['bg_section'];
    titleCenter = json['title_center'];
    titleSectionClr = json['title_section_clr'];
    productStyle = json['product_style'];
    moreClr = json['more_clr'];
    descSectionClr = json['desc_section_clr'];
    containerType = json['container_type'];
    hideNavs = json['hide_navs'];
    backgroundBanner = json['background_banner'];

    titleFeatureClr = json['title_feature_clr'];
    contentFeatureClr = json['content_feature_clr'];
    instagramAccount = json['instagram_account'];
    textColor = json['text_color'] ?? json['color'];
    color = json['color'];
    bgColorFeature = json['bg_clr_feature'];
    bgColor = json['bg_color'] ??
        json['bg_clr'] ??
        json['bg_section'] ??
        json['bg_clr_testimonsals'] ??
        json['bg_clr_features'];
    titleSectionClr = json['title_section_clr'];
    descSectionClr = json['desc_section_clr'];
    catStyle = json['cat_style'];
    moreClr = json['more_clr'];
    titleCenter = json['title_center'];
    showOnMobile = json['show_on_mobile'];
    video = json['video'];
    autoplay = json['autoplay'];
    controls = json['controls'];
    moreText = json['more_text'];
    try {
      if ((moreText?.length ?? 0) > 20) {
        AppConfig.showMoreTextInButton = true;
        moreText = moreText?.substring(0, 19);
      }
    } catch (e) {}
    try {
      customProducts = [];
      json['products'].forEach((v) {
        if (v == null) return;
        customProducts?.add(ProductsCategories.fromJson({'category': v['products']}));
      });
    } catch (e) {}
    links1Title = json['links_1_title'] ?? json['links_title'];
    links2Title = json['links_2_title'];
    links1Hide = json['links_1_hide'];
    links2Hide = json['links_2_hide'];
    hideDots = json['hide_dots'];
    announcementBarDisplay = json['announcement_bar_display'];
    announcementBarText = json['announcement_bar_text'];
    announcementBarPageDisplay = json['announcement_bar_page_display'];
    bannerHeight = checkDouble(json['bannerHeight']);
    bannerSpeed = checkDouble(json['bannerSpeed']);
    announcementBarBackgroundColor = json['announcement_bar_background_color'] ??
        json['announcement_bar_bgcolor'] ??
        json['bannerBackgroundColor'];
    announcementBarTextColor = json['announcement_bar_text_color'] ??
        json['announcement_bar_textcolor'] ??
        json['bannerTextColor'];
    announcementBarUrl = json['announcement_bar_url'];
    headerLogo = json['header_logo'];
    colorsHeaderBackgroundColor = json['colors_header_background_color'];
    colorsHeaderTextColor = json['colors_header_text_color'];
    colorsFooterBackgroundColor = json[AppConfig.isSoreUseNewTheme
            ? 'announcement_bar_text_color'
            : 'colors_footer_background_color'] ??
        json['announcement_bar_textcolor'];
    colorsFooterTextColor = json['colors_footer_text_color'];
    fontsName = json['fonts_name'];
    order = json['order'];
    displayMore = json['display_more'];
    title = json['title'];
    category =
        json['category'] == null ? null : FeaturedProducts.fromJson(json['category']);
    bg_clr_partners = json['bg_clr_partners'];
    main_title_clr = json['main_title_clr'];
    position_title = json['position_title'] ?? json['position_content'];
    position_content = json['position_content'];
    // number_on_sm = json['number_on_sm'];
    hide_dots = json['hide_dots'];
    showSocial = json['show_social'];
    bannerType = json['banner_type'];
    containerType = json['container_type'];
    hide_dots = json['hide_dots'];
    hide_navs = json['hide_navs'];
    category =
        json['category'] == null ? null : FeaturedProducts.fromJson(json['category']);

    if (AppConfig.currentThemeId == duvetThemeId && json['our_offers'] != null) {
      try {
        List items1 = [];
        json['our_offers'].forEach((v) {
          // log(v['product'].toString());
          if (v['product'] != null) {
            items1.add(v['product']);
          }
        });
        products = FeaturedProducts.fromJson({
          'title': titleOffer,
          'products': items1,
        });
      } catch (e) {
        log('$e');
      }
    } else if (AppConfig.currentThemeId == naquaThemeId &&
        json['last_products'] != null) {
      try {
        products = json['last_products'] == null
            ? null
            : FeaturedProducts.fromJson(json['last_products']);
      } catch (e) {
        try {
          products = FeaturedProducts.fromJson({
            'title': title,
            'products': json['last_products'].map((e) => e['product']).toList(),
          });
        } catch (e) {}
      }
    } else {
      try {
        products =
            json['products'] == null ? null : FeaturedProducts.fromJson(json['products']);
      } catch (e) {
        try {
          products = FeaturedProducts.fromJson({
            'title': title,
            'products': json['products'].map((e) => e['product']).toList(),
          });
        } catch (e) {}
      }
    }
    if (AppConfig.currentThemeId == duvetThemeId && json['our_offers'] != null) {
      try {
        List items1 = [];
        json['our_offers'].forEach((v) {
          // log(v['product'].toString());
          if (v['product'] != null) {
            items1.add(v['product']);
          }
        });
        productsCustom = FeaturedProducts.fromJson({
          'title': titleOffer,
          'products': items1,
        });
      } catch (e) {
        log('$e');
      }
    } else if (AppConfig.currentThemeId == naquaThemeId &&
        json['last_products'] != null) {
      try {
        products = json['last_products'] == null
            ? null
            : FeaturedProducts.fromJson(json['last_products']);
      } catch (e) {
        try {
          productsCustom = FeaturedProducts.fromJson({
            'title': title,
            'products': json['last_products'].map((e) => e['product']).toList(),
          });
        } catch (e) {}
      }
    } else {
      try {
        productsCustom =
            json['products'] == null ? null : FeaturedProducts.fromJson(json['products']);
      } catch (e) {
        try {
          productsCustom = FeaturedProducts.fromJson({
            'title': title,
            'products': json['products'].map((e) => e['products']).toList(),
          });
        } catch (e) {}
      }
    }

    if (json['categories'] != null) {
      categories = [];
      json['categories'].forEach((v) {
        if (v == null) return;
        categories?.add(CategoryModel.fromJson(
          v['category'] ?? v,
        ));
      });
    } else if (json['category_items'] != null) {
      categories = [];
      json['category_items'].forEach((v) {
        if (v == null) return;
        categories?.add(CategoryModel.fromJson(v['item'] ?? v, icon: v['icon']));
      });
    }
    if (json['links_1_links'] != null || json['links_urls'] != null) {
      links1Links = [];
      (json['links_1_links'] ?? json['links_urls']).forEach((v) {
        if (v == null) return;
        var element = PageModel.fromJson(v);
        if (element.title != null && (element.id != null || element.url != null)) {
          links1Links?.add(PageModel.fromJson(v));
        }
      });
    }
    if (json['links_2_links'] != null) {
      links2Links = [];
      json['links_2_links'].forEach((v) {
        if (v == null) return;
        var element = PageModel.fromJson(v);
        if (element.title != null && (element.id != null || element.url != null)) {
          links2Links?.add(PageModel.fromJson(v));
        }
      });
    }
    if (json['slider'] != null) {
      slider = [];
      json['slider'].forEach((v) {
        if (v == null) return;
        slider?.add(Items.fromJson(v));
      });
    }
    if (json['links_links'] != null) {
      links_links = [];
      json['links_links'].forEach((v) {
        if (v == null) return;
        log(v.toString());
        links_links?.add(CategoryModel.fromJson(v));
      });
    }
    if (AppConfig.currentThemeId == asayelThemeId && json['main_slider'] != null) {
      slider = [];
      json['main_slider'].forEach((v) {
        if (v == null) return;
        slider?.add(Items.fromJson(v));
      });
    }
    if (json['bannerSliders'] != null) {
      bannerSliders = [];
      json['bannerSliders'].forEach((v) {
        if (v == null) return;
        bannerSliders?.add(Items.fromJson(v));
      });
    }

    if (AppConfig.currentThemeId == asayelThemeId && json['banners'] != null) {
      bannerMobileImage = [];
      json['banners'].forEach((v) {
        bannerMobileImage?.add(BannerImage.fromJson(v));
      });
    }
    if (json['instagram'] != null) {
      instagram = [];
      json['instagram'].forEach((v) {
        if (v == null) return;
        instagram?.add(Items.fromJson(v));
      });
    }
    if (json['header_options'] != null) {
      headerOptions = [];
      json['header_options'].forEach((v) {
        if (v == null) return;
        headerOptions?.add((v));
      });
    }
    if (json['gallery'] != null) {
      gallery = [];
      json['gallery'].forEach((v) {
        if (v == null) return;
        gallery?.add(Items.fromJson(v));
      });
    }
    if (json['ads'] != null) {
      ads = [];
      json['ads'].forEach((v) {
        if (v == null) return;
        ads?.add(Items.fromJson(v));
      });
    }

    var partners = AppConfig.currentThemeId == asayelThemeId
        ? json['partners']
        : json['store_partners'];
    if (partners != null) {
      storePartners = [];
      partners.forEach((v) {
        if (v == null) return;
        storePartners?.add(Items.fromJson(v));
      });
    }
    var testimonialsJson = AppConfig.currentThemeId == monkeyThemeId
        ? json['testimonial']
        : (json['testimonials'] ?? json['testimonial']);
    if (testimonialsJson != null) {
      testimonials = [];
      testimonialsJson.forEach((v) {
        if (v == null) return;
        testimonials?.add(Items.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = [];
      json['reviews'].forEach((v) {
        if (v == null) return;
        reviews?.add(Items.fromJson(v));
      });
    }
    if (json['infos'] != null) {
      infos = [];
      json['infos'].forEach((v) {
        if (v == null) return;
        infos?.add(Items.fromJson(v));
      });
    }
    if (json['store_features'] != null) {
      storeFeatures = [];
      json['store_features'].forEach((v) {
        if (v == null) return;
        storeFeatures?.add(StoreFeatures.fromJson(v));
      });
    }
    if (json['features'] != null) {
      features = [];
      json['features'].forEach((v) {
        if (v == null) return;
        features?.add(StoreFeatures.fromJson(v));
      });
    }
    if (json['brands'] != null) {
      brands = Brands.fromJson({'items': json['brands'], title: title, 'display': true});
    }
    detailsTitle = json['details_title'];
    detailsDesc = json['details_desc'];
    detailsBg = json['details_bg'];
    detailsVideo = json['details_video'];
    detailsVideoImg = json['details_video_img'];
    if (json['faqs_store_features'] != null) {
      faqsStoreFeatures = <FaqsStoreFeaturesModel>[];
      json['faqs_store_features'].forEach((v) {
        faqsStoreFeatures!.add(FaqsStoreFeaturesModel.fromJson(v));
      });
    }
    if (json['menu_settings_links'] != null || json['links_1_links'] != null) {
      menuSettingslinks = [];
      (json['menu_settings_links'] ?? json['links_1_links']).forEach((v) {
        if (v == null) return;
        var item = CategoryModel.fromJson(v);

        if (AppConfig.currentThemeId != royalThemeId ||
            (AppConfig.currentThemeId == royalThemeId &&
                item.name != 'homepage' &&
                !(item.name?.contains('الصفحة الرئيسية') == true))) {
          menuSettingslinks?.add(item);
        }
      });
    }
    if (json['menu_settings_markat'] != null) {
      menuSettingsMarkat = [];
      json['menu_settings_markat'].forEach((v) {
        if (v == null) return;
        menuSettingsMarkat?.add(CategoryModel.fromJson(v));
      });
    }
    if (json['navigation_options'] != null) {
      navigationOptions = [];
      json['navigation_options'].forEach((v) {
        navigationOptions?.add(v);
      });
    }
    if (json['MenuCategories_categoriesList'] != null) {
      MenuCategories_categoriesList = [];
      json['MenuCategories_categoriesList'].forEach((v) {
        MenuCategories_categoriesList?.add(v['selectedCategory']['id'].toString());
      });
    }
  }
}

class StoreFeatures {
  StoreFeatures.fromJson(dynamic json) {
    image = json['image'] ?? json['img'];
    title = json['title'] ?? json['text'];
    textColor = json['text_color'];
    des = json['des'] ?? json['desc'];
  }

  String? image;
  String? title;
  String? des;
  String? textColor;
}

class Links {
  Links.fromJson(dynamic json) {
    title = json['title'];
    url = json['url'];
  }

  String? title;
  String? url;
}

class BannerImage {
  String? image;
  String? url;

  BannerImage.fromJson(dynamic json) {
    image = json['img_mobile'] ?? json['img_banner'];
    url = json['url'];
  }
}
