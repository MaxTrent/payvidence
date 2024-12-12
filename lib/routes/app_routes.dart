
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/complete_draft/complete_draft.dart';
import 'package:payvidence/screens/add_brand/add_brand.dart';
import 'package:payvidence/screens/add_product_success/add_product_success.dart';
import 'package:payvidence/screens/all_receipts/all_receipts.dart';
import 'package:payvidence/screens/brands/brands.dart';
import 'package:payvidence/screens/empty_product/empty_product.dart';
import 'package:payvidence/screens/receipt/receipt.dart';

import '../screens/account_success/account_success.dart';
import '../screens/add_business/add_business.dart';
import '../screens/add_business_success/add_business_success.dart';
import '../screens/add_category/add_category.dart';
import '../screens/add_product/add_product.dart';
import '../screens/all_businesses/all_businesses.dart';
import '../screens/change_password_success/change_password_success.dart';
import '../screens/create_account/create_account.dart';
import '../screens/create_new_password/create_new_password.dart';
import '../screens/drafts/drafts.dart';
import '../screens/empty_business/empty_business.dart';
import '../screens/empty_category/empty_category.dart';
import '../screens/forgot_password/forgot_password.dart';
import '../screens/login/login.dart';
import '../screens/nav_screens/home.dart';
import '../screens/nav_screens/home_page.dart';
import '../screens/onboarding/onboarding.dart';
import '../screens/otp/otp.dart';
import '../screens/otp_login/otp_login.dart';
import '../screens/product_details/product_details.dart';
import '../screens/upgrade_subscription/upgrade_subscription.dart';

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
  static const String addProduct = '/addProduct';
  static const String emptyCategory = '/emptyCategory';
  static const String addCategory = '/addCategory';
static const String brands = '/brands';
static const String addBrand = '/addBrands';
static const String productSuccess = '/productSuccess';
static const String emptyProduct = '/emptyProduct';
static const String productDetails = '/productDetails';
static const String allReceipts = '/allReceipts';
static const String drafts = '/drafts';
static const String completeDraft = '/completeDraft';
static const String receipt = '/receipt';


  static GoRouter createRouter() {
    return GoRouter(
      initialLocation: onboarding,
      errorBuilder: (context, state) => const Scaffold(
        body: Center(child: Text('Page Not Found')),
      ),
      routes: [
        GoRoute(
          path: onboarding,
          builder: (context, state) => OnboardingScreen(),
        ),
        GoRoute(
          path: login,
          builder: (context, state) => Login(),
        ),
        GoRoute(
          path: createAccount,
          builder: (context, state) => CreateAccountScreen(),
        ),
        GoRoute(
          path: forgotPassword,
          builder: (context, state) => ForgotPassword(),
        ),
        GoRoute(
          path: createNewPassword,
          builder: (context, state) => CreateNewPassword(),
        ),
        GoRoute(
          path: emptyBusiness,
          builder: (context, state) => EmptyBusiness(),
        ),
        GoRoute(
          path: homeScreen,
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: addBusiness,
          builder: (context, state) => AddBusiness(),
        ),
        GoRoute(
          path: home,
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          path: changePasswordSuccess,
          builder: (context, state) => ChangePasswordSuccess(),
        ),
        GoRoute(
          path: otpLogin,
          builder: (context, state) => OtpLogin(),
        ),
        GoRoute(
          path: otp,
          builder: (context, state) => OtpScreen(),
        ),
        GoRoute(
          path: accountSuccess,
          builder: (context, state) => AccountSuccessScreen(),
        ),
        GoRoute(
          path: addBusinessSuccess,
          builder: (context, state) => AddBusinessSuccess(),
        ),
        GoRoute(
          path: allBusiness,
          builder: (context, state) => AllBusinesses(),
        ),
        GoRoute(
          path: upgradeSubscription,
          builder: (context, state) => UpgradeSubscription(),
        ),
        GoRoute(
          path: addProduct,
          builder: (context, state) => AddProduct(),
        ),
        GoRoute(path: addCategory,
        builder: (context, state)=> AddCategory()),
        GoRoute(
            path: emptyCategory, builder: (context, state) => EmptyCategory()),
        GoRoute(
            path: brands, builder: (context, state) => Brands()),
        GoRoute(
            path: addBrand, builder: (context, state) => AddBrand()),
        GoRoute(
            path: productSuccess, builder: (context, state) => AddProductSuccess()),

        GoRoute(
            path: emptyProduct, builder: (context, state) => EmptyProduct()),

        GoRoute(
            path: productDetails, builder: (context, state) => ProductDetails()),

        GoRoute(
            path: allReceipts, builder: (context, state) => AllReceipts()),
        GoRoute(
            path: drafts, builder: (context, state) => Drafts()),
        GoRoute(
            path: completeDraft, builder: (context, state) => CompleteDraft()),
        GoRoute(
            path: receipt, builder: (context, state) => Receipt()),

      ],
    );
  }
}
