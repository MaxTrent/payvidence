// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/app_provider_observer.dart';
import 'package:payvidence/utilities/scroll_behaviour.dart';
import 'package:payvidence/utilities/theme_mode.dart';
import 'package:payvidence/utilities/toast_service.dart';
import 'constants/app_theme.dart';
import 'env_config.dart';
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  await loadEnvFile();
  final baseUrl = dotenv.env['BASE_URL'] ?? '';
  if (baseUrl.isEmpty) {
    throw Exception("BASE_URL is missing or empty in .env file!");
  }

  try {
    await initializeSharedDependencies(baseUrl: baseUrl);
    runApp(ProviderScope(
      observers: [AppProviderObserver()],
      child: MyApp(
        appTheme: AppTheme(),
      ),
    ));
  } catch (e) {
    print('Initialization error: $e');
  }
}

class MyApp extends HookWidget {
  final AppTheme appTheme;

  const MyApp({super.key, required this.appTheme});

  @override
  Widget build(BuildContext context) {
    final theme = useThemeMode();
    final appRouter = locator<PayvidenceAppRouter>();
    // final firebaseMessaging = FirebaseMessaging.instance;
    //
    // firebaseMessaging.requestPermission(
    //   alert: true,
    //   badge: true,
    //   sound: true,
    // );


    // firebaseMessaging.getToken().then((token) {
    //   print('FCM Token: $token');
    // });

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (_, child) => MaterialApp.router(
        scaffoldMessengerKey: ToastService.scaffoldMessengerKey,
        scrollBehavior: AppScrollBehaviour(),
        title: 'Payvidence',
        debugShowCheckedModeBanner: false,
        theme: appTheme.light,
        darkTheme: appTheme.dark,
        themeMode: theme.mode,
        routerConfig: appRouter.config(),
      ),
    );
  }
}