import 'package:cached_network_image/cached_network_image.dart';
import '../../app_config.dart';
import '../../colors.dart';
import '../../images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomImage extends StatelessWidget {
  final String? url;
  final double? height;
  final double? width;
  final double size;
  final BoxFit? fit;
  final bool showErrorImage;
  final bool loading;
  final Color? color;

  const CustomImage(
      {Key? key,
      required this.url,
      this.height,
      this.width,
      this.color,
      this.size = 65,
      this.loading = true,
      this.showErrorImage = true,
      this.fit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url?.contains('svg') == true) {
      if (url?.contains('tabby2') == true) {
        return Image.asset(iconTabby2);
      }
      if (url?.contains('tamara2') == true) {
        return Image.asset(iconTamara2);
      }
      if (url?.contains('apple_pay') == true) {
        return Image.asset(iconApplePay);
      }
      if (url?.contains('http') == true) {
        return SvgPicture.network(url ?? '',
            height: height,
            width: width,
            allowDrawingOutsideViewBox: true,
            color: color,
            fit: fit ?? BoxFit.contain,
            placeholderBuilder: (BuildContext context) => showErrorImage
                ? Image.asset(
                    iconLogoFull,
                    color: errorLogoColor,
                    width: size.sp,
                    height: size.sp,
                  )
                : const SizedBox());
      }
      return SvgPicture.asset(url ?? '',
          height: height ?? 20,
          width: width,
          fit: fit ?? BoxFit.contain,
          color: color,
          placeholderBuilder: (BuildContext context) => showErrorImage
              ? Image.asset(
                  iconLogoFull,
                  color: errorLogoColor,
                  width: size.sp,
                  height: size.sp,
                )
              : const SizedBox());
    }
    return CachedNetworkImage(
      height: height,
      width: width,
      fit: fit ?? BoxFit.contain,
      imageUrl: url ?? '',
      alignment: Alignment.topCenter,
      placeholder: (context, url) => loading
          ? SizedBox(
              width: 25,
              height: 25,
              child: AppConfig.showLoadingInImage
                  ? const Center(
                      child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ))
                  : Image.asset(
                      iconLogoFull,
                      color: errorLogoColor,
                      width: size.sp,
                      height: size.sp,
                    ))
          : const SizedBox(),
      errorWidget: (context, url, error) => Padding(
        padding: EdgeInsets.all(size / 3),
        child: showErrorImage
            ? Image.asset(
                iconLogoFull,
                color: errorLogoColor,
                width: size.sp,
                height: size.sp,
              )
            : const SizedBox(),
      ),
    );
  }
}
