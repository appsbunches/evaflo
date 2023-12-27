import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final bool maxHeight;
  const CustomProgressIndicator({Key? key,  this.maxHeight = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: const [
        LinearProgressIndicator(),
      ],
    );
  }
}
