// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? fontWeight;
  final int? maxLine;

  final Color? color;
  CustomText({
    Key? key,
    required this.text,
    this.size = 18,
    this.fontWeight = FontWeight.normal,
    this.maxLine = 1,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Text(overflow: TextOverflow.ellipsis,
      maxLines: maxLine,
      text,
      style: TextStyle(fontSize: size, fontWeight: fontWeight, color: color),
    );
  }
}
