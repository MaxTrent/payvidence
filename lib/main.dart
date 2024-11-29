import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/router.dart';
import 'package:payvidence/screens/account_success/account_success.dart';
import 'package:payvidence/screens/create_account/create_account.dart';
import 'package:payvidence/screens/onboarding/onboarding.dart';
import 'package:payvidence/screens/otp/otp.dart';

import 'constants/app_theme.dart';

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((ref) {
  return GlobalKey<NavigatorState>();
});

Future<void> main() async{

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  try{
    // await setupLocator();
    runApp(ProviderScope(child: MyApp(appTheme: AppTheme(),)));
  }
  catch(e){(e);}


}

class MyApp extends StatelessWidget {
  final AppTheme appTheme;
  MyApp({super.key, required this.appTheme});

  final GoRouter _router = GoRouter(
    initialLocation: '/onboarding',
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Page Not Found'),),
    ),
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: '/createAccount',
        builder: (context, state) => CreateAccountScreen(),
      ),
      GoRoute(path: '/otp',
      builder: (context, state)=> OtpScreen()),
      GoRoute(path: '/accountSuccess',
      builder: (context, state)=> AccountSuccessScreen())
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      // splitScreenMode: true,
      builder: (_, child) => MaterialApp.router(
        title: 'Payvidence',
        debugShowCheckedModeBanner: false,
        theme: appTheme.light,
          routerConfig: _router,
      ),
    );
  }
}
