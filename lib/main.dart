import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/router.dart';
import 'package:payvidence/screens/account_success/account_success.dart';
import 'package:payvidence/screens/change_password_success/change_password_success.dart';
import 'package:payvidence/screens/create_account/create_account.dart';
import 'package:payvidence/screens/create_new_password/create_new_password.dart';
import 'package:payvidence/screens/forgot_password/forgot_password.dart';
import 'package:payvidence/screens/login/login.dart';
import 'package:payvidence/screens/nav_screens/home_page.dart';
import 'package:payvidence/screens/onboarding/onboarding.dart';
import 'package:payvidence/screens/otp/otp.dart';
import 'package:payvidence/screens/otp_login/otp_login.dart';

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
      GoRoute(path: '/login',
      builder: (context, state)=> Login()),
      GoRoute(
        path: '/createAccount',
        builder: (context, state) => CreateAccountScreen(),
      ),
      GoRoute(
        path: '/forgotPassword',
        builder: (context, state) => ForgotPassword(),
      ),
      GoRoute(
        path: '/createNewPassword',
        builder: (context, state) => CreateNewPassword(),
      ),
GoRoute(
  path: '/home',
  builder: (context, state) => HomePage(),
),
      GoRoute(
        path: '/changePasswordSuccess',
        builder: (context, state) => ChangePasswordSuccess(),
      ),
      GoRoute(path: '/otpLogin',
      builder: (context, state)=> OtpLogin()),
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
