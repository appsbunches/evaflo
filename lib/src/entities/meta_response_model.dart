
import '../utils/functions.dart';

class MetaResponseModel {

  MetaResponseModel.fromJson(dynamic json) {
    bundleOffer = json['bundle_offer'] != null
        ? BundleOffer.fromJson(json['bundle_offer'])
        : null;
    /*
    pricesAfterDiscount = json['prices_after_discount'] != null
        ? PricesAfterDiscount.fromJson(json['prices_after_discount'])
        : null;*/
  }

  BundleOffer? bundleOffer;
  PricesAfterDiscount? pricesAfterDiscount;

}

class BundleOffer {
  BundleOffer({
    this.id,
    this.name,
    this.discountAmount,
    this.discountPercentage,
    this.priceAfterDiscount,
    this.priceAfterDiscountString,
  });

  BundleOffer.fromJson(dynamic json) {
    if (json == null) return;
    id = json['id'];
    name = json['name'];
    discountAmount = checkDouble(json['discount_amount']);
    discountPercentage = checkDouble(json['discount_percentage']);
    priceAfterDiscount = checkDouble(json['price_after_discount']);
    priceAfterDiscountString = json['price_after_discount_string'];
  }

  String? id;
  String? name;
  double? discountAmount;
  double? discountPercentage;
  double? priceAfterDiscount;
  String? priceAfterDiscountString;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['discount_amount'] = discountAmount;
    map['discount_percentage'] = discountPercentage;
    map['price_after_discount'] = priceAfterDiscount;
    map['price_after_discount_string'] = priceAfterDiscountString;
    return map;
  }
}

class PricesAfterDiscount {
  int? netPrice;
  Null? netSalePrice;
  String? netAdditionsPrice;
  int? taxAmount;
  int? grossPrice;
  Null? grossSalePrice;
  String? grossAdditionsPrice;
  int? price;
  String? additionsPrice;
  int? total;

  PricesAfterDiscount.fromJson(Map<String, dynamic> json) {
    netPrice = json['net_price'];
    netSalePrice = json['net_sale_price'];
    netAdditionsPrice = json['net_additions_price'];
    taxAmount = json['tax_amount'];
    grossPrice = json['gross_price'];
    grossSalePrice = json['gross_sale_price'];
    grossAdditionsPrice = json['gross_additions_price'];
    price = json['price'];
    additionsPrice = json['additions_price'];
    total = json['total'];
  }

}
