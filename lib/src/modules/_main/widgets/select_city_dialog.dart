import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:entaj/src/entities/setting_model.dart';
import 'package:entaj/src/images.dart';
import 'package:entaj/src/modules/_main/logic.dart';
import 'package:entaj/src/utils/custom_widget/custom_button_widget.dart';
import 'package:entaj/src/utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../entities/country_model.dart';

class SelectCityDialog extends StatelessWidget {
  const SelectCityDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: GetBuilder<MainLogic>(
            id: 'SelectCityDialog',
            builder: (logic) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(iconDelivery),
                        CustomText(
                          'الشحن إلى'.tr,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomText(
                      'الدولة'.tr,
                      fontSize: 12,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xffBCBCBC), width: 2)),
                      child: Row(
                        children: [
                          Expanded(
                              child: DropdownButtonHideUnderline(
                            child: DropdownButton2<CountryModel>(
                              iconStyleData: const IconStyleData(
                                iconSize: 0,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.zero,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                  padding: EdgeInsets.zero,
                                  scrollbarTheme: ScrollbarThemeData(
                                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                                      trackVisibility: MaterialStateProperty.all(true),
                                      thickness: MaterialStateProperty.all<double>(0))),
                              isExpanded: true,
                              onChanged: (CountryModel? val) =>
                                  logic.onChangeCountry(val, false),
                              value: logic.selectedCountryModel,
                              items: logic.settingModel?.header?.destinations?.countries
                                  ?.map((selectedType) {
                                return DropdownMenuItem(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomText(
                                      selectedType.name,
                                      textAlign: TextAlign.center,
                                      fontSize: 10,
                                      color: const Color(0xff000000),
                                    ),
                                  ),
                                  value: selectedType,
                                );
                              }).toList(),
                            ),
                          )),
                          const Icon(
                            Icons.keyboard_arrow_down,
                          ),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomText(
                      'المدينة'.tr,
                      fontSize: 12,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xffBCBCBC), width: 2)),
                      child: Row(
                        children: [
                          Expanded(
                              child: DropdownButtonHideUnderline(
                            child: DropdownButton2<CountryModel>(
                              iconStyleData: const IconStyleData(
                                iconSize: 0,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                padding: EdgeInsets.zero,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                  padding: EdgeInsets.zero,
                                  scrollbarTheme: ScrollbarThemeData(
                                      thumbVisibility: MaterialStateProperty.all<bool>(true),
                                      trackVisibility: MaterialStateProperty.all(true),
                                      thickness: MaterialStateProperty.all<double>(0))),
                              isExpanded: true,
                              onChanged: (CountryModel? val) =>
                                  logic.onChangeCity(val, false),
                              value: logic.selectedCityModel,
                              items:
                                  logic.selectedCountryModel?.cities?.map((selectedType) {
                                return DropdownMenuItem(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CustomText(
                                      selectedType.name,
                                      textAlign: TextAlign.center,
                                      fontSize: 10,
                                      color: const Color(0xff000000),
                                    ),
                                  ),
                                  value: selectedType,
                                );
                              }).toList(),
                            ),
                          )),
                          const Icon(
                            Icons.keyboard_arrow_down,
                          ),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomButtonWidget(
                        title: 'حفظ'.tr,
                        height: 40,
                        radius: 12,
                        onClick: () {
                          logic.onChangeCountry(logic.selectedCountryModel, false);
                          logic.onChangeCity(logic.selectedCityModel, false);
                          Get.back();
                        })
                  ],
                ),
              );
            }));
  }
}
