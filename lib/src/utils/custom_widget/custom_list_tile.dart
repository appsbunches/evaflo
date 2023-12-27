import 'package:flutter/material.dart';
import '../../colors.dart';
import 'custom_text.dart';

class CustomListTile extends StatelessWidget {
  final String? title;
  final String? image;
  final GestureTapCallback? onTap;

  const CustomListTile(this.title, this.onTap, this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: [
            if (image != null)
              image == 'map'
                  ? const Icon(Icons.location_on)
                  : Image.asset(
                      image!,
                      color: accountIconColor,
                      scale: 2,
                    ),
            if (image != null)
              const SizedBox(
                width: 10,
              ),
            Expanded(
                child: CustomText(
              title?.trim(),
              maxLines: 2,
              fontWeight: FontWeight.bold,
            )),
            const Icon(
              Icons.arrow_forward_ios,
              color: accountIconColor,
              size: 20,
            )
          ],
        ),
      ),
    );
  }
}
