import 'logic.dart';
import '../../utils/custom_widget/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../entities/shipping_method_model.dart';

class CitiesDialog extends StatefulWidget {
  List<City> citiesList;

  CitiesDialog({required this.citiesList, Key? key}) : super(key: key);

  @override
  State<CitiesDialog> createState() => _CitiesDialogState();
}

class _CitiesDialogState extends State<CitiesDialog> {
  List<City> newList = [];

  @override
  initState() {
    newList = widget.citiesList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600.h,
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
      child: GetBuilder<DeliveryOptionLogic>(
          init: Get.find<DeliveryOptionLogic>(),
          id: 'dialog',
          builder: (logic) {
            return Column(
              children: [
                TextField(
                  onChanged: (v) {
                    newList = [];
                    if (v.isEmpty) {
                      newList = widget.citiesList;
                      logic.update(['dialog']);
                      return;
                    }
                    for (var element in widget.citiesList) {
                      if (element.name?.toLowerCase().contains(v.toLowerCase()) == true) {
                        newList.add(element);
                      }
                    }
                    logic.update(['dialog']);
                  },
                  onSubmitted: (v) {
                    newList = [];
                    if (v.isEmpty) {
                      newList = widget.citiesList;
                      logic.update(['dialog']);
                      return;
                    }
                    for (var element in widget.citiesList) {
                      if (element.name?.toLowerCase().contains(v.toLowerCase()) == true) {
                        newList.add(element);
                      }
                    }
                    logic.update(['dialog']);
                  },
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: newList.length,
                      itemBuilder: (context, index) => Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(child: CustomText(newList[index].name))
                        ],
                      )),
                ),
              ],
            );
          }),
    );
  }
}
