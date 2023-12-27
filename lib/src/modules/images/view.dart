import 'package:cached_network_image/cached_network_image.dart';
import 'package:entaj/src/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:loop_page_view/loop_page_view.dart';
import 'package:photo_view/photo_view.dart';

import '../../entities/product_details_model.dart';
import '../../images.dart';
import '../../utils/custom_widget/custom_indicator.dart';
import '../../utils/item_widget/global_foalting_whatsapp_widget.dart';
import 'logic.dart';

class ImagesPage extends StatefulWidget {
  final List<Images> images;
  int selectedImageIndex;

  ImagesPage(this.images, this.selectedImageIndex, {Key? key}) : super(key: key);

  @override
  State<ImagesPage> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  final ImagesLogic logic = Get.put(ImagesLogic());
  late LoopPageController pageController;

  @override
  void initState() {
    pageController = LoopPageController(initialPage: widget.selectedImageIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () => Get.back(),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  child: Icon(Icons.close)),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(bottom: 30.h),
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.sp),
                ),
                child: LoopPageView.builder(
                  onPageChanged: (page) {
                    widget.selectedImageIndex = page;
                    setState(() {});
                  },
                  itemCount: widget.images.length,
                  itemBuilder: (context, index) {
                    return PhotoView(
                        backgroundDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.sp),
                            color: Colors.white),
                        errorBuilder: (a, b, c) => Image.asset(
                              iconLogo,
                              color: Colors.white,
                              scale: 3,
                            ),
                        imageProvider: CachedNetworkImageProvider(
                          widget.images[index].image?.fullSize ?? '',
                        ));
                  },
                  controller: pageController,
                  physics: const ClampingScrollPhysics(),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: buildPageIndicator(),
              ),
            ),
            /*GetBuilder<ImagesLogic>(builder: (logic) {
              return Center(
                  child: CustomText(
                "${widget.selectedImageIndex + 1}/${widget.images.length}",
              ));
            })*/
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton:
          AppConfig.showGBAllApp ? const GlobalFloatingWhatsApp() : null,
    );
  }

  bool loopStarted = false;

  List<Widget> buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < widget.images.length; i++) {
      list.add(i == widget.selectedImageIndex
          ? const CustomIndicator(true)
          : const CustomIndicator(false));
    }
    return list;
  }
}
