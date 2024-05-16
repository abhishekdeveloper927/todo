import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputField2 extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double? marginRight;
  final double? marginBottom;
  final double? width;
  final double? height;
  final double? radius;
  final Color? color;
  final Color? backgroundColor;
  final int? maxLine;

  const InputField2(
      {Key? key,
      required this.title,
      required this.controller,
      this.suffixIcon,
      this.focusNode,
      this.nextFocus,
      this.keyboardType,
      this.marginRight,
      this.marginBottom,
      this.width,
      this.color,
      this.maxLine,
      this.radius,
      this.height,
      this.prefixIcon,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.only(right: marginRight ?? 0, bottom: marginBottom ?? 0),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      width: width ?? Get.width / 4,
      height: height ?? 50,
      decoration: BoxDecoration(
          color: backgroundColor ?? Get.theme.cardColor,
          borderRadius: BorderRadius.circular(radius ?? 12)),
      child: TextFormField(
        maxLines: maxLine,
        controller: controller,
        onFieldSubmitted: (_) {},
        style: const TextStyle(fontSize: 14, color: Colors.black),
        decoration: InputDecoration(
            prefixIcon: prefixIcon,
            border: InputBorder.none,
            suffixIcon: suffixIcon,
            hintText: title,
            hintStyle: TextStyle(fontSize: 14, color: color ?? Colors.black26)),
      ),
    );
  }
}
