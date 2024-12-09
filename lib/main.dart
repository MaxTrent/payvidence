import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/routes/app_routes.dart';

import 'constants/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  try {
    runApp(ProviderScope(child: MyApp(appTheme: AppTheme())));
  } catch (e) {
    print(e);
  }
}

class MyApp extends StatefulWidget {
  final AppTheme appTheme;

  const MyApp({super.key, required this.appTheme});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final router;

  @override
  void initState() {
    super.initState();
    router = AppRoutes.createRouter();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (_, child) => MaterialApp.router(
        title: 'Payvidence',
        debugShowCheckedModeBanner: false,
        theme: widget.appTheme.light,
        routerConfig: router,
      ),
    );
  }
}