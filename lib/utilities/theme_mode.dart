import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../data/local/session_constants.dart';
import '../data/local/session_manager.dart';
import '../shared_dependency/shared_dependency.dart';

final _themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

({ThemeMode mode, void Function() toggle}) useThemeMode() {
  final themeMode = useListenable(_themeModeNotifier);
  final isMounted = useIsMounted();

  useEffect(() {
    Future<void> loadTheme() async {
      final savedTheme = locator<SessionManager>().get<String>(SessionConstants.themeMode);

      if (isMounted()) {
        _themeModeNotifier.value =
        savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
      }
    }

    loadTheme();
    return null;
  }, []);

  void toggleTheme() async {
    final newMode = _themeModeNotifier.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    if (isMounted()) {
      _themeModeNotifier.value = newMode;
    }
    await locator<SessionManager>().save<String>(key: SessionConstants.themeMode, value: newMode == ThemeMode.dark ? 'dark' : 'light');

   }

  return (mode: themeMode.value, toggle: toggleTheme);
}