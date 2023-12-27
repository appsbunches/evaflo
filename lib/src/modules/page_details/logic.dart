import '../../data/remote/api_requests.dart';
import '../../entities/page_model.dart';
import '../../utils/error_handler/error_handler.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';

import '../../utils/functions.dart';

class PageDetailsLogic extends GetxController {
  final ApiRequests _apiRequests = Get.find();
  bool isLoading = false;
  PageModel? pageModel;

  Future<void> getPageDetailsSlug(String? slug) async {
    isLoading = true;
    update();
    try {
      slug = slug?.substring(slug.lastIndexOf('/'));
      slug = slug?.replaceAll('/pages/', '');
      slug = slug?.replaceAll('/blogs/', '');
      var response = await _apiRequests.getPagesDetailsBySlug(slug: slug);

      pageModel = PageModel.fromJson(response.data['payload']);
      final document = parse(pageModel?.content);
      pageModel?.contentWithoutTags = parse(document.body?.text).documentElement?.text;
      pageModel?.contentWithoutTags = pageModel?.content;
      pageModel?.contentWithoutTags = '123';
    } catch (e) {

      ErrorHandler.handleError(e);
    }
    update();
    if (pageModel?.id == 27514 || pageModel?.content?.contains('iframe') == true) {
      isLoading = false;
      await Future.delayed(const Duration(seconds: 3));
      update();
    } else {
      isLoading = false;
      update();
    }
  }

  Future<void> getPageDetails(int? pageId) async {
    isLoading = true;
    update();
    try {
      var response = await _apiRequests.getPagesDetails(pageId: pageId);
      pageModel = PageModel.fromJson(response.data['payload']);
      final document = parse(pageModel?.content);
      pageModel?.contentWithoutTags = parse(document.body?.text).documentElement?.text;
      pageModel?.contentWithoutTags = '123';
    } catch (e,stacktrace) {
      ErrorHandler.handleError(e,stacktrace:stacktrace);
    }
    update();
    if (pageModel?.id == 27514 || pageModel?.content?.contains('iframe') == true) {
      isLoading = false;
      await Future.delayed(const Duration(seconds: 3));
      update();
    } else {
      isLoading = false;
      update();
    }
  }

  Future<void> getPrivacyPolicy() async {
    isLoading = true;
    update();
    try {
      var response = await _apiRequests.getPrivacyPolicy();
      if (response.data.toString().contains('This store doesn')) {
        //   Fluttertoast.showToast(msg: response.data['payload'].toString());
        isLoading = false;
        update();
        return;
      }
      pageModel = PageModel.fromJson(response.data['payload']);
      final document = parse(pageModel?.content);
      pageModel?.contentWithoutTags = parse(document.body?.text).documentElement?.text;
    } catch (e,stacktrace) {
      ErrorHandler.handleError(e,stacktrace:stacktrace);
    }
    isLoading = false;
    update();
  }

  Future<void> getLicense() async {
    isLoading = true;
    update();
    try {
      var response = await _apiRequests.getLicense();
      if (response.data.toString().contains('This store doesn')) {
        //   Fluttertoast.showToast(msg: response.data['payload'].toString());
        isLoading = false;
        update();
        return;
      }
      pageModel = PageModel.fromJson(response.data['payload']);
      final document = parse(pageModel?.content);
      pageModel?.contentWithoutTags = parse(document.body?.text).documentElement?.text;
    } catch (e,stacktrace) {
      ErrorHandler.handleError(e,stacktrace:stacktrace);
    }
    isLoading = false;
    update();
  }

  Future<void> getComplaintsAndSuggestions() async {
    isLoading = true;
    update();
    try {
      var response = await _apiRequests.getComplaintsAndSuggestions();
      if (response.data.toString().contains('This store doesn')) {
        //   Fluttertoast.showToast(msg: response.data['payload'].toString());
        isLoading = false;
        update();
        return;
      }
      pageModel = PageModel.fromJson(response.data['payload']);
      final document = parse(pageModel?.content);
      pageModel?.contentWithoutTags = parse(document.body?.text).documentElement?.text;
    } catch (e,stacktrace) {
      ErrorHandler.handleError(e,stacktrace:stacktrace);
    }
    isLoading = false;
    update();
  }

  Future<void> getRefundPolicy() async {
    isLoading = true;
    update();
    try {
      var response = await _apiRequests.getRefundPolicy();
      if (response.data.toString().contains('This store doesn')) {
        //   Fluttertoast.showToast(msg: response.data['payload'].toString());
        isLoading = false;
        update();
        return;
      }
      pageModel = PageModel.fromJson(response.data['payload']);
      final document = parse(pageModel?.content);
      pageModel?.contentWithoutTags = parse(document.body?.text).documentElement?.text;
    } catch (e,stacktrace) {
      ErrorHandler.handleError(e,stacktrace:stacktrace);
    }
    isLoading = false;
    update();
  }

  Future<void> getTermsAndConditions() async {
    isLoading = true;
    update();
    try {
      var response = await _apiRequests.getTermsAndConditions();
      if (response.data.toString().contains('This store doesn')) {
        showMessage(response.data['payload'].toString(), 2);
        isLoading = false;
        update();
        return;
      }
      pageModel = PageModel.fromJson(response.data['payload']);
      final document = parse(pageModel?.content);
      pageModel?.contentWithoutTags = parse(document.body?.text).documentElement?.text;
      //log(pageModel?.content ?? '');
    } catch (e,stacktrace) {
      ErrorHandler.handleError(e,stacktrace:stacktrace);
    }
    isLoading = false;
    update();
  }
}
