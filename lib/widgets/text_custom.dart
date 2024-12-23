import 'package:flutter/material.dart';
import '../utils/colors.dart';


class TextCustom extends StatelessWidget {
  final String text;
  final double textSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final TextDecoration decoration;
  final FontStyle fontStyle;
  final int? maxLines;
  final TextOverflow overflow;
  final double letterSpacing;
  final double wordSpacing;

  TextCustom({
    Key? key,
    required this.text,
    this.textSize = 12,
    this.fontWeight = FontWeight.normal,
    this.color = lightBgColor,
    this.textAlign = TextAlign.start,
    this.decoration = TextDecoration.none,
    this.fontStyle = FontStyle.normal,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.letterSpacing = 0.0,
    this.wordSpacing = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: textSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}