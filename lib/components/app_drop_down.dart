import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../utilities/responsive_wrapper.dart';

class AppDropdown<T> extends StatelessWidget {
  final String hintText;
  final List<T> items;
  final T? value;
  final String Function(T) displayText;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final double? borderRadius;
  final EdgeInsets? contentPadding;
  final Color? lightModeBackgroundColor;
  final Color? darkModeBackgroundColor;

  const AppDropdown({
    super.key,
    required this.hintText,
    required this.items,
    required this.value,
    required this.displayText,
    required this.onChanged,
    this.validator,
    this.borderRadius,
    this.contentPadding,
    this.lightModeBackgroundColor,
    this.darkModeBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final responsiveData = ResponsiveInherited.of(context);
    final effectiveBorderRadius = borderRadius != null
        ? responsiveData.scaleHeight(borderRadius!)
        : responsiveData.smallRadius;

    return DropdownButtonFormField2<T>(
      hint: Text(
        hintText,
        textAlign: TextAlign.start,
        style: Theme.of(context).textTheme.displaySmall!.copyWith(
          color: isDarkMode ? Colors.white54 : hintTextColor,
        ),
      ),
      decoration: InputDecoration(
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              horizontal: responsiveData.scaleWidth(12),
              vertical: responsiveData.scaleHeight(16),
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white54 : Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white54 : Colors.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white54 : Colors.grey,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      value: value,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            displayText(item),
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      dropdownStyleData: DropdownStyleData(
        padding: EdgeInsets.symmetric(
          vertical: responsiveData.scaleHeight(8), // Replaces 8.h
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          color: isDarkMode
              ? (darkModeBackgroundColor ?? Colors.black)
              : (lightModeBackgroundColor ?? Colors.grey.shade100),
        ),
        offset: const Offset(0, -5),
      ),
    );
  }
}