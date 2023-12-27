import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:entaj/src/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../colors.dart';
import '../../entities/bank_response_model.dart';
import '../../images.dart';
import '../../utils/custom_widget/custom_button_widget.dart';
import '../../utils/custom_widget/custom_image.dart';
import '../../utils/custom_widget/custom_progress_Indicator.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/functions.dart';
import '../../utils/item_widget/global_foalting_whatsapp_widget.dart';
import '../../utils/validation/validation.dart';
import '../order_details/view.dart';
import 'logic.dart';

class UploadTransferPage extends GetView<UploadTransferLogic> {
  final String? total;
  final String? code;
  final bool fromSuccessOrder;

  const UploadTransferPage(
      {required this.code,
      required this.fromSuccessOrder,
      required this.total,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: showFab && AppConfig.showGBAllApp
          ? Obx(() {
              return Container(
                  margin: !controller.isVisible.value
                      ? EdgeInsets.only(bottom: 50.h)
                      : null,
                  child: GlobalFloatingWhatsApp());
            })
          : null,
      appBar: AppBar(
          title: Image.asset(
        iconLogo,
        height: 40,
      )),
      body: GetBuilder<UploadTransferLogic>(
          init: Get.put(UploadTransferLogic()),
          builder: (logic) {
            return SingleChildScrollView(
              controller: logic.scrollController,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      "البنوك المتاحة للتحويل".tr,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    logic.isBanksLoading
                        ? const CustomProgressIndicator()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: logic.banksList.length,
                            itemBuilder: (context, index) => Container(
                                  padding: const EdgeInsets.all(15),
                                  margin: const EdgeInsets.only(bottom: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  logic.banksList[index].bank
                                                      ?.name,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                CustomText(
                                                  "اسم المحول له: ".tr +
                                                      (logic.banksList[index]
                                                              .beneficiaryName ??
                                                          ''),
                                                  fontSize: 11,
                                                ),
                                              ],
                                            ),
                                          ),
                                          CustomImage(
                                            url: logic.banksList[index].bank
                                                    ?.logo ??
                                                '',
                                            height: 30,
                                            size: 20,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            CustomText(
                                              "رقم الحساب".tr,
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                                child: CustomText(
                                              logic.banksList[index]
                                                  .accountNumber,
                                              fontSize: 10,
                                            )),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  Clipboard.setData(ClipboardData(
                                                      text: logic
                                                              .banksList[index]
                                                              .accountNumber ??
                                                          ''));
                                                  showMessage('Copied', 1);
                                                },
                                                child: const Icon(
                                                    Icons.copy_outlined)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            CustomText(
                                              "رقم الايبان".tr,
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Expanded(
                                                child: CustomText(
                                              logic.banksList[index].iban,
                                              fontSize: 10,
                                            )),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: logic
                                                                  .banksList[
                                                                      index]
                                                                  .iban ??
                                                              ''));
                                                  showMessage('Copied', 1);
                                                },
                                                child: const Icon(
                                                    Icons.copy_outlined)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(15),
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                          color: blueLightColor,
                          borderRadius: BorderRadius.circular(15.sp)),
                      child: Column(
                        children: [
                          CustomText(
                            "إجمالي الطلب".tr,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          CustomText(
                            total,
                            textAlign: TextAlign.center,
                            fontSize: 14,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomButtonWidget(
                            title: "لعرض تفاصيل الطلب اضغط هنا".tr,
                            onClick: () => Get.to(OrderDetailsPage(
                              code ?? '',
                              fromSuccessOrder: fromSuccessOrder,
                            )),
                            width: 250.w,
                            textSize: 12,
                            textColor: Colors.black,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomText(
                      "تأكيد البنك المحول له".tr,
                      fontSize: 14,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    logic.isBanksLoading
                        ? const Center(child: CircularProgressIndicator())
                        : DropdownButtonHideUnderline(
                            child: DropdownButton2(
                              iconStyleData: const IconStyleData(
                                iconSize: 0,
                              ),
                              isExpanded: true,
                              dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                      color: dropdownColor,
                                      borderRadius:
                                          BorderRadius.circular(15.sp))),
                              hint: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(15.sp)),
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.store_rounded,
                                      color: primaryColor,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    CustomText(
                                      "اختر البنك المحول له".tr,
                                      color: primaryColor,
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: primaryColor,
                                    )
                                  ],
                                ),
                              ),
                              onChanged: (newValue) {
                                logic.setSelected(newValue);
                              },
                              value: logic.selected,
                              items: logic.banksList
                                  .map((BankResponseModel selectedType) {
                                return DropdownMenuItem(
                                  child: Container(
                                      height: 50.h,
                                      decoration: BoxDecoration(
                                          color: dropdownColor,
                                          borderRadius:
                                              BorderRadius.circular(15.sp)),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: CustomText(
                                              '${selectedType.bank?.name} - ${selectedType.accountNumber}',
                                              fontSize: 11,
                                              color: dropdownTextColorNew,
                                            ),
                                          ),
                                        ],
                                      )),
                                  value: selectedType,
                                );
                              }).toList(),
                            ),
                          ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: logic.nameController,
                      validator: Validation.nameValidate,
                      style: const TextStyle(
                          color: primaryColor, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(
                              borderRadius: BorderRadius.circular(15.sp),
                              borderSide: BorderSide.none),
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          labelStyle: const TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.normal),
                          labelText: "اسم صاحب الحساب البنكي المحول منه".tr),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.sp),
                        color: Colors.grey.shade100,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => logic.pickPhoto(isPhoto: false),
                              child: TextFormField(
                                enabled: false,
                                controller: TextEditingController(
                                    text: logic.image?.name),
                                validator: Validation.nameValidate,
                                style: const TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold),
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.sp),
                                        borderSide: BorderSide.none),
                                    fillColor: Colors.grey.shade100,
                                    filled: false,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    labelStyle: const TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.normal),
                                    labelText: "تحميل صورة الحوالة".tr),
                              ),
                            ),
                          ),
                          GestureDetector(
                              onTap: () => logic.pickPhoto(isPhoto: true),
                              child: const Padding(
                                padding: EdgeInsets.all(16),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: primaryColor,
                                ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    CustomButtonWidget(
                        title: "تأكيد التحويل".tr,
                        color: secondaryColor,
                        loading: logic.isLoading,
                        onClick: () => logic.uploadTransfer(code)),
                    SizedBox(
                      height: 40.h,
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
