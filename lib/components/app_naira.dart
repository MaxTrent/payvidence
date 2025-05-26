import 'package:flutter/material.dart';
import 'package:payvidence/utilities/responsive.dart';

class AppNaira extends StatelessWidget {
  const AppNaira({
    super.key,
    required this.fontSize,
    this.color = Colors.black,
  });

  final int fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      '\u20A6',
      style: TextStyle(
        fontSize: Responsive.fontSize(context, fontSize.toDouble()),
        fontFamily: 'Roboto',
        color: color,
      ),
    );
  }
}