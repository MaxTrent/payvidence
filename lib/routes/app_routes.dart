import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:payvidence/routes/app_routes.gr.dart';


// class AppRoutes {
//   static const String onboarding = '/onboarding';
//   static const String login = '/login';
//   static const String createAccount = '/createAccount';
//   static const String forgotPassword = '/forgotPassword';
//   static const String createNewPassword = '/createNewPassword';
//   static const String emptyBusiness = '/emptyBusiness';
//   static const String homeScreen = '/homescreen';
//   static const String addBusiness = '/addBusiness';
//   static const String home = '/home';
//   static const String changePasswordSuccess = '/changePasswordSuccess';
//   static const String otpLogin = '/otpLogin';
//   static const String otp = '/otp';
//   static const String accountSuccess = '/accountSuccess';
//   static const String addBusinessSuccess = '/addBusinessSuccess';
//   static const String allBusiness = '/allBusiness';
//   static const String upgradeSubscription = '/upgradeSubscription';
//   static const String addProduct = '/addProduct';
//   static const String emptyCategory = '/emptyCategory';
//   static const String addCategory = '/addCategory';
//   static const String brands = '/brands';
//   static const String addBrand = '/addBrands';
//   static const String productSuccess = '/productSuccess';
//   static const String emptyProduct = '/emptyProduct';
//   static const String productDetails = '/productDetails';
//   static const String allReceipts = '/allReceipts';
//   static const String drafts = '/drafts';
//   static const String completeDraft = '/completeDraft';
//   static const String receipt = '/receipt';
//   static const String generateReceipt = '/generateReceipt';
//   static const String selectClient = '/selectClient';
//   static const String generateInvoices = '/generateInvoices';
//   static const String allInvoices = '/allInvoices';
//   static const String updatePersonalDetails = '/updatePersonalDetails';
//   static const String businessData = '/businessData';
//   static const String payvidenceInfo = '/payvidenceInfo';
//   static const String changeProfilePicture = '/changeProfilePicture';
//   static const String notifications = '/notifications';
//   static const String settings = '/settings';
//   static const String mySubscription = '/mySubscription';
//   static const String changePassword = '/changePassword';
//   static const String privacyAndSecurity = '/privacyAndSecurity';
//   static const String resetPassword = '/resetPassword';
//   static const String notificationSettings = '/notificationSettings';
//   static const String updateQuantity = '/updateQuantity';
//   static const String businessDetail = '/businessDetail';
//   static const String clients = '/clients';
//   static const String clientDetails = '/clientDetails';
//   static const String addClient = '/addClient';
//   static const String clientSuccess = '/clientSuccess';
//
//
//
//   final goRouterProvider = Provider<GoRouter>((ref) {
//     return GoRouter(
//       initialLocation: onboarding,
//       errorBuilder: (context, state) => const Scaffold(
//         body: Center(child: Text('Page Not Found')),
//       ),
//       routes: [
//         GoRoute(
//           path: onboarding,
//           builder: (context, state) => OnboardingScreen(),
//         ),
//         // GoRoute(
//         //   path: login,
//         //   builder: (context, state) => Login(),
//         // ),
//         GoRoute(
//           path: createAccount,
//           builder: (context, state) => const CreateAccountScreen(),
//         ),
//         GoRoute(
//           path: forgotPassword,
//           builder: (context, state) => ForgotPassword(),
//         ),
//         GoRoute(
//           path: createNewPassword,
//           builder: (context, state) => CreateNewPassword(),
//         ),
//         GoRoute(
//           path: emptyBusiness,
//           builder: (context, state) => const EmptyBusiness(),
//         ),
//         GoRoute(
//           path: homeScreen,
//           builder: (context, state) => const HomeScreen(),
//         ),
//         GoRoute(
//           path: addBusiness,
//           builder: (context, state) => AddBusiness(),
//         ),
//         GoRoute(
//           path: home,
//           builder: (context, state) => const HomePage(),
//         ),
//         GoRoute(
//           path: changePasswordSuccess,
//           builder: (context, state) => const ChangePasswordSuccess(),
//         ),
//         GoRoute(
//           path: otpLogin,
//           builder: (context, state) => const OtpLogin(),
//         ),
//         GoRoute(
//           path: otp,
//           builder: (context, state) => const OtpScreen(),
//         ),
//         GoRoute(
//           path: accountSuccess,
//           builder: (context, state) => const AccountSuccessScreen(),
//         ),
//         GoRoute(
//           path: addBusinessSuccess,
//           builder: (context, state) => const AddBusinessSuccess(),
//         ),
//         GoRoute(
//           path: allBusiness,
//           builder: (context, state) => const AllBusinesses(),
//         ),
//         GoRoute(
//           path: upgradeSubscription,
//           builder: (context, state) => const UpgradeSubscription(),
//         ),
//         GoRoute(
//           path: addProduct,
//           builder: (context, state) => AddProduct(),
//         ),
//         GoRoute(path: addCategory, builder: (context, state) => AddCategory()),
//         GoRoute(
//             path: emptyCategory, builder: (context, state) => EmptyCategory()),
//         GoRoute(path: brands, builder: (context, state) => Brands()),
//         GoRoute(path: addBrand, builder: (context, state) => AddBrand()),
//         GoRoute(
//             path: productSuccess,
//             builder: (context, state) => const AddProductSuccess()),
//         GoRoute(
//             path: emptyProduct, builder: (context, state) => EmptyProduct()),
//         GoRoute(
//             path: productDetails,
//             builder: (context, state) => const ProductDetails()),
//         GoRoute(path: allReceipts, builder: (context, state) => AllReceipts()),
//         GoRoute(path: drafts, builder: (context, state) => Drafts()),
//         GoRoute(
//             path: completeDraft, builder: (context, state) => CompleteDraft()),
//         GoRoute(path: receipt, builder: (context, state) => const Receipt()),
//         GoRoute(
//             path: generateReceipt,
//             builder: (context, state) => GenerateReceipt()),
//         GoRoute(
//             path: selectClient, builder: (context, state) => SelectClient()),
//         GoRoute(
//             path: generateInvoices,
//             builder: (context, state) => GenerateInvoices()),
//         GoRoute(path: allInvoices, builder: (context, state) => AllInvoices()),
//         GoRoute(
//             path: updatePersonalDetails,
//             builder: (context, state) => UpdatePersonalDetails()),
//         GoRoute(
//             path: businessData, builder: (context, state) => const BusinessData()),
//         GoRoute(
//             path: payvidenceInfo,
//             builder: (context, state) => const PayvidenceInfo()),
//         GoRoute(
//             path: changeProfilePicture,
//             builder: (context, state) => const ChangeProfilePicture()),
//         GoRoute(
//             path: notifications, builder: (context, state) => const Notifications()),
//         GoRoute(path: settings, builder: (context, state) => const Settings()),
//         GoRoute(
//             path: mySubscription,
//             builder: (context, state) => const MySubscription()),
//         GoRoute(
//             path: changePassword,
//             builder: (context, state) => ChangePassword()),
//         GoRoute(
//             path: privacyAndSecurity,
//             builder: (context, state) => const PrivacyAndSecurity()),
//         GoRoute(
//             path: resetPassword, builder: (context, state) => ResetPassword()),
//         GoRoute(
//             path: notificationSettings,
//             builder: (context, state) => const NotificationSettings()),
//         GoRoute(
//             path: updateQuantity,
//             builder: (context, state) => UpdateQuantity()),
//         GoRoute(
//             path: businessDetail,
//             builder: (context, state) => const BusinessDetail()),
//         GoRoute(path: clients, builder: (context, state) => Clients()),
//         GoRoute(
//             path: clientDetails, builder: (context, state) => ClientDetails()),
//         GoRoute(path: addClient, builder: (context, state) => AddClient()),
//         GoRoute(
//             path: clientSuccess, builder: (context, state) => const ClientSuccess()),
//       ],
//     );
//   });
// }

final navigationProvider = Provider<AppRouter>((ref) {
  return AppRouter();
});

@AutoRouterConfig()
class AppRouter extends RootStackRouter{

  // @override
  // RouteType get defaultRouteType => RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: OnboardingScreenRoute.page, initial: true),
    AutoRoute(page: HomePageRoute.page),
    AutoRoute(page: CreateAccountRoute.page),
    AutoRoute(page: LoginRoute.page),





  ];
}
