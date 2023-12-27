import 'package:entaj/src/modules/_main/widgets/banner_slider_widget.dart';
import 'package:entaj/src/modules/_main/widgets/countdown_widget.dart';
import 'package:entaj/src/modules/_main/widgets/description_widget.dart';
import 'package:entaj/src/modules/_main/widgets/faqs_widget.dart';
import 'package:entaj/src/modules/_main/widgets/icon_box_widget.dart';
import 'package:entaj/src/modules/_main/widgets/trust_payment_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../.env.dart';
import '../../../../app_config.dart';
import '../../../../custom_home_widget.dart';
import '../../../../entities/home_screen_model.dart';
import '../../../../entities/module_model.dart';
import '../../logic.dart';
import '../../widgets/annoucement_bar_widget.dart';
import '../../widgets/availability_bar_widget.dart';
import '../../widgets/banner_widget.dart';
import '../../widgets/brand_widget.dart';
import '../../widgets/categories_grid_widget.dart';
import '../../widgets/categories_widget.dart';
import '../../widgets/custom_products_wigget.dart';
import '../../widgets/features_widget.dart';
import '../../widgets/gallery_widget.dart';
import '../../widgets/instagram_widget.dart';
import '../../widgets/partners_widget.dart';
import '../../widgets/products_wigget.dart';
import '../../widgets/slider_widget.dart';
import '../../widgets/testimonials_widget.dart';
import '../../widgets/video_widget.dart';

class HomeLogic extends GetxController {
  late MainLogic _mainLogic;
  List<ModuleModel> moduleList = [];
  Map<String?, int?> displayOrderMap = {};

  @override
  void onInit() {
    _mainLogic = Get.find<MainLogic>();
    super.onInit();
  }

