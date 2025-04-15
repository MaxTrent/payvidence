import 'package:flutter/cupertino.dart';

import '../constants/app_colors.dart';

class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.onChanged,
    required this.isSwitchEnabled,
  });

  final bool isSwitchEnabled;
  final Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: isSwitchEnabled,
      onChanged: onChanged,
      activeTrackColor: primaryColor2,
      thumbColor: appGrey,
      inactiveTrackColor: borderColor,
    );
  }
}