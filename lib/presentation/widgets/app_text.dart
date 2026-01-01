import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.color,
    this.decorationColor,
    this.size = 14,
    this.align,
    this.maxLines,
    this.family,
    this.weight,
    this.style,
    this.height,
    this.onTap,
    this.overflow,
    this.letterSpacing,
    this.isShowUnderline = false,
  });

  const AppText.click(
    this.text, {
    super.key,
    this.color,
    this.decorationColor,
    this.size = 14,
    this.align,
    this.maxLines,
    this.family,
    this.weight,
    this.style,
    this.height,
    required this.onTap,
    this.overflow,
    this.letterSpacing,
    this.isShowUnderline = false,
  });

  final dynamic text;
  final String? family;
  final Color? color, decorationColor;
  final double? size;
  final TextAlign? align;
  final int? maxLines;
  final FontWeight? weight;
  final TextStyle? style;
  final double? height;
  final void Function()? onTap;
  final TextOverflow? overflow;
  final bool isShowUnderline;
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) => onTap != null
      ? InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: buildText(context),
          ),
        )
      : buildText(context);

  Text buildText(BuildContext context) {
    return Text(
      '${text ?? ''}',
      maxLines: maxLines,
      overflow: overflow,
      textScaler: MediaQuery.of(context).textScaler,
      softWrap: true,

      style:
          style ??
          TextStyle(
            fontSize: size,
            color: color,
            letterSpacing: letterSpacing,
            fontWeight: weight,
            fontFamily: family,
            height: height,
            decorationColor: decorationColor,
            decoration: isShowUnderline ? TextDecoration.underline : null,
          ),
      textAlign: align,
    );
  }
}