  List<Widget> getDisplayOrderModule() {
    moduleList = [];
    List<Widget> widgets = [];
    Settings? banner;
    _mainLogic.homeScreenNewThemeModel?.payload?.files?.forEach((file) {
      file.modules?.forEach((module) {
        if (module.settings?.order == null) {
          if (module.settings?.bannerSliders?.isNotEmpty == true) {
            banner = module.settings;
          }
          return;
        }
        moduleList.add(module);
      });
    });

    moduleList.sort((a, b) => a.settings!.order!.compareTo(b.settings!.order!));
    widgets.add(BannerSliderWidget(banner: banner));
    widgets.add(const AvailabilityBarWidget());
    widgets.add(const CustomHomeWidget());
    widgets.add(const AnnouncementBarWidget());
    widgets.add(CategoriesWidget());
    bool hasSlider = false;
    for (var element in moduleList) {
      if (element.settings?.slider?.isNotEmpty == true) {
        if (element.fileName == 'main-slider.twig' ||
            element.fileName == 'main_slider2.twig' ||
            element.fileName == 'slider.twig' ||
            element.fileName == 'sslider.twig' ||
            element.fileName == 'slider_img.twig' ||
            element.fileName == 'img-slider.twig' ||
            element.fileName == 'templete-velvet-main-slider.twig') {
          if (!hasSlider) {
            if (AppConfig.showOneSlider) {
              hasSlider = true;
            }
            widgets.add(SliderWidget(
                sliderItems: element.settings?.slider ?? [],
                textColor: element.settings?.textColor,
                backgroundColor: element.settings?.backgroundColor,
                hideDots: element.settings?.slider?.length == 1
                    ? true
                    : element.settings?.hideDots ?? false));
          }
        }
      } else if (element.fileName == 'ggallery.twig' ||
          element.fileName == 'gallery.twig' ||
          element.fileName == 'template-velvet-gallery.twig') {
        if (element.settings?.gallery != null) {
          List<Items> galleryItems = [];
          element.settings?.gallery?.forEach((element) {
            if (element.image != null) galleryItems.add(element);
          });
          widgets.add(GalleryWidget(
            galleryItems: galleryItems,
            showAsColumn: element.fileName == 'gallery.twig' ||
                AppConfig.currentThemeId == foodyThemeId,
            title: element.settings?.title,
          ));
        }
      } else if (element.fileName == 'home-banners-section.twig') {
        if (element.settings?.ads != null) {
          List<Items> galleryItems = [];
          element.settings?.ads?.forEach((element) {
            if (element.image != null) galleryItems.add(element);
          });
          widgets.add(GalleryWidget(
            galleryItems: galleryItems,
            showAsColumn: true,
            title: element.settings?.title,
          ));
        }
      } else if (element.fileName == 'features-section.twig' ||
          element.fileName == 'features.twig' ||
          element.fileName == 'store-features.twig') {
        if (element.settings?.storeFeatures != null) {
          final List<StoreFeatures> list = [];
          element.settings?.storeFeatures?.forEach((element) {
            if (element.image != null) list.add(element);
          });
          widgets.add(FeaturesWidget(
            storeFeatures: element.settings?.storeFeatures ?? [],
            bgColor: null,
          ));
        }
        if (element.settings?.features != null) {
          final List<StoreFeatures> list = [];
          element.settings?.features?.forEach((element) {
            if (element.image != null) list.add(element);
          });
          widgets.add(FeaturesWidget(
            storeFeatures: list,
            bgColor: element.settings?.bgColor,
            title: element.settings?.title,
            desc: element.settings?.des,
            mainTitleClr: element.settings?.main_title_clr,
            titleFeatureClr: element.settings?.titleFeatureClr,
            contentFeatureClr: element.settings?.contentFeatureClr,
            positionTitle: element.settings?.position_title,
            positionContent: element.settings?.position_content,
            bgClrFeature: element.settings?.bgColorFeature,
          ));
        }
      } else if (element.fileName == 'category-products-section.twig' ||
          element.fileName == 'home-category-products.twig' ||
          element.fileName == 'home-products-section.twig') {
        widgets.add(ProductsWidget(
          featuredProducts: element.settings?.category,
          displayMore: element.settings?.displayMore,
          moreText: element.settings?.displayMore == true ? 'عرض الكل'.tr : null,
        ));
      } else if (element.fileName == 'category-section.twig' ||
          element.fileName == 'template-velvet-category-section.twig' ||
          element.fileName == 'home-categories.twig' ||
          element.fileName == 'categories.twig' ||
          element.fileName == 'categories_banner.twig' ||
          element.fileName == 'categories-selected.twig' ||
          element.fileName == 'home-categories-section.twig') {
        // if (element.settings?.categories != null) {
        widgets.add(CategoriesGridWidget(
          title: element.settings?.title ?? element.settings?.sectionTitle,
          sectionSubTitle: element.settings?.sectionSubTitle,
          titleColor: element.settings?.titleSectionClr,
          descColor: element.settings?.descSectionClr,
          bgSection: element.settings?.bgColor,
          containerType: element.settings?.containerType,
          showAsColumn: AppConfig.currentThemeId == duvetThemeId,
          categories: element.fileName == 'categories_banner.twig'
              ? _mainLogic.homeScreenNewThemeModel?.payload?.menu?.items
              : element.settings?.categories,
          moreText:
              element.settings?.displayMore == true ? element.settings?.moreText : null,
          moreClr: element.settings?.moreClr,
          catStyle: element.settings?.catStyle,
          number: element.settings?.numberOnSm,
          numberOnLg: element.settings?.numberOnLg,
          numberOnMd: element.settings?.numberOnMd,
          hideDots: element.settings?.hide_dots ?? false,
          hideNav: element.settings?.hide_navs ?? false,
          titleCenter: element.settings?.titleCenter ?? false,
        ));
        // }
      } else if (element.fileName == 'custom_product.twig' &&
          AppConfig.currentThemeId == asayelThemeId) {
        widgets.add(ProductsWidget(
          desc: element.settings?.des,
          moreTextColor: element.settings?.moreClr,
          titleCenter: element.settings?.titleCenter ?? false,
          descColor: element.settings?.descSectionClr,
          bgSectionColor: element.settings?.bgSection,
          hideDots: element.settings?.hideDots ?? false,
          containerType: element.settings?.containerType,
          titleColor: element.settings?.titleSectionClr,
          featuredProducts: element.settings?.productsCustom,
          numberOfSm: element.settings?.numberOnSm ?? 2.0,
          fixedProducts: element.fileName == 'product_grid.twig',
          title: element.settings?.title ??
              element.settings?.titleOffer ??
              element.settings?.sectionTitle,
          moreText:
              element.settings?.displayMore == true ? element.settings?.moreText : null,
          displayMore: element.settings?.displayMore,
        ));
      } else if (element.fileName == 'product-category.twig') {
        widgets.add(CustomProductsWidget(
          productsCategories: element.settings?.customProducts ?? [],
          title: element.settings?.title,
          moreText: element.settings?.displayMore == true ? 'عرض الكل'.tr : null,
        ));
      } else if (element.fileName == 'home-faqs-section.twig') {
        widgets.add(FaqsWidget(model: element.settings));
      } else if (element.fileName == 'trust_payment.twig') {
        if (element.settings?.showOnMobile ?? false) {
          widgets.add(const TrustPayment());
        }
      } else if (element.fileName == 'testimonials.twig' ||
          element.fileName == 'home-reviews-section.twig' ||
          element.fileName == 'home-testimonials-section.twig') {
        widgets.add(TestimonialWidget(
          title: AppConfig.currentThemeId == royalThemeId
              ? "ماذا قالو عن متجرنا"
              : element.settings?.title ??
                  element.settings?.titleOffer ??
                  element.settings?.sectionTitle,
          display: true,
          desc: element.settings?.des,
          bgClr: element.settings?.bgColor,
          titleClr: element.settings?.main_title_clr,
          positionTitle: element.settings?.position_title,
          hideDots: element.settings?.hideDots ?? false,
          items: element.settings?.testimonials ?? element.settings?.reviews ?? [],
        ));
      } else if (element.fileName == 'partners.twig') {
        widgets.add(PartnersWidget(
            title: element.settings?.title,
            desc: element.settings?.des,
            backgroundColor: element.settings?.bg_clr_partners,
            mainColorTitle: element.settings?.main_title_clr,
            positionTitle: element.settings?.position_title,
            number: element.settings?.numberOnSm ?? 2.0,
            hideDots: element.settings?.hide_dots ?? false,
            hideNav: element.settings?.hide_navs ?? false,
            gallery: element.settings?.storePartners));
      } else if (element.fileName == 'video.twig') {
        if (element.settings?.video != null) {
          widgets.add(VideoWidget(
            settings: element.settings,
          ));
        }
      } else if (element.fileName == 'products-section.twig' ||
          element.fileName == 'products.twig' ||
          element.fileName == 'offers.twig' ||
          element.fileName == 'section_products.twig' ||
          element.fileName == 'product_grid.twig' ||
          element.fileName == 'top_picks_products.twig' ||
          element.fileName == 'bestseller-section.twig' ||
          element.fileName == 'products-selected.twig' ||
          element.fileName == 'home-featured-products-section.twig') {
        widgets.add(ProductsWidget(
          desc: element.settings?.des,
          moreTextColor: element.settings?.moreClr,
          titleCenter: element.settings?.titleCenter ?? false,
          descColor: element.settings?.descSectionClr,
          bgSectionColor: element.settings?.bgSection,
          hideDots: element.settings?.hideDots ?? false,
          containerType: element.settings?.containerType,
          titleColor: element.settings?.titleSectionClr,
          featuredProducts: element.settings?.products,
          numberOfSm: element.settings?.numberOnSm ?? 2,
          fixedProducts: element.fileName == 'product_grid.twig',
          title: element.settings?.title ??
              element.settings?.titleOffer ??
              element.settings?.sectionTitle,
          moreText: (element.settings?.displayMore == true ||
                  AppConfig.currentThemeId == softThemeId)
              ? element.settings?.moreText
              : null,
          displayMore: element.settings?.displayMore,
        ));
      } else if (element.fileName == 'instagram-gallery.twig') {
        widgets.add(InstagramWidget(
          title: element.settings?.title,
          instagramAccount: element.settings?.instagramAccount,
          instagramList: element.settings?.instagram ?? [],
        ));
      } else if (element.fileName == 'store-description.twig') {
        widgets.add(DescriptionWidget(
          title: element.settings?.title,
          desc: element.settings?.des,
          displaySocialMedia: element.settings?.displaySocialMedia ?? false,
        ));
      } else if (element.fileName == 'banner.twig' ||
          element.fileName == 'large-banner.twig' ||
          element.fileName == 'banner_img.twig' ||
          element.fileName == 'image-with-text.twig' ||
          element.fileName == 'big-banner.twig') {
        if (element.settings != null) {
          if (AppConfig.currentThemeId != duvetThemeId) {
            if (element.settings!.mobileImage != null ||
                element.settings!.image != null) {
              widgets.add(BannerWidget(
                banner: element.settings!,
                backgroundBanner: element.settings?.backgroundBanner,
                containerType: element.settings?.containerType,
              ));
            } else if (AppConfig.currentThemeId == asayelThemeId &&
                element.fileName == 'banner_img.twig') {
              element.settings?.bannerMobileImage?.forEach((e) {
                widgets.add(BannerWidget(
                  bannerImage: e,
                  banner: element.settings!,
                  containerType: element.settings?.containerType,
                  backgroundBanner: element.settings?.backgroundBanner,
                ));
              });
            }
          } else {
            widgets.add(BannerWidget(
              banner: element.settings!,
              containerType: element.settings?.containerType,
            ));
          }
        }
      } else if (element.fileName == 'home-brands-section.twig' ||
          element.fileName == 'home-brands.twig') {
        if (element.settings != null) {
          widgets.add(BrandWidget(
            brands: element.settings?.brands,
          ));
        }
      } else if (element.fileName == 'icon_box.twig') {
        if ((element.settings?.infos ?? []).isNotEmpty) {
          widgets.add(IconBoxWidget(infos: element.settings!.infos!.first));
        }
      } else if (element.fileName == 'countdown_banner.twig') {
        widgets.add(CountdownWidget(
            countdownDate: element.settings?.countdownDate,
            image: element.settings?.countdownImage));
      }
    }

    widgets.add(const SizedBox(
      height: 15,
    ));
    return widgets;
  }

