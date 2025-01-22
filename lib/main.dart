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

final appRoutes = AppRoutes();

class MyApp extends ConsumerWidget {
  final AppTheme appTheme;

  const MyApp({super.key, required this.appTheme});

  @override
  Widget build(BuildContext context, ref) {
    final goRouter = ref.watch(appRoutes.goRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (_, child) => MaterialApp.router(
        title: 'Payvidence',
        debugShowCheckedModeBanner: false,
        theme: appTheme.light,
        routerConfig: goRouter,
      ),
    );
  }
}
