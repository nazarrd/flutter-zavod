import 'package:flutter/material.dart';

class ButtonDefault extends StatelessWidget {
  const ButtonDefault(
    this.title, {
    super.key,
    this.onTap,
    this.color,
    this.textColor = Colors.white,
    this.margin = EdgeInsets.zero,
    this.height,
    this.width,
    this.fontSize = 14,
    this.radius = 1000,
    this.padding = const EdgeInsets.fromLTRB(16, 8, 16, 8),
    this.isLoading = false,
  });

  final String title;
  final Color? color;
  final Color textColor;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final void Function()? onTap;
  final double? height;
  final double? width;
  final double fontSize;
  final double radius;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: isLoading ? null : onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Container(
            height: height,
            width: width,
            margin: margin,
            alignment: Alignment.center,
            padding: isLoading ? null : padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: onTap != null
                  ? (color ?? Colors.blue.shade400)
                  : Colors.grey.shade300,
              border: color != Colors.transparent
                  ? null
                  : Border.all(color: Colors.blue),
            ),
            child: isLoading
                ? Center(
                    child: Transform.scale(
                      scale: 0.6,
                      child:
                          const CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                : Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