  ///AnnouncementBar
  bool announcementBarDisplay = true;
  String? announcementBarText;
  String? announcementBarLink;
  String? announcementBarForegroundColor;
  String? announcementBarBackgroundColor;

  void hideAnnouncementBar() {
    _mainLogic.showAnnouncementBar = false;
    update(['announcementBar']);
  }

  getAnnouncementBar() {
    getDisplayOrderModule();
    if (AppConfig.isSoreUseNewTheme) {
      _mainLogic.homeScreenNewThemeModel?.payload?.files?.forEach((element) {
        if (element.name == 'header.twig') {
          if (element.modules != null) {
            if (element.modules!.isNotEmpty) {
              var item = element.modules!.first;
              announcementBarText = item.settings?.announcementBarText;
              announcementBarLink = item.settings?.announcementBarUrl;
              announcementBarDisplay = announcementBarText != null &&
                  announcementBarText != '' &&
                  item.settings?.announcementBarDisplay == true &&
                  _mainLogic.showAnnouncementBar;
              announcementBarForegroundColor = item.settings?.colorsFooterBackgroundColor;
              announcementBarBackgroundColor =
                  item.settings?.announcementBarBackgroundColor;
            }
          }
        }
      });
    } else {
      announcementBarText = _mainLogic.settingModel?.header?.announcementBar?.text;
      announcementBarLink = _mainLogic.settingModel?.header?.announcementBar?.link;
      announcementBarDisplay = announcementBarText != null &&
          announcementBarText != '' &&
          _mainLogic.settingModel?.header?.announcementBar?.enabled == true &&
          _mainLogic.showAnnouncementBar;
      announcementBarForegroundColor =
          _mainLogic.settingModel?.header?.announcementBar?.style?.foregroundColor;
      announcementBarBackgroundColor =
          _mainLogic.settingModel?.header?.announcementBar?.style?.backgroundColor;
    }
  }

