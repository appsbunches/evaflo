import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:entaj/src/app_config.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../.env.dart';
import 'logic.dart';
import 'package:get/get.dart';

import '../../data/remote/api_requests.dart';
import '../../entities/AppBuilderModel.dart';
import '../../entities/ColorsModel.dart';
import '../../entities/OfferResponseModel.dart';
import '../../entities/faq_model.dart';
import '../../entities/home_screen_model.dart';
import '../../entities/page_model.dart';
import '../../entities/product_details_model.dart';
import '../../utils/error_handler/error_handler.dart';
import '../../utils/functions.dart';

class MainData extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  late MainLogic mainLogic;

  @override
  void onInit() {
    mainLogic = Get.find();
    super.onInit();
  }

  initWebViewControllers(){
      if (AppConfig.showChatBot && AppConfig.showChatBotRemoteConfig) {
        mainLogic.controllerChatBot = WebViewController()
          ..loadRequest(Uri.parse("$storeUrl/pages"))
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(NavigationDelegate(
            onPageFinished: (value) async {
              await Future.delayed(const Duration(seconds: 5));
              try {
                try {
                  await mainLogic.controllerChatBot.runJavaScript(
                      'document.getElementById("bonat_footer").style.display = "none";');
                } catch (e) {}
                await mainLogic.controllerChatBot
                    .runJavaScript("window.BE_API.openChatWindow();");
              } catch (e) {}
              mainLogic.isChatBotLoading = false;
              mainLogic.update(['chat']);
            },
          ));
      }
      if (AppConfig.showTidio && AppConfig.showTidioFromRemoteConfig) {
        mainLogic.controllerTidio = WebViewController()
          ..loadRequest(Uri.parse("$storeUrl/pages"))
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(NavigationDelegate(
            onNavigationRequest: (NavigationRequest request) async {
              if (mainLogic.tidioChatHeight != 0) {
                if (request.url.contains("$storeUrl/pages")) {
                  return NavigationDecision.navigate;
                } else if (request.url.contains("vars.hotjar.com")) {
                  return NavigationDecision.navigate;
                } else {
                  await launch(request.url);
                  return NavigationDecision.prevent;
                }
              } else {
                return NavigationDecision.navigate;
              }
            },
            onPageFinished: (value) async {
              await Future.delayed(const Duration(seconds: 5));
              try {
                await mainLogic.controllerTidio.runJavaScript("""
                           for(const elem of  document.body.getElementsByTagName('*')){
	                           if(elem.className !== "") elem.remove();
	                         }
                           """);
                try {
                  await mainLogic.controllerTidio.runJavaScript("""
                            LiveChatWidget.call("hide");
                            """);
                } catch (e) {}
                await mainLogic.controllerTidio.runJavaScript("""
                           window.tidioChatApi.show();
                           window.tidioChatApi.open();
                           """);
              } catch (e) {
                await Future.delayed(const Duration(seconds: 1));

                try {
                  await mainLogic.controllerTidio.runJavaScript("""
                             for(const elem of  document.body.getElementsByTagName('*')){
	                             if(elem.className !== "") elem.remove();
	                           }
                             """);
                  try {
                    await mainLogic.controllerTidio.runJavaScript("""
                            LiveChatWidget.call("hide");
                            """);
                  } catch (e) {}
                  await mainLogic.controllerTidio.runJavaScript("""
                             window.tidioChatApi.show();
                             window.tidioChatApi.open();
                             """);
                } catch (e) {}
              }

              mainLogic.isTidioLoading = false;
              mainLogic.update(['chat']);
            },
          ));
      }
      if (AppConfig.showLiveChat && AppConfig.showLiveChatFromRemoteConfig) {
        mainLogic.controllerLiveChat = WebViewController()
          ..loadRequest(Uri.parse("$storeUrl/pages"))
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(NavigationDelegate(
            onPageFinished: (value) async {
              await Future.delayed(const Duration(seconds: 2));
              try {
                await mainLogic.controllerLiveChat.runJavaScript("""
                           for(const elem of  document.body.getElementsByTagName('*')){
	                           if(elem.className !== "") elem.remove();
	                         }
                           """);
                await mainLogic.controllerLiveChat.runJavaScript("""
                          LiveChatWidget.call("maximize");
                           """);
              } catch (e) {
                await Future.delayed(const Duration(seconds: 1));
                await mainLogic.controllerLiveChat.runJavaScript("""
                           for(const elem of  document.body.getElementsByTagName('*')){
	                           if(elem.className !== "") elem.remove();
	                         }
                           """);
                try {
                  await mainLogic.controllerLiveChat.runJavaScript("""
                          LiveChatWidget.call("maximize");
                             """);
                } catch (e) {}
              }

              mainLogic.isLiveChatLoading = false;
              mainLogic.update(['chat']);
            },
          ));
      }
  }
  Future<bool> checkInternetConnection() async {
    var connection =
        (await Connectivity().checkConnectivity() != ConnectivityResult.none);

    mainLogic.hasInternet = connection;
    mainLogic.update();
    return connection;
  }

  Future<void> getAppBuilderSections() async {
    if (!await checkInternetConnection()) return;
    getAppBuilderColors();
    mainLogic.isAppBuilderHomeLoading = true;
    mainLogic.update(['appBuilderHome']);
    try {
      var response = await _apiRequests.getAppBuilderSections();
      //log(json.encode(response.data));
      mainLogic.appBuilderModelList = (response.data['data'] as List)
          .map((e) => AppBuilderModel.fromJson(e))
          .toList();
      for (var element in mainLogic.appBuilderModelList) {
        if (element.type == 'fixedProducts' || element.type == 'sliderProducts') {
          getProductsList(element.dataString);
        }
      }
    } catch (e) {
      mainLogic.hasInternet = await ErrorHandler.handleError(e);
    }
    mainLogic.isAppBuilderHomeLoading = false;
    mainLogic.update(['appBuilderHome']);
  }

  Future<void> getAppBuilderColors() async {
    if (!await checkInternetConnection()) return;
    mainLogic.isAppBuilderHomeLoading = true;
    mainLogic.update(['appBuilderHome']);
    try {
      var response = await _apiRequests.getAppBuilderColors();
      //log(json.encode(response.data));
      mainLogic.colorsModel = ColorsModel.fromJson(response.data['data']);
    } catch (e) {
      mainLogic.hasInternet = await ErrorHandler.handleError(e);
    }
    mainLogic.isAppBuilderHomeLoading = false;
    mainLogic.update(['appBuilderHome']);
  }

  Future<void> getProductsList(String? ids) async {
    try {
      var response = await _apiRequests.getProductsListByIds(ids__in: ids, pageSize: 24);

      var productsList = (response.data['results'] as List)
          .map((element) => ProductDetailsModel.fromJson(element))
          .toList();

      List<String> productsIds = [];
      for (var element in productsList) {
        if (element.id != null) {
          productsIds.add(element.id!);
        }
      }

      var res = await _apiRequests.getSimpleBundleOffer(productsIds);
      List<OfferResponseModel> offerList = (res.data['payload'] as List)
          .map((e) => OfferResponseModel.fromJson(e))
          .toList();

      for (var elementProduct in productsList) {
        for (var elementOffer in offerList) {
          if (elementOffer.productIds?.contains(elementProduct.id) == true) {
            elementProduct.offerLabel = elementOffer.name;
          }
        }
      }

      for (var element in mainLogic.appBuilderModelList) {
        if (element.dataString == ids) {
          element.products = FeaturedProducts.fromJson({});
          element.products?.items = productsList;
          element.products?.title = element.title;
        }
      }
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
    mainLogic.update();
  }

  Future<void> getPages(bool forceLoading, {bool withAwait = false}) async {
    mainLogic = Get.find();
    if (!await checkInternet()) return;
    if (withAwait) {
      await getFaqs();
      await getLicense();
      await getPrivacyPolicy();
      await getRefundPolicy();
      await getTermsAndConditions();
      await getComplaintsAndSuggestions();
    } else {
      getFaqs();
      getLicense();
      getPrivacyPolicy();
      getRefundPolicy();
      getTermsAndConditions();
      getComplaintsAndSuggestions();
    }
    if (mainLogic.pagesList.isNotEmpty && !forceLoading) {
      return;
    }
    mainLogic.isPagesLoading = true;
    mainLogic.update(['pages']);
    try {
      var response = await _apiRequests.getPages();
      //log(json.encode(response.data));
      mainLogic.pagesList = (response.data['payload']['store_pages'] as List)
          .map((e) => PageModel.fromJson(e))
          .toList();
      mainLogic.pagesList = await getContentPages(mainLogic.pagesList);
    } catch (e) {
      mainLogic.hasInternet = await ErrorHandler.handleError(e);
    }
    mainLogic.isPagesLoading = false;
    mainLogic.update(['pages']);
  }

  Future<void> getFaqs() async {
    final MainLogic mainLogic = Get.find();
    mainLogic.selectedIndex = null;
    try {
      var res = await _apiRequests.getFaqs();
      mainLogic.faqList =
          (res.data['payload'] as List).map((e) => FaqModel.fromJson(e)).toList();
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
    mainLogic.update(['faq']);
  }

  Future<void> getPrivacyPolicy() async {
    try {
      var response = await _apiRequests.getPrivacyPolicy();
      if (response.data.toString().contains('This store doesn')) {
        return;
      }
      mainLogic.pageModelPrivacy = PageModel.fromJson(response.data['payload']);
      final document = parse(mainLogic.pageModelPrivacy?.content);
      mainLogic.pageModelPrivacy?.contentWithoutTags =
          parse(document.body?.text).documentElement?.text;
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
  }

  Future<void> getComplaintsAndSuggestions() async {
    try {
      var response = await _apiRequests.getComplaintsAndSuggestions();
      if (response.data.toString().contains('This store doesn')) {
        return;
      }
      mainLogic.pageModelSuggestions = PageModel.fromJson(response.data['payload']);
      final document = parse(mainLogic.pageModelSuggestions?.content);
      mainLogic.pageModelSuggestions?.contentWithoutTags =
          parse(document.body?.text).documentElement?.text;
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
  }

  Future<void> getRefundPolicy() async {
    try {
      var response = await _apiRequests.getRefundPolicy();
      if (response.data.toString().contains('This store doesn')) {
        return;
      }
      mainLogic.pageModelRefund = PageModel.fromJson(response.data['payload']);
      // log(pageModelRefund?.content ?? '');
      final document = parse(mainLogic.pageModelRefund?.content);
      mainLogic.pageModelRefund?.contentWithoutTags =
          parse(document.body?.text).documentElement?.text;
      // log(pageModelRefund?.contentWithoutTags ?? '');
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
  }

  Future<void> getTermsAndConditions() async {
    try {
      var response = await _apiRequests.getTermsAndConditions();
      if (response.data.toString().contains('This store doesn')) {
        return;
      }
      mainLogic.pageModelTerms = PageModel.fromJson(response.data['payload']);
      final document = parse(mainLogic.pageModelTerms?.content);
      mainLogic.pageModelTerms?.contentWithoutTags =
          parse(document.body?.text).documentElement?.text;
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
  }

  Future<void> getLicense() async {
    try {
      var response = await _apiRequests.getLicense();
      if (response.data.toString().contains('This store doesn')) {
        return;
      }
      mainLogic.pageModelLicense = PageModel.fromJson(response.data['payload']);
      final document = parse(mainLogic.pageModelLicense?.content);
      mainLogic.pageModelLicense?.contentWithoutTags =
          parse(document.body?.text).documentElement?.text;
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
  }

  Future<List<PageModel>> getContentPages(List<PageModel> pagesList) async {
    await Future.forEach<PageModel>(pagesList, (element) async {
      try {
        if (element.id != null || element.url?.contains('custom-page') == true) {
          var response = await _apiRequests.getPagesDetails(
              pageId: element.id ??
                  int.parse(element.url!.substring(
                      element.url!.indexOf('custom-page/') + 12,
                      element.url!.indexOf('custom-page/') + 17)));
          var page = PageModel.fromJson(response.data['payload']);
          final document = parse(page.content);
          page.contentWithoutTags = parse(document.body?.text).documentElement?.text;
          page.contentWithoutTags = page.content;
          page.contentWithoutTags = '123';
          pagesList[pagesList.indexOf(element)] = page;
        } else if (element.url != null) {
          if (!element.url!.contains('') &&
              !element.url!.contains('live-gold-price') &&
              !element.url!.contains('حاسبة-زكاة') &&
              !element.url!.contains('categories') &&
              !element.url!.contains('products') &&
              // !element.url!.contains('https://') &&
              // !element.url!.contains('http://') &&
              !element.url!.contains('privacy-policy') &&
              !element.url!.contains('refund-exchange-policy') &&
              !element.url!.contains('terms-and-conditions') &&
              !element.url!.contains('complaints-and-suggestions') &&
              !element.url!.contains('/license') &&
              !element.url!.contains('shipping-and-payment') &&
              !element.url!.contains('/faqs')) {
            var slug = element.url?.substring(element.url!.lastIndexOf('/'));
            slug = slug?.replaceAll('/pages/', '');
            slug = slug?.replaceAll('/blogs/', '');

            var response = await _apiRequests.getPagesDetailsBySlug(slug: slug);
            var page = PageModel.fromJson(response.data['payload']);
            final document = parse(page.content);
            page.contentWithoutTags = parse(document.body?.text).documentElement?.text;
            page.contentWithoutTags = page.content;
            page.contentWithoutTags = '123';
            pagesList[pagesList.indexOf(element)] = page;
          }
        }
      } catch (e) {
        ErrorHandler.handleError(e, showToast: false);
      }
    });
    List<PageModel> newList = [];
    pagesList.forEach((element) {
      if (element.title?.isNotEmpty == true || element.content?.isNotEmpty == true) {
        newList.add(element);
      }
    });
    return newList;
  }

  Future<void> getOffers() async {
    try {
      List<String> productsIds = [];

      mainLogic.homeScreenNewThemeModel?.payload?.files?.forEach((element) {
        if (element.name == 'category-products-section.twig') {
          element.modules?.forEach((element2) {
            element2.settings?.category?.items?.forEach((element3) {
              productsIds.add(element3.id!);
            });
          });
        }
        if (element.name == 'products-section.twig') {
          element.modules?.forEach((element2) {
            element2.settings?.products?.items?.forEach((element3) {
              productsIds.add(element3.id!);
            });
          });
        }
      });
      mainLogic.homeScreenModel?.featuredProducts?.items?.forEach((element) {
        if (element.id != null) {
          productsIds.add(element.id!);
        }
      });
      mainLogic.homeScreenModel?.featuredProducts?.items?.forEach((element) {
        if (element.id != null) {
          productsIds.add(element.id!);
        }
      });

      mainLogic.homeScreenModel?.featuredProducts2?.items?.forEach((element) {
        if (element.id != null) {
          productsIds.add(element.id!);
        }
      });

      mainLogic.homeScreenModel?.featuredProducts3?.items?.forEach((element) {
        if (element.id != null) {
          productsIds.add(element.id!);
        }
      });
      mainLogic.homeScreenModel?.featuredProducts4?.items?.forEach((element) {
        if (element.id != null) {
          productsIds.add(element.id!);
        }
      });
      mainLogic.homeScreenModel?.onSaleProducts?.items?.forEach((element) {
        if (element.id != null) {
          productsIds.add(element.id!);
        }
      });

      mainLogic.homeScreenModel?.recentProducts?.items?.forEach((element) {
        if (element.id != null) {
          productsIds.add(element.id!);
        }
      });

      var res = await _apiRequests.getSimpleBundleOffer(productsIds);
      List<OfferResponseModel> offerList = (res.data['payload'] as List)
          .map((e) => OfferResponseModel.fromJson(e))
          .toList();

      mainLogic.homeScreenModel?.featuredProducts?.items?.forEach((elementProduct) {
        for (var elementOffer in offerList) {
          if (elementOffer.productIds?.contains(elementProduct.id) == true) {
            elementProduct.offerLabel = elementOffer.name;
          }
        }
      });
      mainLogic.homeScreenModel?.featuredProducts2?.items?.forEach((elementProduct) {
        for (var elementOffer in offerList) {
          if (elementOffer.productIds?.contains(elementProduct.id) == true) {
            elementProduct.offerLabel = elementOffer.name;
          }
        }
      });
      mainLogic.homeScreenModel?.featuredProducts3?.items?.forEach((elementProduct) {
        for (var elementOffer in offerList) {
          if (elementOffer.productIds?.contains(elementProduct.id) == true) {
            elementProduct.offerLabel = elementOffer.name;
          }
        }
      });
      mainLogic.homeScreenModel?.featuredProducts4?.items?.forEach((elementProduct) {
        for (var elementOffer in offerList) {
          if (elementOffer.productIds?.contains(elementProduct.id) == true) {
            elementProduct.offerLabel = elementOffer.name;
          }
        }
      });
      mainLogic.homeScreenModel?.onSaleProducts?.items?.forEach((elementProduct) {
        for (var elementOffer in offerList) {
          if (elementOffer.productIds?.contains(elementProduct.id) == true) {
            elementProduct.offerLabel = elementOffer.name;
          }
        }
      });
      mainLogic.homeScreenModel?.recentProducts?.items?.forEach((elementProduct) {
        for (var elementOffer in offerList) {
          if (elementOffer.productIds?.contains(elementProduct.id) == true) {
            elementProduct.offerLabel = elementOffer.name;
          }
        }
      });
      mainLogic.homeScreenModel?.recentProducts?.items?.forEach((elementProduct) {
        for (var elementOffer in offerList) {
          if (elementOffer.productIds?.contains(elementProduct.id) == true) {
            elementProduct.offerLabel = elementOffer.name;
          }
        }
      });
      mainLogic.homeScreenNewThemeModel?.payload?.files?.forEach((element) {
        if (element.name == 'category-products-section.twig') {
          element.modules?.forEach((element2) {
            element2.settings?.category?.items?.forEach((element3) {
              for (var elementOffer in offerList) {
                if (elementOffer.productIds?.contains(element3.id) == true) {
                  element3.offerLabel = elementOffer.name;
                }
              }
            });
          });
        }
      });
      mainLogic.homeScreenNewThemeModel?.payload?.files?.forEach((element) {
        if (element.name == 'products-section.twig') {
          element.modules?.forEach((element2) {
            element2.settings?.products?.items?.forEach((element3) {
              for (var elementOffer in offerList) {
                if (elementOffer.productIds?.contains(element3.id) == true) {
                  element3.offerLabel = elementOffer.name;
                }
              }
            });
          });
        }
      });
    } catch (e) {}
  }
}
