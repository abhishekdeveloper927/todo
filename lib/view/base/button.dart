import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/dimensions.dart';

class Button extends StatelessWidget {
  final String title;
  final Function onTap;
  final double? width;
  final double? height;
  final Color? color;
  final double? radius;
  final double? padding;
  final double? fontSize;

  const Button(
      {super.key,
      required this.title,
      required this.onTap,
      this.width,
      this.radius,
      this.padding,
      this.fontSize,
      this.color,
      this.height});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        width: width ?? Get.width,
        height: height ?? 50,
        padding: EdgeInsets.all(padding ?? Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
            color: color ?? Get.theme.primaryColor,
            borderRadius:
                BorderRadius.circular(radius ?? Dimensions.paddingSizeDefault)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fontSize ?? Dimensions.fontSizeDefault),
          ),
        ),
      ),
    );
  }
}
