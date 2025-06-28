import 'package:flutter/cupertino.dart';

import '../constants/app_colors.dart';
import '../utilities/haptic_service.dart';

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
      onChanged: (value) {
        HapticService.selectionClick();
        onChanged?.call(value);
      },
      activeTrackColor: primaryColor2,
      thumbColor: appGrey,
      inactiveTrackColor: borderColor,
    );
  }
}