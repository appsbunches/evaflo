
import '../../entities/home_screen_model.dart';
import '../custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemTestimonial extends StatelessWidget {
  final Items? item;

  const ItemTestimonial({Key? key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300.w,
          margin: const EdgeInsetsDirectional.only(start: 15),
          padding: EdgeInsets.all(15.sp),
          decoration:
              BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.sp)),
          child: SizedBox(
            height: ((item?.text ?? item?.reviews)?.length ?? 0) > 299 ? 150.h : null,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    item?.author ?? item?.customerName ?? item?.name,
                    fontSize: 11,
                    maxLines: 1,
                    fontWeight: FontWeight.bold,
                  ),
                  CustomText(
                    item?.date,
                    fontSize: 8,
                    color: Colors.grey.shade800,
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomText(
                    (item?.text ?? item?.reviews ?? item?.content ?? item?.customerReview)
                        ?.replaceAll('\n', '')
                        .replaceAll('\t', '')
                        .replaceAll('\r', ''),
                    textAlign: TextAlign.start,
                    fontSize: 10,
                  )
                ],
              ),
            ),
          ),
        ),
        // const Spacer(),
      ],
    );
  }
}
