import 'app_config.dart';
import 'package:flutter/material.dart';

/// Logo
const splashLogoColor = null;
const iconLogoFullColor = null;
const headerLogoColor = null;
const authHeaderLogoColor = null;
const accountIconLogoFullColor = null;
const errorLogoColor = null;

/// Main - Header
const headerBackgroundColor = Color(0xff495e48);
const headerForegroundColor = Color(0xffffffff);

/// Main - Bottom Navigation
const bottomBackgroundColor = Colors.white;
const bottomSelectedIconColor = primaryColor;
const bottomUnselectedIconColor = Color(0xff9FA4B2);

/// Authentication
const authButtonColor = primaryColor;
const authTextButtonColor = Colors.white;
const authBackgroundColor = Color(0xffeeeeee);
const authForegroundAppbarColor = Colors.black;
const authBackgroundAppbarColor = Colors.white;

/// Categories
const categoryBackgroundColor = Colors.white;
const categoryTextColor = Colors.black;
const categoryHomeBackgroundColor = Colors.white;
const categoryHomeTextColor = Colors.black;
const categoryProductDetailsBackgroundColor = Color(0xffD8F2E2);
const categoryProductDetailsTextColor = Color(0xff233668);
Color? categoryDetailsBackgroundColor = Colors.grey.shade50;

///Cart
Color? cartBackgroundColor = Colors.white;
const deliveryOptionIconColor = null;

/// Icons
const socialMediaIconColor = primaryColor;
const logoutIconColor = Colors.black;
const filterIconColor = Colors.black;
const accountIconColor = Colors.black;
const deliveryIconColor = null;
const deleteIconColor = null;
const discountIconColor = Colors.black;

/// DropDown
const dropdownColor = Colors.grey;
const dropdownTextColorNew = Colors.black;
final dropdownDividerLineColor = Colors.grey.shade700;

/// Buttons
//Login
const buttonBackgroundLoginColor = primaryColor;
const buttonTextLoginColor = Colors.white;
//Checkout
const buttonBackgroundCheckoutColor = primaryColor;
const buttonTextCheckoutColor = Colors.white;
//Coupon
const buttonBackgroundCouponColor = primaryColor;
const buttonTextCouponColor = Colors.white;
//Call
const buttonBackgroundCallColor = primaryColor;
const buttonTextCallColor = Colors.white;
//add to cart
const progressColor = AppConfig.showButtonWithBorder ? primaryColor : Colors.white;
const addToCartColor = !AppConfig.showButtonWithBorder ? primaryColor : Colors.white;
const textAddToCartColor = AppConfig.showButtonWithBorder ? primaryColor : Colors.white;
const iconAddToCartColor = AppConfig.showButtonWithBorder ? primaryColor : Colors.white;

///Prices
const formattedSalePriceTextColor = Colors.black;
const formattedPriceTextColorWithSale = moveColor;
const formattedPriceTextColorWithoutSale = Colors.black;

/// Home
//Features
const featuresBackgroundColor = Colors.white;
const featuresForegroundColor = Colors.white;
//PromotionImage
const backgroundButtonPromotionColor = '#00b286';
const backgroundDescriptionColor = '#dddddd';
//Description
const foregroundDescriptionColor = '#000000';

///Other colors
Color filterBackgroundColor = Colors.grey.shade100;
const errorBackgroundColor = Color(0xFF616161);
const discountBackgroundColor = yalowColor;
const discountTextColor = Colors.black;
const successMessageColor = Colors.green;
final highlightColor = Colors.grey.shade300;
const accountHeaderBackgroundColor = primaryColor;

///Main colors
const primaryColor = Color(0xff495e48);
const moveColor = Color.fromRGBO(234, 68, 60, 1.0);
const yalowColor = Color.fromRGBO(255, 215, 80, 1.0);
const secondaryColor = primaryColor;
const greenLightColor = primaryColor;
final baseColor = Colors.grey.shade100;
const textColor = null;
const blueLightColor = Color.fromRGBO(179, 211, 218, 1.0);
Color homeBackgroundColor = Colors.grey.shade50;

Map<int, Color> mapColor = {
  50: primaryColor.withOpacity(0.1),
  100: primaryColor.withOpacity(0.2),
  200: primaryColor.withOpacity(0.3),
  300: primaryColor.withOpacity(0.4),
  400: primaryColor.withOpacity(0.5),
  500: primaryColor.withOpacity(0.6),
  600: primaryColor.withOpacity(0.7),
  700: primaryColor.withOpacity(0.8),
  800: primaryColor.withOpacity(0.9),
  900: primaryColor,
};

MaterialColor mainColor = MaterialColor(primaryColor.value, mapColor);

extension HexColor on Color {
  static Color fromHex(String hexString) {
    if (hexString.length < 6) return Colors.black;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
