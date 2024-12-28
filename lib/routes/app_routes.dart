import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/screens/add_brand/add_brand.dart';
import 'package:payvidence/screens/add_product_success/add_product_success.dart';
import 'package:payvidence/screens/all_invoices/all_invoices.dart';
import 'package:payvidence/screens/all_receipts/all_receipts.dart';
import 'package:payvidence/screens/brands/brands.dart';
import 'package:payvidence/screens/business_data/business_data.dart';
import 'package:payvidence/screens/business_detail/business_detail.dart';
import 'package:payvidence/screens/change_password/change_password.dart';
import 'package:payvidence/screens/change_profile_picture/change_profile_picture.dart';
import 'package:payvidence/screens/client_details/client_details.dart';
import 'package:payvidence/screens/empty_product/empty_product.dart';
import 'package:payvidence/screens/generate_receipt/generate_receipt.dart';
import 'package:payvidence/screens/my_subscription/my_subscription.dart';
import 'package:payvidence/screens/notification_settings/notification_settings.dart';
import 'package:payvidence/screens/notifications/notifications.dart';
import 'package:payvidence/screens/payvidence_info/payvidence_info.dart';
import 'package:payvidence/screens/privacy_and_security/privacy_and_security.dart';
import 'package:payvidence/screens/receipt/receipt.dart';
import 'package:payvidence/screens/reset_password/reset_password.dart';
import 'package:payvidence/screens/select_client/select_client.dart';
import 'package:payvidence/screens/update_personal_details/update_personal_details.dart';
import 'package:payvidence/screens/update_quantity/update_quantity.dart';
import '../screens/account_success/account_success.dart';
import '../screens/add_business/add_business.dart';
import '../screens/add_business_success/add_business_success.dart';
import '../screens/add_category/add_category.dart';
import '../screens/add_product/add_product.dart';
import '../screens/all_businesses/all_businesses.dart';
import '../screens/change_password_success/change_password_success.dart';
import '../screens/clients/clients.dart';
import '../screens/complete_draft/complete_draft.dart';
import '../screens/create_account/create_account.dart';
import '../screens/create_new_password/create_new_password.dart';
import '../screens/drafts/drafts.dart';
import '../screens/empty_business/empty_business.dart';
import '../screens/empty_category/empty_category.dart';
import '../screens/forgot_password/forgot_password.dart';
import '../screens/generate_invoices/generate_invoices.dart';
import '../screens/login/login.dart';
import '../screens/nav_screens/home.dart';
import '../screens/nav_screens/home_page.dart';
import '../screens/onboarding/onboarding.dart';
import '../screens/otp/otp.dart';
import '../screens/otp_login/otp_login.dart';
import '../screens/product_details/product_details.dart';
import '../screens/settings/settings.dart';
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
static const String generateReceipt = '/generateReceipt';
static const String selectClient = '/selectClient';
static const String generateInvoices = '/generateInvoices';
static const String allInvoices = '/allInvoices';
static const String updatePersonalDetails = '/updatePersonalDetails';
static const String businessData = '/businessData';
static const String payvidenceInfo = '/payvidenceInfo';
static const String changeProfilePicture = '/changeProfilePicture';
static const String notifications = '/notifications';
static const String settings = '/settings';
static const String mySubscription = '/mySubscription';
static const String changePassword = '/changePassword';
static const String privacyAndSecurity = '/privacyAndSecurity';
static const String resetPassword = '/resetPassword';
static const String notificationSettings = '/notificationSettings';
static const String updateQuantity = '/updateQuantity';
static const String businessDetail = '/businessDetail';
static const String clients = '/clients';
static const String clientDetails = '/clientDetails';


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

        GoRoute(
            path: generateReceipt, builder: (context, state) => GenerateReceipt()),
        GoRoute(
            path: selectClient, builder: (context, state) => SelectClient()),
        GoRoute(
            path: generateInvoices, builder: (context, state) => GenerateInvoices()),
        GoRoute(
            path: allInvoices, builder: (context, state) => AllInvoices()),
        GoRoute(
            path: updatePersonalDetails, builder: (context, state) => UpdatePersonalDetails()),
        GoRoute(
            path: businessData, builder: (context, state) => BusinessData()),
        GoRoute(
            path: payvidenceInfo, builder: (context, state) => PayvidenceInfo()),
        GoRoute(
            path: changeProfilePicture, builder: (context, state) => ChangeProfilePicture()),
        GoRoute(
            path: notifications, builder: (context, state) => Notifications()),
        GoRoute(
            path: settings, builder: (context, state) => Settings()),
        GoRoute(
            path: mySubscription, builder: (context, state) => MySubscription()),
        GoRoute(
            path: changePassword, builder: (context, state) => ChangePassword()),
        GoRoute(
            path: privacyAndSecurity, builder: (context, state) => PrivacyAndSecurity()),
        GoRoute(
            path: resetPassword, builder: (context, state) => ResetPassword()),
        GoRoute(
            path: notificationSettings, builder: (context, state) => NotificationSettings()),
        GoRoute(
            path: updateQuantity, builder: (context, state) => UpdateQuantity()),
        GoRoute(
            path: businessDetail, builder: (context, state) => BusinessDetail()),
        GoRoute(
            path: clients, builder: (context, state) => Clients()),
        GoRoute(
            path: clientDetails, builder: (context, state) => ClientDetails()),

      ],
    );
  }
}
