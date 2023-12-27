import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../app_config.dart';
import '../../colors.dart';
import '../../utils/custom_widget/custom_button_widget.dart';
import '../../utils/custom_widget/custom_text.dart';
import '../../utils/item_widget/global_foalting_whatsapp_widget.dart';
import '../../utils/validation/validation.dart';
import '../_main/tabs/account/logic.dart';

class EditAccountPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  EditAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: CustomText(
            "تعديل الحساب".tr,
            fontSize: 16,
          ),
        ),
        body: SingleChildScrollView(
          child: GetBuilder<AccountLogic>(
              init: Get.find<AccountLogic>(),
              builder: (logic) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  width: double.infinity,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.sp),
                              color: Colors.grey.shade100),
                          child: TextFormField(
                            controller: logic.nameController,
                            validator: Validation.nameValidate,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                labelStyle:
                                    TextStyle(color: Colors.grey.shade700),
                                labelText: "الاسم".tr),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.sp),
                              color: Colors.grey.shade100),
                          child: TextFormField(
                            controller: logic.emailController,
                            validator: Validation.emailValidate,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                labelStyle:
                                    TextStyle(color: Colors.grey.shade700),
                                labelText: "البريد الإلكتروني".tr),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.sp),
                              color: Colors.grey.shade100),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: logic.phoneController,
                                  //   validator: Validation.phoneValidate,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                      labelStyle: TextStyle(
                                          color: Colors.grey.shade700),
                                      labelText: "رقم الجوال".tr),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.sp),
                                    color: Colors.white),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(Icons.keyboard_arrow_down),
                                    CustomText("+${logic.startNumber}"),
                                    const SizedBox(
                                      width: 5,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        CustomButtonWidget(
                            title: "حفظ التغييرات".tr,
                            radius: 15,
                            loading: logic.isEditLoading,
                            onClick: () {
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              FocusScope.of(context).unfocus();

                              logic.editAccountDetails();
                            }),
                        SizedBox(
                          height: 120.h,
                        ),
                        CustomText(
                          'حذف الحساب'.tr,
                          fontSize: 16,
                        ),
                        const Divider(
                          color: Colors.grey,
                        ),
                        CustomButtonWidget(
                            title: "إحذف حسابي".tr,
                            radius: 15,
                            width: 180,
                            height: 35,
                            textSize: 12,
                            color: Colors.red,
                            loading: logic.isLoading,
                            onClick: () {
                              Get.defaultDialog(
                                  title: 'حذف الحساب'.tr,
                                  middleText: 'هل أنت متأكد من حذف حسابك؟'.tr,
                                  cancel: CustomButtonWidget(
                                      title: 'نعم'.tr,
                                      width: 100,
                                      onClick: () => logic.deleteAccount()),
                                  confirm: CustomButtonWidget(
                                      title: 'لا'.tr,
                                      widthBorder: true,
                                      color: Colors.white,
                                      textColor: primaryColor,
                                      width: 100,
                                      onClick: () => Get.back()));
                            }),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton:
            AppConfig.showGBAllApp ? GlobalFloatingWhatsApp() : null);
  }
}