  ///Slider
  int sliderOrderDisplay = 0;
  bool sliderDisplay = true;
  List<Items> sliderItems = [];

  getSlider() {
    if (AppConfig.isSoreUseNewTheme) {
      _mainLogic.homeScreenNewThemeModel?.payload?.files?.forEach((element) {
        if (element.name == 'main-slider.twig') {
          if (element.modules != null) {
            if (element.modules!.isNotEmpty) {
              var item = element.modules!.first;
              sliderItems = item.settings?.slider ?? [];
              sliderDisplay = sliderItems.isNotEmpty;
              sliderOrderDisplay = item.settings?.order ?? 0;
            }
          }
        }
      });
    } else {
      sliderItems = _mainLogic.slider?.items ?? [];
      sliderDisplay = _mainLogic.slider?.display == true && sliderItems.isNotEmpty;
    }
  }

  ///Gallery
  List<Items> galleryItems = [];

  getGallery() {
    if (AppConfig.isSoreUseNewTheme) {
      galleryItems = [];
      _mainLogic.homeScreenNewThemeModel?.payload?.files?.forEach((element) {
        if (element.name == 'ggallery.twig') {
          if (element.modules != null) {
            if (element.modules!.isNotEmpty) {
              element.modules?.forEach((element) {
                galleryItems.addAll(element.settings?.gallery ?? []);
              });
            }
          }
        }
      });
    }
  }

  List<Widget> getAppBuilderItems() {
    moduleList = [];
    List<Widget> widgets = [];

    widgets.add(const AvailabilityBarWidget());
    widgets.add(const CustomHomeWidget());
    widgets.add(CategoriesWidget());

    _mainLogic.appBuilderModelList.forEach((module) {
      if (module.type == 'sliderImages') {
        widgets.add(SliderWidget(
            sliderItems: module.dataList ?? [],
            textColor: null,
            backgroundColor: null,
            hideDots: false));
      }
      if (module.type == 'bannerTestimonails') {
        widgets.add(TestimonialWidget(
          title: module.title,
          display: true,
          items: module.dataList ?? [],
        ));
      }
      if (module.type == 'wideBanner') {
        if (module.data != null) {
          widgets.add(SliderWidget(
              sliderItems: [module.data!],
              textColor: null,
              backgroundColor: null,
              hideDots: false));
        }
      }
      if (module.type == 'fixedImages') {
        widgets
            .add(GalleryWidget(galleryItems: module.dataList ?? [], showAsColumn: false));
      }
      if (module.type == 'fixedProducts') {
        widgets.add(ProductsWidget(
          featuredProducts: module.products,
          fixedProducts: true,
        ));
      }
      if (module.type == 'sliderProducts') {
        widgets.add(ProductsWidget(featuredProducts: module.products));
      }

      widgets.add(const SizedBox(
        height: 15,
      ));
    });
    return widgets;
  }
}
