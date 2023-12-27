import '../../app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../main.dart';
import '../../colors.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final Function()? onTap;
  final FontWeight? fontWeight;
  final int? maxLines;
  final double? height;
  final bool? lineThrough;
  final TextOverflow? overflow;

  const CustomText(this.text,
      {Key? key,
      this.fontSize,
      this.color = textColor,
      this.textAlign = TextAlign.start,
      this.onTap,
      this.fontWeight,
      this.maxLines,
      this.lineThrough,
      this.overflow,
      this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double fs = ((fontSize == null ? 12 : fontSize!) + AppConfig.fontDecIncValue);
    return Text(
      text?.replaceAll('ً', '') ?? '',
      textAlign: textAlign,
      style: TextStyle(
          decoration: lineThrough != null ? TextDecoration.lineThrough : null,
          color: color,
          fontSize: isWeb ?fs :fs.sp,
          overflow: overflow,
          fontFamily: text?.contains('ssssss') == true ? '' : AppConfig.fontName,
          fontWeight: AppConfig.showTextAsNormal ? FontWeight.normal : fontWeight,
          height: height),
      maxLines: maxLines,
    );
  }
}
