//import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:entaj/src/app_config.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';

import '../.env.dart';
import '../entities/order_model.dart';
import '../utils/functions.dart';

class AppEvents extends GetxController {
  final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics.instance;
  //final _facebookAppEvents = FacebookAppEvents();

  Future<void> logScreenOpenEvent(String screenName) async {
    await _firebaseAnalytics.setCurrentScreen(screenName: screenName);
   // await _facebookAppEvents.setAutoLogAppEventsEnabled(true);
  }

  Future<void> logAddToCart(String? name, String? id, double? price) async {
    await _firebaseAnalytics.logAddToCart(
        items: [AnalyticsEventItem(itemName: name, price: price, itemId: id)]);
 //   await _facebookAppEvents.logAddToCart(id: id ?? '', type: 'product', currency: 'SAR', price: price ?? 0);
  }
  Future<void> logAddToWishlist(String? name, String? id, double? price) async {
    await _firebaseAnalytics.logAddToWishlist(
        items: [AnalyticsEventItem(itemName: name, price: price, itemId: id)]);
 //   await _facebookAppEvents.logAddToWishlist(id: id ?? '', type: 'product', currency: 'SAR', price: price ?? 0);
  }

  Future<void> logOpenProduct(
      {String? name, String? productId, String? price}) async {
    await _firebaseAnalytics.logEvent(name: 'view_product', parameters: {
      'product_id': productId,
      'product_name': name,
      'product_price': price,
    });
  //  await _facebookAppEvents.logEvent(name: 'view_product', parameters: {
  //    'product_id': productId,
  //    'product_name': name,
  //    'product_price': price,
   // });
  }

  Future<void> logSearchEvent(String searchTerm) async {
    await _firebaseAnalytics.logSearch(searchTerm: searchTerm);
  }

  Future<void> logCheckout(
      {String? coupon, List<AnalyticsEventItem>? items, double? value}) async {
    await _firebaseAnalytics.logBeginCheckout(
        value: value, currency: 'SAR', coupon: coupon, items: items);
   // await _facebookAppEvents.logInitiatedCheckout(
   //   totalPrice: value,
   //   currency: 'SAR',
   //   numItems: items?.length,
   // );
  }

  Future<void> logPurchase(OrderModel? orderModel) async {
    await _firebaseAnalytics.logPurchase(
        currency: orderModel?.currencyCode ?? AppConfig.defaultCurrencyCode ?? 'SAR',
        value: checkDouble(orderModel?.orderTotal),
        items: orderModel?.products
            ?.map(
                (e) => AnalyticsEventItem(itemId: e.id, itemName: e.name, price: e.total))
            .toList());
/*
    if (remoteConfig.getBool('use_custom_purchase_event')) {
      _facebookAppEvents.logEvent(name: 'Purchase', parameters: {
        'content_ids': orderModel?.products?.map((e) => e.id).toList(),
        'value': checkDouble(orderModel?.orderTotal),
        'currency': orderModel?.currencyCode ?? currency,
        'content_type': 'product',
      }).then((value) => log('success'));
    } else {
      _facebookAppEvents
          .logPurchase(
              currency: orderModel?.currencyCode ?? currency,
              amount: checkDouble(orderModel?.orderTotal),
              parameters: orderModel?.products?.asMap().map((key, value) {
                return MapEntry('id', value.id);
              }))
          .then((value) => log('success'));
    }
*/
  }
}
