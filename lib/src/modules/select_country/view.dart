import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app_config.dart';
import '../../colors.dart';
import '../../entities/country_model.dart';
import '../../utils/custom_widget/custom_button_widget.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/item_widget/global_foalting_whatsapp_widget.dart';
import '../_main/logic.dart';
import 'logic.dart';

class SelectCountryPage extends StatelessWidget {
  final SelectCountryLogic logic = Get.put(SelectCountryLogic());

  SelectCountryPage({Key? key}) : super(key: key);
  MainLogic mainLogic = Get.find();

  @override
  Widget build(BuildContext context) {
    mainLogic.tempSelectedCountryModel = mainLogic.selectedCountryModel;
    mainLogic.tempSelectedCityModel = mainLogic.selectedCityModel;
    mainLogic.tempSelectedCurrencyModel = mainLogic.selectedCurrencyModel;
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: AppConfig.showGBAllApp ? GlobalFloatingWhatsApp() : null,
      appBar: AppBar(
        title: CustomText(
          "الشحن إلى".tr,
          fontSize: 16,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: GetBuilder<MainLogic>(
            init: Get.find<MainLogic>(),
            id: 'SelectCityDialog',
            builder: (logic) {
              if (!AppConfig.multiInventoryVersion) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "اختر الدولة".tr,
                      color: primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      "حدد وجهة التسوق الخاصة بك".tr,
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount:
                                logic.settingModel?.settings?.currencies?.length ?? 0,
                            itemBuilder: (context, index) {
                              var item = logic.settingModel?.settings?.currencies?[index];
                              return GestureDetector(
                                  onTap: () => logic.onChangeCurrency(item, true),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color:
                                          logic.tempSelectedCurrencyModel?.id == item?.id
                                              ? primaryColor.withOpacity(0.2)
                                              : CupertinoColors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: CustomText(item?.name,
                                        fontSize: 14,
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ));
                            })),
                    CustomButtonWidget(
                      title: 'حفظ'.tr,
                      onClick: () => logic.saveCountry(),
                      loading: logic.isSaveCountryLoading,
                      color: greenLightColor,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    if (AppConfig.multiInventoryVersion) ...[
                      CustomText(
                        'الدولة'.tr,
                        fontSize: 14,
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
                                        thumbVisibility:
                                            MaterialStateProperty.all<bool>(true),
                                        trackVisibility: MaterialStateProperty.all(true),
                                        thickness: MaterialStateProperty.all<double>(0))),
                                isExpanded: true,
                                onChanged: (CountryModel? val) =>
                                    logic.onChangeCountry(val, true),
                                value: logic.tempSelectedCountryModel,
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
                        fontSize: 14,
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
                                      trackVisibility: MaterialStateProperty.all(true),
                                    )),
                                isExpanded: true,
                                onChanged: (CountryModel? val) =>
                                    logic.onChangeCity(val, true),
                                value: logic.tempSelectedCityModel,
                                items: logic.tempSelectedCountryModel?.cities
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
                        height: 24,
                      ),
                      Divider(
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ],
                    CustomText(
                      'العملة'.tr,
                      fontSize: 14,
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
                                    trackVisibility: MaterialStateProperty.all(true),
                                  )),
                              isExpanded: true,
                              onChanged: (CountryModel? val) =>
                                  logic.onChangeCurrency(val, false),
                              value: logic.selectedCurrencyModel,
                              items: logic.settingModel?.settings?.currencies
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
                      height: 32,
                    ),
                    Spacer(),
                    CustomButtonWidget(
                      title: 'حفظ'.tr,
                      onClick: () => logic.saveCountry(),
                      loading: logic.isSaveCountryLoading,
                      color: greenLightColor,
                    ),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                );
              }
            }),
      ),
    );
  }
}
