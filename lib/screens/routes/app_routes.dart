import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/screens/all_businesses/all_businesses.dart';
import 'package:payvidence/screens/upgrade_subscription/upgrade_subscription.dart';

import '../account_success/account_success.dart';
import '../add_business/add_business.dart';
import '../add_business_success/add_business_success.dart';
import '../change_password_success/change_password_success.dart';
import '../create_account/create_account.dart';
import '../create_new_password/create_new_password.dart';
import '../empty_business/empty_business.dart';
import '../forgot_password/forgot_password.dart';
import '../login/login.dart';
import '../nav_screens/home.dart';
import '../nav_screens/home_page.dart';
import '../onboarding/onboarding.dart';
import '../otp/otp.dart';
import '../otp_login/otp_login.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String createAccount = '/createAccount';
  static const String forgotPassword = '/forgotPassword';
  static const String createNewPassword = '/createNewPassword';
  static const String emptyBusiness = '/emptyBusiness';
  static const String homeScreen = '/homescreen';
  static const String addBusiness = '/addBusiness';
  static const String home = '/home';
  static const String changePasswordSuccess = '/changePasswordSuccess';
  static const String otpLogin = '/otpLogin';
  static const String otp = '/otp';
  static const String accountSuccess = '/accountSuccess';
  static const String addBusinessSuccess = '/addBusinessSuccess';
  static const String allBusiness = '/allBusiness';
  static const String upgradeSubscription = '/upgradeSubscription';

  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: onboarding,
      errorBuilder: (context, state) => const Scaffold(
        body: Center(child: Text('Page Not Found')),
      ),
      routes: [
        GoRoute(
          path: onboarding,
          builder: (context, state) =>  OnboardingScreen(),
        ),
        GoRoute(
          path: login,
          builder: (context, state) =>  Login(),
        ),
        GoRoute(
          path: createAccount,
          builder: (context, state) =>  CreateAccountScreen(),
        ),
        GoRoute(
          path: forgotPassword,
          builder: (context, state) =>  ForgotPassword(),
        ),
        GoRoute(
          path: createNewPassword,
          builder: (context, state) =>  CreateNewPassword(),
        ),
        GoRoute(
          path: emptyBusiness,
          builder: (context, state) =>  EmptyBusiness(),
        ),
        GoRoute(
          path: homeScreen,
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: addBusiness,
          builder: (context, state) =>  AddBusiness(),
        ),
        GoRoute(
          path: home,
          builder: (context, state) =>  HomePage(),
        ),
        GoRoute(
          path: changePasswordSuccess,
          builder: (context, state) =>  ChangePasswordSuccess(),
        ),
        GoRoute(
          path: otpLogin,
          builder: (context, state) =>  OtpLogin(),
        ),
        GoRoute(
          path: otp,
          builder: (context, state) =>  OtpScreen(),
        ),
        GoRoute(
          path: accountSuccess,
          builder: (context, state) =>  AccountSuccessScreen(),
        ),
        GoRoute(
          path: addBusinessSuccess,
          builder: (context, state) =>  AddBusinessSuccess(),
        ),
        GoRoute(
          path: allBusiness,
          builder: (context, state) =>  AllBusinesses(),
        ),
        GoRoute(
          path: upgradeSubscription,
          builder: (context, state) =>  UpgradeSubscription(),
        ),
      ],
    );
  }
}