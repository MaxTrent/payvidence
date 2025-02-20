
import 'package:auto_route/auto_route.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';

@AutoRouterConfig()
class PayvidenceAppRouter extends RootStackRouter {


  @override
  List<AutoRoute> get routes =>
      [
        AutoRoute(page: OnboardingScreenRoute.page, path: PayvidenceRoutes.onboarding, initial: true),
        AutoRoute(page: HomePageRoute.page, path: PayvidenceRoutes.home),
        AutoRoute(page: CreateAccountRoute.page, path: PayvidenceRoutes.createAccount),
        AutoRoute(page: LoginRoute.page, path: PayvidenceRoutes.login),
        AutoRoute(page: ForgotPasswordRoute.page, path: PayvidenceRoutes.forgotPassword),
        AutoRoute(page: EmptyBusinessRoute.page, path: PayvidenceRoutes.emptyBusiness),


      ];

}

class PayvidenceRoutes {
  PayvidenceRoutes(): super();


  static String get onboarding => '/onboarding';
  static String get login => '/login';
  static String get createAccount => '/createAccount';
  static String get forgotPassword => '/forgotPassword';
  static String get createNewPassword => '/createNewPassword';
  static String get emptyBusiness => '/emptyBusiness';
  static String get homeScreen => '/homescreen';
  static String get addBusiness => '/addBusiness';
  static String get home => '/home';
  static String get changePasswordSuccess => '/changePasswordSuccess';
  static String get otpLogin => '/otpLogin';
  static String get otp => '/otp';
  static String get accountSuccess => '/accountSuccess';
  static String get addBusinessSuccess => '/addBusinessSuccess';
  static String get allBusiness => '/allBusiness';
  static String get upgradeSubscription => '/upgradeSubscription';
  static String get addProduct => '/addProduct';
  static String get emptyCategory => '/emptyCategory';
  static String get addCategory => '/addCategory';
  static String get brands => '/brands';
  static String get addBrand => '/addBrands';
  static String get productSuccess => '/productSuccess';
  static String get emptyProduct => '/emptyProduct';
  static String get productDetails => '/productDetails';
  static String get allReceipts => '/allReceipts';
  static String get drafts => '/drafts';
  static String get completeDraft => '/completeDraft';
  static String get receipt => '/receipt';
  static String get generateReceipt => '/generateReceipt';
  static String get selectClient => '/selectClient';
  static String get generateInvoices => '/generateInvoices';
  static String get allInvoices => '/allInvoices';
  static String get updatePersonalDetails => '/updatePersonalDetails';
  static String get businessData => '/businessData';
  static String get payvidenceInfo => '/payvidenceInfo';
  static String get changeProfilePicture => '/changeProfilePicture';
  static String get notifications => '/notifications';
  static String get settings => '/settings';
  static String get mySubscription => '/mySubscription';
  static String get changePassword => '/changePassword';
  static String get privacyAndSecurity => '/privacyAndSecurity';
  static String get resetPassword => '/resetPassword';
  static String get notificationSettings => '/notificationSettings';
  static String get updateQuantity => '/updateQuantity';
  static String get businessDetail => '/businessDetail';
  static String get clients => '/clients';
  static String get clientDetails => '/clientDetails';
  static String get addClient => '/addClient';
  static String get clientSuccess => '/clientSuccess';



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

  // final navigationProvider = Provider<PayvidenceAppRouter>((ref) {
  //   return PayvidenceAppRouter();
  // });

  // @AutoRouterConfig(generateForDir: ['lib'])
  // class PayvidenceAppRouter extends $PayvidenceAppRouter {
  //
  // @override
  // RouteType get defaultRouteType => RouteType.material();


}
