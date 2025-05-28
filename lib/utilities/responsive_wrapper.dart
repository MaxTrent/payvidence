import 'package:flutter/material.dart';
import 'package:payvidence/utilities/responsive.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = Responsive.getWidth(context);
        final screenHeight = Responsive.getHeight(context);
        return ResponsiveInherited(
          data: ResponsiveData(
            screenWidth: screenWidth,
            screenHeight: screenHeight,
            paddingHorizontal: Responsive.paddingHorizontal(context),
            spacingVertical: Responsive.spacingVertical(context),
            dotSize: Responsive.dotSize(context),
            radius: Responsive.radius(context),
            largeRadius: Responsive.largeRadius(context),
            smallRadius: Responsive.smallRadius(context),
            minButtonWidth: Responsive.minButtonWidth(context),
            minButtonHeight: Responsive.minButtonHeight(context),
            scaleHeight: (value) => Responsive.scaleHeight(context, value),
            scaleWidth: (value) => Responsive.scaleWidth(context, value),
          ),
          child: child,
        );
      },
    );
  }
}

class ResponsiveInherited extends InheritedWidget {
  final ResponsiveData data;

  const ResponsiveInherited({required this.data, required super.child});

  static ResponsiveData of(BuildContext context) {
    final widget = context.dependOnInheritedWidgetOfExactType<ResponsiveInherited>();
    if (widget == null) {
      throw FlutterError(
        'ResponsiveInherited.of() called with a context that does not contain a ResponsiveInherited widget.\n'
            'This usually happens because you used a `BuildContext` that is an ancestor of the ResponsiveWrapper widget.\n'
            'To fix, ensure that ResponsiveWrapper is an ancestor of the widget that calls ResponsiveInherited.of().\n'
            'For example, wrap your MaterialApp or root widget with ResponsiveWrapper:\n'
            '```dart\n'
            'ResponsiveWrapper(child: MaterialApp(...))\n'
            '```',
      );
    }
    return widget.data;
  }

  @override
  bool updateShouldNotify(ResponsiveInherited oldWidget) => data != oldWidget.data;
}

class ResponsiveData {
  final double screenWidth;
  final double screenHeight;
  final double paddingHorizontal;
  final double spacingVertical;
  final double dotSize;
  final double radius;
  final double largeRadius;
  final double smallRadius;
  final double minButtonWidth;
  final double minButtonHeight;
  final double Function(double) scaleHeight;
  final double Function(double) scaleWidth;

  ResponsiveData({
    required this.screenWidth,
    required this.screenHeight,
    required this.paddingHorizontal,
    required this.spacingVertical,
    required this.dotSize,
    required this.radius,
    required this.largeRadius,
    required this.smallRadius,
    required this.minButtonWidth,
    required this.minButtonHeight,
    required this.scaleHeight,
    required this.scaleWidth,
  });

  /// Returns a scaled vertical space based on the provided value.
  double verticalSpace(double value) {
    return scaleHeight(value); // Uses scaleHeight for consistent scaling
  }
}