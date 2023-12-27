import '../../../app_config.dart';
import '../../../images.dart';
import '../../../utils/custom_widget/custom_button_widget.dart';
import '../../../utils/custom_widget/custom_text.dart';
import '../../../utils/functions.dart';
import '../../../utils/validation/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../colors.dart';
import '../login/logic.dart';
import 'logic.dart';

class RegisterPage extends StatelessWidget {
  final RegisterLogic logic = Get.put(RegisterLogic());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bool isEmail;

  RegisterPage({Key? key, required this.isEmail}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logic.setData(isEmail);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: authForegroundAppbarColor,
        backgroundColor: authBackgroundAppbarColor,
        title: CustomText(
          "سجل دخولك".tr,
          fontSize: 16,
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 15),
            child: Image.asset(
              iconLogoAppBarEnd,
              alignment: AlignmentDirectional.centerEnd,
              height: AppConfig.logoSizeInApBarHeight,
              width: AppConfig.logoSizeInApBarWidth,
              color: authHeaderLogoColor,
            ),
          ),
        ],
      ),
      body: GetBuilder<RegisterLogic>(builder: (logic) {
        return Stack(
          children: [
            Container(
              color: authBackgroundColor,
            ),
            Positioned(
                left: -50.w,
                right: -50.w,
                top: -120.h,
                child: Image.asset(
                  imageArt,
                  color: authBackgroundAppbarColor,
                  height: 220.h,
                )),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 120,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.sp),
                                  color: Colors.white.withOpacity(0.3)),
                              child: TextFormField(
                                controller: logic.nameController,
                                validator: Validation.nameValidate,
                                style: const TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                    labelText: "الاسم".tr),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.sp),
                                  color: Colors.white.withOpacity(0.3)),
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: logic.emailController,
                                style: const TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold),
                                validator: Validation.emailValidate,
                                keyboardType: TextInputType.emailAddress,
                                enabled: !isEmail,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    labelStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.normal),
                                    labelText: "البريد الإلكتروني".tr),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.sp),
                                  color: Colors.white.withOpacity(0.3)),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      textInputAction: TextInputAction.done,
                                      //maxLength: getMaxLength(logic.loginLogic.selectedCode ?? AppConfig.countriesCodes.first),

                                      controller: logic.phoneController,
                                      //validator:(val) => Validation.phoneValidate(val , ),
                                      enabled: isEmail,
                                      validator: (val) => Validation.phoneValidate(
                                          val,
                                          getMaxLength(logic.loginLogic.selectedCode ??
                                              AppConfig.countriesCodes.first)),
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          suffixIcon:
                                              GetBuilder<LoginLogic>(builder: (logic) {
                                            return DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                iconSize: 0,
                                                isExpanded: false,
                                                hint: buildIcon(
                                                    AppConfig.countriesCodes.first),
                                                onChanged: logic.changeCodeSelected,
                                                value: logic.selectedCode,
                                                items: AppConfig.countriesCodes
                                                    .map((selectedType) {
                                                  return DropdownMenuItem(
                                                    child: buildIcon(selectedType),
                                                    value: selectedType,
                                                  );
                                                }).toList(),
                                              ),
                                            );
                                          }),
                                          contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          labelStyle: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal),
                                          labelText: "رقم الجوال".tr),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 100,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
                left: 15,
                right: 15,
                bottom: 20,
                child: CustomButtonWidget(
                  title: "طلب رمز التفعيل".tr,
                  loading: logic.isLoading,
                  color: authButtonColor,
                  textColor: authTextButtonColor,
                  onClick: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    FocusScope.of(context).unfocus();

                    logic.register();
                  },
                ))
          ],
        );
      }),
    );
  }

  Container buildIcon(String? text) {
    return Container(
      width: 80.w,
      height: 30.h,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(15.sp), color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 5,
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.black,
            size: 20,
          ),
          CustomText(
            text,
            fontSize: 10,
          ),
          const SizedBox(
            width: 5,
          )
        ],
      ),
    );
  }
}
