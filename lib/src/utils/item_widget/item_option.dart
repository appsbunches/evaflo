import 'package:dropdown_button2/dropdown_button2.dart';
import '../../entities/product_details_model.dart';
import '../../modules/product_details/logic.dart';
import '../custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../colors.dart';

class ItemOption extends StatelessWidget {
  final Options? option;
  final List<String>? choices;

  const ItemOption(this.choices, this.option, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
                child: CustomText(
              option?.name,
              overflow: TextOverflow.ellipsis,
            )),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.sp),
              border: Border.all(color: secondaryColor, width: 2)),
          child: Row(
            children: [
              Expanded(
                child: GetBuilder<ProductDetailsLogic>(
                    id: option?.name ?? '',
                    builder: (logic) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          iconStyleData: const IconStyleData(
                            iconSize: 0,
                          ),
                          dropdownStyleData: DropdownStyleData(
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: dropdownColor,
                                borderRadius: BorderRadius.circular(20.sp),
                              ),
                              scrollbarTheme: ScrollbarThemeData(
                                  thumbVisibility: MaterialStateProperty.all<bool>(true),
                                  trackVisibility: MaterialStateProperty.all(true),
                                  thickness: MaterialStateProperty.all<double>(0))),
                          menuItemStyleData: const MenuItemStyleData(
                            padding: EdgeInsets.zero,
                          ),
                          isExpanded: true,
                          selectedItemBuilder: (con) {
                            return choices?.map((selectedType) {
                                  return Container(
                                      height: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: CustomText(
                                              selectedType,
                                              fontSize: 12,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ));
                                }).toList() ??
                                [];
                          },
                          onChanged: (String? val) =>
                              logic.onChangeOption(val, option, withUpdate: true),
                          value: logic.mapOptions[option?.name],
                          items: choices?.map((selectedType) {
                            return DropdownMenuItem(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: CustomText(
                                      selectedType,
                                      textAlign: TextAlign.center,
                                      fontSize: 10,
                                      color: dropdownTextColorNew,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (selectedType !=
                                      choices?[((choices?.length) ?? 0) - 1])
                                    Container(
                                      height: 1,
                                      color: dropdownDividerLineColor,
                                    )
                                ],
                              ),
                              value: selectedType,
                            );
                          }).toList(),
                        ),
                      );
                    }),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
        )
      ],
    );
  }
}
