// ignore_for_file: unused_local_variable

import 'package:entaj/src/utils/custom_widget/custom_text.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/functions.dart';

import '../../data/remote/api_requests.dart';
import '../../entities/order_model.dart';
import '../../entities/reviews_model.dart';
import 'widgets/add_review_dialog.dart';
import '../_main/logic.dart';
import '../../utils/error_handler/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsLogic extends GetxController {
  final MainLogic mainLogic = Get.find();
  final ApiRequests _apiRequests = Get.find();
  final TextEditingController commentController = TextEditingController();
  double? rating;
  bool isAnonymous = false;
  bool isLoading = true;
  bool isReviewsLoading = true;
  bool isAddReviewLoading = false;
  OrderModel? orderModel;
  String? lastOrderCode;

  Future<void> getOrdersDetails(String orderCode, bool forceLoading) async {
    if (orderCode == lastOrderCode && !forceLoading) {
      return;
    }
    isLoading = true;
    update();

    lastOrderCode = orderCode;
    try {
      var response = await _apiRequests.getOrdersDetails(orderCode);
      //log(json.encode(response.data));
    /*  orderModel = OrderModel.fromJson({
        "id": 27399481,
        "code": "9ORZAwkq43",
        "store_id": 224947,
        "order_url": "https://evaflo.co/o/9ORZAwkq43/inv",
        "store_name": "Evaflo",
        "shipping_method_code": "zid_zidship.level_4",
        "store_url": "https://evaflo.co/",
        "order_status": {
            "name": "تم التوصيل",
            "code": "delivered"
        },
        "currency_code": "SAR",
        "customer": {
            "id": 179647,
            "name": "zid-test",
            "verified": 1,
            "email": "a.alkallas@zid.sa",
            "mobile": "966500000005",
            "note": "This is a demo order for the purpose of testing the system. Please cancel this order.",
            "type": "individual"
        },
        "has_different_consignee": true,
        "is_guest_customer": 0,
        "is_gift_order": 1,
        "gift_card_details": {
            "media_link": "https://www.youtube.com",
            "card_design": "{\"file\": https://media.zid.store/b2df7841-8071-401e-8883-77c9cb7cd9a1/7dc6e7c9-66f9-41cc-9318-46e224156bb5.png}",
            "sender_name": "hosam",
            "gift_message": "helloo",
            "receiver_name": "abed"
        },
        "order_total": "899.10000000000000",
        "order_total_string": "899.10 SAR",
        "has_different_transaction_currency": false,
        "transaction_reference": null,
        "transaction_amount": 899.1,
        "transaction_amount_string": "899.10 SAR",
        "issue_date": "14-09-2023 | 11:33 ص",
        "payment_status": "paid",
        "source": "تطبيق المتجر",
        "source_code": "mobile_app",
        "is_reseller_transaction": false,
        "created_at": "2023-09-14 08:33:06",
        "updated_at": "2023-09-25 12:50:09",
        "tags": [],
        "requires_shipping": true,
        "shipping": {
            "method": {
                "id": 503934,
                "name": "عادي",
                "code": "zid_zidship",
                "estimated_delivery_time": "1-5 أيام عمل",
                "icon": "https://media.zid.store/static/default/icons/zidship_3.png",
                "is_system_option": true,
                "waybill": null,
                "waybill_tracking_id": null,
                "has_waybill_and_packing_list": false,
                "tracking": {
                    "number": null,
                    "status": "N/A",
                    "url": null
                },
                "courier": null,
                "return_shipment": null
            },
            "address": {
                "formatted_address": null,
                "street": "Dd",
                "district": "Dad",
                "lat": null,
                "lng": null,
                "meta": {
                    "buyer": {
                        "name": "zid-test",
                        "type": "individual",
                        "email": "a.alkallas@zid.sa",
                        "telephone": "966500000005"
                    }
                },
                "city": {
                    "id": 1,
                    "name": "الرياض"
                },
                "country": {
                    "id": 184,
                    "name": "السعودية"
                }
            }
        },
        "payment": {
            "method": {
                "name": "تحويل بنكي",
                "code": "zid_bank_transfer",
                "type": "zid_bank_transfer",
                "transaction_status": "transfered",
                "transaction_status_name": "مؤكد",
                "transaction_bank": null,
                "transaction_slip": null,
                "transaction_sender_name": null,
                "updated_at": "2023-09-14 10:26:11"
            },
            "invoice": [
                {
                    "code": "sub_totals_before_vat",
                    "value": "999.00000000000000",
                    "value_string": "999.00 SAR",
                    "title": "المجموع غير شامل الضريبة"
                },
                {
                    "code": "products_discount",
                    "value": "-99.90000000000000",
                    "value_string": "-99.90 SAR",
                    "title": "التخفيض"
                },
                {
                    "code": "sub_totals_after_products_discount",
                    "value": "899.10000000000000",
                    "value_string": "899.10 SAR",
                    "title": "قيمة المنتجات بعد التخفيض"
                },
                {
                    "code": "taxable_amount",
                    "value": "0.00000000000000",
                    "value_string": "0.00 SAR",
                    "title": "المبلغ الخاضع للضريبة"
                },
                {
                    "code": "vat",
                    "value": "0.00000000000000",
                    "value_string": "0.00 SAR",
                    "title": "ضريبة القيمة المضافة (15%)"
                },
                {
                    "code": "sub_totals_after_vat",
                    "value": "899.10000000000000",
                    "value_string": "899.10 SAR",
                    "title": "مجموع المنتجات شامل ضريبة القيمة المضافة"
                },
                {
                    "code": "shipping",
                    "value": "3625.00000000000000",
                    "value_string": "3,625.00 SAR",
                    "title": "التوصيل"
                },
                {
                    "code": "shipping_discount",
                    "value": "-3625.00000000000000",
                    "value_string": "-3,625.00 SAR",
                    "title": "خصم التوصيل"
                },
                {
                    "code": "total",
                    "value": "899.10000000000000",
                    "value_string": "899.10 SAR",
                    "title": "المجموع الكلي"
                }
            ]
        },
        "cod_confirmed": false,
        "reverse_order_label_request": null,
        "customer_note": "This is a demo order for the purpose of testing the system. Please cancel this order.",
        "gift_message": null,
        "payment_link": null,
        "consignee": {
            "name": "Ibrahim",
            "email": "a.alkallas@zid.sa",
            "mobile": "966500000005"
        },
        "weight": 100000,
        "weight_cost_details": [],
        "currency": {
            "order_currency": {
                "id": 4,
                "code": "SAR",
                "exchange_rate": 1
            },
            "order_store_currency": {
                "id": 4,
                "code": "SAR",
                "exchange_rate": null
            }
        },
        "coupon": null,
        "products": [
            {
                "id": "f91a678a76f44c5689b48db40ad049e9",
                "parent_id": null,
                "parent_name": null,
                "product_class": null,
                "name": "نسخة من نسخة من نسخة من منتج ( تصنيف خاصية المخزون ١ ) ( بدون خيارات وإضافات ) ( مخزن واحد ) ",
                "sku": "Z.224947.16847733775598743",
                "custom_fields": [],
                "quantity": 1,
                "weight": {
                    "value": 100,
                    "unit": "kg"
                },
                "is_taxable": false,
                "is_discounted": false,
                "vouchers": null,
                "meta": null,
                "net_price_with_additions": 999,
                "net_price_with_additions_string": "999.00 SAR",
                "price_with_additions": 999,
                "price_with_additions_string": "999.00 SAR",
                "net_price": 1000,
                "net_price_string": "1,000.00 SAR",
                "net_sale_price": "999.00000000000000",
                "net_sale_price_string": "999.00 SAR",
                "net_additions_price": 0,
                "net_additions_price_string": null,
                "gross_price": 0,
                "gross_price_string": "0.00 SAR",
                "gross_sale_price": "0.00000000000000",
                "gross_sale_price_string": "0.00 SAR",
                "price_before": 1000,
                "price_before_string": "1,000.00 SAR",
                "total_before": 1000,
                "total_before_string": "1,000.00 SAR",
                "gross_additions_price": 0,
                "gross_additions_price_string": null,
                "tax_percentage": 0,
                "tax_amount": "0.00000000000000",
                "tax_amount_string": "0.00 SAR",
                "tax_amount_string_per_item": "0.00 SAR",
                "price": 999,
                "price_string": "999.00 SAR",
                "additions_price": 0,
                "additions_price_string": "0.00 SAR",
                "total": 999,
                "total_string": "999.00 SAR",
                "images": [
                    {
                        "id": "683d5771-f9b6-4082-bd0d-2fd39d2a4ab8",
                        "origin": "https://media.zid.store/thumbs/b2df7841-8071-401e-8883-77c9cb7cd9a1/a2457639-b852-4a57-85e7-56eaed681e38-thumbnail-500x500.png",
                        "thumbs": {
                            "fullSize": "https://media.zid.store/b2df7841-8071-401e-8883-77c9cb7cd9a1/a2457639-b852-4a57-85e7-56eaed681e38.png",
                            "thumbnail": "https://media.zid.store/thumbs/b2df7841-8071-401e-8883-77c9cb7cd9a1/a2457639-b852-4a57-85e7-56eaed681e38-thumbnail-370x370.png",
                            "small": "https://media.zid.store/thumbs/b2df7841-8071-401e-8883-77c9cb7cd9a1/a2457639-b852-4a57-85e7-56eaed681e38-thumbnail-500x500.png",
                            "medium": "https://media.zid.store/thumbs/b2df7841-8071-401e-8883-77c9cb7cd9a1/a2457639-b852-4a57-85e7-56eaed681e38-thumbnail-770x770.png",
                            "large": "https://media.zid.store/thumbs/b2df7841-8071-401e-8883-77c9cb7cd9a1/a2457639-b852-4a57-85e7-56eaed681e38-thumbnail-1000x1000.png"
                        }
                    }
                ],
                "options": []
            }
        ],
        "products_count": 1,
        "products_sum_total_string": "999.00 SAR",
        "language": "en",
        "histories": [
            {
                "order_status_id": 5,
                "order_status_name": "تم التوصيل",
                "changed_by_id": 182939,
                "changed_by_type": "تاجر",
                "changed_by_details": {
                    "action": "تم تعديل الطلب .",
                    "by": "SafwanQr store",
                    "comment": ""
                },
                "comment": "تم تعديل الطلب .",
                "created_at": "2023-09-25 10:51:43",
                "humanized_created_at": "منذ يوم"
            },
            {
                "order_status_id": 5,
                "order_status_name": "تم التوصيل",
                "changed_by_id": 182939,
                "changed_by_type": "تاجر",
                "changed_by_details": {
                    "action": "تم ارسال فاتورة الطلب",
                    "by": "SafwanQr store",
                    "comment": ""
                },
                "comment": "تم ارسال فاتورة الطلب",
                "created_at": "2023-09-25 10:51:43",
                "humanized_created_at": "منذ يوم"
            },
            {
                "order_status_id": 5,
                "order_status_name": "تم التوصيل",
                "changed_by_id": 182939,
                "changed_by_type": "تاجر",
                "changed_by_details": {
                    "action": "تم تغيير حالة الطلب إلى \"تم التوصيل\"",
                    "by": "SafwanQr store",
                    "comment": "تغيير جماعي لحالة الطلب ."
                },
                "comment": "تم تغيير حالة الطلب إلى \"تم التوصيل\"",
                "created_at": "2023-09-25 10:49:30",
                "humanized_created_at": "منذ يوم"
            },
            {
                "order_status_id": 1,
                "order_status_name": "جديد",
                "changed_by_id": 182939,
                "changed_by_type": "تاجر",
                "changed_by_details": {
                    "action": "تأكيد دفع الحواله البنكية",
                    "by": "SafwanQr store",
                    "comment": ""
                },
                "comment": "تأكيد دفع الحواله البنكية",
                "created_at": "2023-09-14 10:26:11",
                "humanized_created_at": "منذ أسبوع"
            },
            {
                "order_status_id": 1,
                "order_status_name": "جديد",
                "changed_by_id": 182939,
                "changed_by_type": "تاجر",
                "changed_by_details": {
                    "action": "تم تعديل الطلب .",
                    "by": "SafwanQr store",
                    "comment": ""
                },
                "comment": "تم تعديل الطلب .",
                "created_at": "2023-09-14 10:26:11",
                "humanized_created_at": "منذ أسبوع"
            },
            {
                "order_status_id": 1,
                "order_status_name": "جديد",
                "changed_by_id": 182939,
                "changed_by_type": "تاجر",
                "changed_by_details": {
                    "action": "تم ارسال فاتورة الطلب",
                    "by": "SafwanQr store",
                    "comment": ""
                },
                "comment": "تم ارسال فاتورة الطلب",
                "created_at": "2023-09-14 10:26:11",
                "humanized_created_at": "منذ أسبوع"
            },
            {
                "order_status_id": 1,
                "order_status_name": "جديد",
                "changed_by_id": 179647,
                "changed_by_type": "عميل",
                "changed_by_details": {
                    "action": "تم إنشاء الطلب .",
                    "by": "zid-test",
                    "comment": ""
                },
                "comment": "Order has been created.",
                "created_at": "2023-09-14 08:33:06",
                "humanized_created_at": "منذ أسبوع"
            }
        ],
        "is_reactivated": false,
        "return_policy": null,
        "packages_count": 1,
        "inventory_address": null,
        "reseller_meta": null
    });*/
      orderModel = OrderModel.fromJson(response.data['payload']);
      orderModel?.products?.forEach((element) {
        getProductReviews(element.parentId ?? element.id, element.id);
      });
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
    isLoading = false;
    update();
  }

  Future<void> getProductReviews(String? productId, String? id) async {
    isReviewsLoading = true;
    update([id ?? '']);
    try {
      var response = await _apiRequests.getCustomerProductReviews(productId);
      //log(response.data.toString());
      var payload = response.data['payload'] as List;
      if (payload.isNotEmpty) {
        orderModel?.products?.singleWhere((element) {
          if (element.parentId != null) {
            return element.parentId == productId;
          }
          return element.id == productId;
        }).reviews = Reviews.fromJson(response.data['payload'][0]);
      }
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
    isReviewsLoading = false;
    update([id ?? '']);
  }

  void addProductReviews(String? productId) async {
    if (productId == null) {
      return;
    }
    if (rating == null || rating == 0) {
      showMessage("يجب ادخال تقييم أولاً".tr, 2);
      return;
    }
    isAddReviewLoading = true;
    update(['addReview']);
    try {
      var response = await _apiRequests.addProductReviews(
          productId: productId,
          comment: commentController.text,
          rating: rating,
          isAnonymous: isAnonymous ? 1 : 0);
      await getProductReviews(productId, productId);
      Get.back();
      showMessage("تم اضافة مراجعتك بنجاح".tr, 1);
    } catch (e, stacktrace) {
      ErrorHandler.handleError(e, stacktrace: stacktrace);
    }
    isAddReviewLoading = false;
    update(['addReview']);
  }

  void changeAnonymous(bool? val) {
    isAnonymous = val!;
    update(['addReview']);
  }

  void onRatingUpdate(double value) {
    rating = value;
    update(['addReview']);
  }

  goToMain() {
    Get.back();
    // mainLogic.changeSelectedValue(3, false, backCount: 0);
    //  Get.offAll(const MainPage(), binding: Binding());
  }

  void openAddReviewDialog(String? productId) {
    commentController.text = '';
    rating = null;
    isAnonymous = false;
    Get.bottomSheet(AddReviewDialog(productId));
  }

  trackShipping() {
    Get.to(Scaffold(
      appBar: AppBar(
        title: CustomText(
          'تتبع الطلب'.tr,
          fontSize: 16,
        ),
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..loadRequest(
            Uri.parse(orderModel?.shipping?.method?.tracking?.url ?? ''),
          ),
      ),
    ));
  }
}
