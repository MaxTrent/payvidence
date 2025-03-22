import 'package:auto_route/auto_route.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';
import '../data/local/session_constants.dart';
import '../data/local/session_manager.dart';
import '../shared_dependency/shared_dependency.dart';

@AutoRouterConfig()
class PayvidenceAppRouter extends RootStackRouter {


  @override
  List<AutoRoute> get routes =>
      [
        AutoRoute(page: OnboardingScreenRoute.page, path: PayvidenceRoutes.onboarding),
        AutoRoute(page: HomePageRoute.page, path: PayvidenceRoutes.home, initial: true,
        guards: [
          AuthRouteGuard(),
        ],
        children: [
          AutoRoute(page: HomeScreenRoute.page, path: PayvidenceRoutes.homeScreen, initial: true),
          AutoRoute(page: SalesRoute.page, path: PayvidenceRoutes.sales),
          AutoRoute(page: ProfileRoute.page, path: PayvidenceRoutes.profile),

        ]),
        AutoRoute(page: CreateAccountRoute.page, path: PayvidenceRoutes.createAccount),
        AutoRoute(page: LoginRoute.page, path: PayvidenceRoutes.login),
        AutoRoute(page: ForgotPasswordRoute.page, path: PayvidenceRoutes.forgotPassword),
        AutoRoute(page: EmptyBusinessRoute.page, path: PayvidenceRoutes.emptyBusiness),
        AutoRoute(page: AddBusinessRoute.page, path: PayvidenceRoutes.addBusiness),
        AutoRoute(page: AddCategoryRoute.page, path: PayvidenceRoutes.addCategory),
        AutoRoute(page: CreateAccountRoute.page, path: PayvidenceRoutes.createAccount),
        AutoRoute(page: BusinessDetailRoute.page, path: PayvidenceRoutes.businessDetail),
        AutoRoute(page: ProductDetailsRoute.page, path: PayvidenceRoutes.productDetails),
        AutoRoute(page: ChangePasswordRoute.page, path: PayvidenceRoutes.changePassword),
        AutoRoute(page: AllBusinessesRoute.page, path: PayvidenceRoutes.allBusiness),
        AutoRoute(page: CreateNewPasswordRoute.page, path: PayvidenceRoutes.createNewPassword),
        AutoRoute(page: AddProductRoute.page, path: PayvidenceRoutes.addProduct),
        AutoRoute(page: AllInvoicesRoute.page, path: PayvidenceRoutes.allInvoices),
        AutoRoute(page: AllReceiptsRoute.page, path: PayvidenceRoutes.allReceipts),
        AutoRoute(page: ReceiptRoute.page, path: PayvidenceRoutes.receipt),
        AutoRoute(page: CompleteDraftRoute.page, path: PayvidenceRoutes.completeDraft),
        AutoRoute(page: ClientsRoute.page, path: PayvidenceRoutes.clients),
        AutoRoute(page: ProductRoute.page, path: PayvidenceRoutes.product),
        AutoRoute(page: DraftsRoute.page, path: PayvidenceRoutes.drafts),
        AutoRoute(page: EmptyCategoryRoute.page, path: PayvidenceRoutes.emptyCategory),
        AutoRoute(page: BrandsRoute.page, path: PayvidenceRoutes.brands),
        AutoRoute(page: AddBrandRoute.page, path: PayvidenceRoutes.addBrand),
        AutoRoute(page: UpdatePersonalDetailsRoute.page, path: PayvidenceRoutes.updatePersonalDetails),
        AutoRoute(page: PayvidenceInfoRoute.page, path: PayvidenceRoutes.payvidenceInfo),
        AutoRoute(page: BusinessDataRoute.page, path: PayvidenceRoutes.businessData),
        AutoRoute(page: SettingsRoute.page, path: PayvidenceRoutes.settings),
        AutoRoute(page: NotificationsRoute.page, path: PayvidenceRoutes.notifications),
        AutoRoute(page: ChangeProfilePictureRoute.page, path: PayvidenceRoutes.changeProfilePicture),
        AutoRoute(page: MySubscriptionRoute.page, path: PayvidenceRoutes.mySubscription),
        AutoRoute(page: OtpLoginRoute.page, path: PayvidenceRoutes.otpLogin),
        AutoRoute(page: CreateNewPasswordRoute.page, path: PayvidenceRoutes.createNewPassword),
        AutoRoute(page: ChangePasswordSuccessRoute.page, path: PayvidenceRoutes.changePasswordSuccess),
        AutoRoute(page: OtpResetRoute.page, path: PayvidenceRoutes.otpReset),
        AutoRoute(page: ResetPasswordSuccessRoute.page, path: PayvidenceRoutes.resetPasswordSuccess),
        AutoRoute(page: CreateNewPasswordResetRoute.page, path: PayvidenceRoutes.createNewPasswordReset),
        AutoRoute(page: ResetPasswordRoute.page, path: PayvidenceRoutes.resetPassword),
        AutoRoute(page: ChooseSubscriptionPlanRoute.page, path: PayvidenceRoutes.chooseSubscriptionPlan),
        AutoRoute(page: SubscriptionPlansRoute.page, path: PayvidenceRoutes.subscriptionPlans),

      ];

}

class AuthRouteGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    var isUserLoggedIn =
    locator<SessionManager>().get<bool>(SessionConstants.isUserLoggedIn);

    if ((isUserLoggedIn ?? false) == true) {
      resolver.next(true);
    } else {
      resolver.redirect(OnboardingScreenRoute());
    }
  }
}

class PayvidenceRoutes {
  PayvidenceRoutes(): super();


  static String get onboarding => '/onboarding';
  static String get login => '/login';
  static String get createAccount => '/createAccount';
  static String get forgotPassword => '/forgotPassword';
  static String get createNewPassword => '/createNewPassword';
  static String get emptyBusiness => '/emptyBusiness';
  static String get homeScreen => 'homeScreen';
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
  static String get addBrand => '/addBrand';
  static String get productSuccess => '/productSuccess';
  static String get product => '/product';
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
  static String get sales => 'sales';
  static String get profile => 'profile';
  static String get otpReset => '/otpReset';
  static String get resetPasswordSuccess => '/resetPasswordSuccess';
  static String get createNewPasswordReset => '/createNewPasswordReset';
  static String get chooseSubscriptionPlan => '/chooseSubPlan';
  static String get subscriptionPlans => '/subscriptionPlans';
}
