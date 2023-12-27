import 'package:entaj/src/app_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../colors.dart';
import '../../images.dart';
import '../../utils/custom_widget/custom_progress_Indicator.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/item_widget/global_foalting_whatsapp_widget.dart';
import 'cities_dialog.dart';
import 'logic.dart';

class DeliveryOptionPage extends StatelessWidget {
  final DeliveryOptionLogic logic = Get.find();

  DeliveryOptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logic.getShippingMethods(false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: CustomText(
          "خيارات الشحن".tr,
          fontSize: 16,
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: GetBuilder<DeliveryOptionLogic>(builder: (logic) {
          return RefreshIndicator(
            onRefresh: () async => logic.getShippingMethods(true),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: logic.loading
                        ? const CustomProgressIndicator()
                        : ListView.builder(
                            itemCount: logic.listShippingMethods.length,
                            padding: const EdgeInsets.only(top: 20),
                            itemBuilder: (BuildContext context, int index) =>
                                Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            iconCarDelivery,
                                            color: deliveryIconColor,
                                            scale: 2,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                "خيارات الشحن".tr,
                                                fontWeight: FontWeight.bold,
                                                color: secondaryColor,
                                                fontSize: 10,
                                              ),
                                              CustomText(
                                                logic.listShippingMethods[index]
                                                    .name,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            iconCities,
                                            color: deliveryIconColor,
                                            scale: 2,
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  "المدن التي يتم تغطيتها".tr,
                                                  fontWeight: FontWeight.bold,
                                                  color: secondaryColor,
                                                  fontSize: 10,
                                                ),
                                                GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          15),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          15))),
                                                          context: context,
                                                          builder:
                                                              (context) =>
                                                                  CitiesDialog(
                                                                    citiesList:
                                                                        logic.listShippingMethods[index].selectCities ??
                                                                            [],
                                                                  ));
                                                    },
                                                    child: RichText(
                                                      text: TextSpan(
                                                          children: logic
                                                              .getSelectedCities(logic
                                                                      .listShippingMethods[
                                                                          index]
                                                                      .selectCities ??
                                                                  [])),
                                                    ) /* CustomText(
                                                logic.getSelectedCities(logic
                                                    .listShippingMethods[index]
                                                    .selectCities ??
                                                    []),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),*/
                                                    ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              iconCoins,
                                              color: deliveryIconColor,
                                              scale: 2,
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            CustomText(
                                              "تكلفة الشحن".tr,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ],
                                        ),
                                      ),
                                      logic.listShippingMethods[index].cost
                                                  ?.length ==
                                              1
                                          ? CustomText(
                                              logic.listShippingMethods[index]
                                                  .cost?[0].costString,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            )
                                          : ListView.builder(
                                              itemCount: logic
                                                      .listShippingMethods[
                                                          index]
                                                      .cost
                                                      ?.length ??
                                                  0,
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              itemBuilder: (context, index1) {
                                                var item = logic
                                                    .listShippingMethods[index]
                                                    .cost?[index1];
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    CustomText(
                                                      item?.title ??
                                                          "تكلفة الشحن".tr,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: secondaryColor,
                                                      fontSize: 10,
                                                    ),
                                                    CustomText(
                                                      item?.costString,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                    const SizedBox()
                                                  ],
                                                );
                                              },
                                            ),
                                      if (logic.listShippingMethods[index]
                                                  .codEnabled ==
                                              true &&
                                          logic.listShippingMethods[index]
                                                  .codFee?.isNotEmpty ==
                                              true)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                iconCoins,
                                                color: deliveryIconColor,
                                                scale: 2,
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              CustomText(
                                                "الدفع عند الاستلام".tr,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (logic.listShippingMethods[index]
                                                  .codEnabled ==
                                              true &&
                                          logic.listShippingMethods[index]
                                                  .codFee?.isNotEmpty ==
                                              true)
                                        logic.listShippingMethods[index].codFee
                                                    ?.length ==
                                                1
                                            ? CustomText(
                                                logic.listShippingMethods[index]
                                                    .codFee?[0].codFeeString,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              )
                                            : ListView.builder(
                                                itemCount: logic
                                                        .listShippingMethods[
                                                            index]
                                                        .codFee
                                                        ?.length ??
                                                    0,
                                                shrinkWrap: true,
                                                padding: EdgeInsets.zero,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                itemBuilder: (context, index1) {
                                                  var item = logic
                                                      .listShippingMethods[
                                                          index]
                                                      .codFee?[index1];
                                                  return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      CustomText(
                                                        item?.title ??
                                                            "الدفع عند الاستلام"
                                                                .tr,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: secondaryColor,
                                                        fontSize: 10,
                                                      ),
                                                      CustomText(
                                                        item?.codFeeString,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                      ),
                                                      const SizedBox()
                                                    ],
                                                  );
                                                }),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  thickness: 3,
                                  color: Colors.grey.shade200,
                                )
                              ],
                            ),
                          ))
              ],
            ),
          );
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton:
          AppConfig.showGBAllApp ? GlobalFloatingWhatsApp() : null,
    );
  }
}
