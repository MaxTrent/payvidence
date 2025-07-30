import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/create_account/create_account_vm.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_text_field.dart';
import '../../gen/assets.gen.dart';
import '../../utilities/theme_mode.dart';
import '../onboarding/onboarding.dart';

@RoutePage(name: 'CreateAccountRoute')
class CreateAccountScreen extends HookConsumerWidget {
  const CreateAccountScreen({super.key});

  final _formKey = const GlobalObjectKey<FormState>('form');

  Future<dynamic> _showBottomSheet(
      BuildContext context, bool isDarkMode, String title, String body) {
    final responsiveData = ResponsiveInherited.of(context);

    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      context: context,
      builder: (context) {
        return Container(
          height: responsiveData.scaleHeight(800),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(responsiveData.radius),
              topLeft: Radius.circular(responsiveData.radius),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: responsiveData.paddingHorizontal,
                vertical: responsiveData.scaleHeight(10)),
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsiveData.scaleWidth(140)),
                  child: Container(
                    height: responsiveData.scaleHeight(5),
                    width: responsiveData.scaleWidth(67),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white54 : const Color(0xffd9d9d9),
                      borderRadius: BorderRadius.circular(responsiveData.radius),
                    ),
                  ),
                ),
                SizedBox(height: responsiveData.spacingVertical),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'PAYVIDENCE',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: Responsive.fontSize(context, 24),
                        fontWeight: FontWeight.w700,
                        color: primaryColor2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        color: isDarkMode ? Colors.white : Colors.black,
                        Icons.close,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: responsiveData.scaleHeight(32)),
                Text(
                  title,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: responsiveData.scaleHeight(40),
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: responsiveData.scaleHeight(24)),
                Text(
                  body,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPrivacyBottomSheet(BuildContext context, bool isDarkMode) {
    const privacyPolicyContent = '''
At Payvidence, we prioritize your privacy and the security of your personal information. This Privacy Policy outlines how we collect, use, and share the information you provide when using our mobile application and related services. By using Payvidence, you consent to the practices described in this policy.\n\n
1. Information We Collect\n
- Account Data: Business name, owner details\n
- Transaction Data: Sales records, payment info\n
- Technical Data: IP address, device type\n\n
2. Legal Basis for Processing\n
- Contractual necessity (service delivery)\n
- Legitimate business interests\n
- Legal compliance (e.g., FIRS tax reporting)\n\n
3. Data Sharing\n
We may disclose information to:\n
- Payment processors (Paystack/Flutterwave)\n
- Regulatory authorities (when legally required)\n\n
4. Data Security\n
- AES-256 encryption for all data\n
- Regular penetration testing\n
- NDPR-compliant storage (AWS Africa servers)\n\n
5. User Rights\n
You may:\n
- Request access to your data\n
- Correct inaccuracies\n
- Delete account (subject to tax retention requirements)\n\n
6. Cookies\n
We use essential cookies for:\n
- Session management\n
- Security purposes\n\n
7. Policy Updates\n
Users will be notified 30 days prior to material changes.
''';

    _showBottomSheet(context, isDarkMode, 'Our Privacy\nPolicy', privacyPolicyContent);
  }

  void _showTermsBottomSheet(BuildContext context, bool isDarkMode) {
    const termsAndConditionsContent = '''
These Terms and Conditions govern your use of PAYVIDENCE (the "Service"). By accessing or using the Service, you agree to be bound by these Terms. If you disagree, discontinue use immediately.\n\n
1. Acceptance of Terms\n
By accessing or using PAYVIDENCE, you agree to be bound by these Terms. If you disagree, discontinue use immediately.\n\n
2. Service Description\n
PAYVIDENCE provides:\n
- Digital sales and inventory management tools\n
- Payment processing integrations\n
- Financial reporting features\n\n
3. User Obligations\n
You must:\n
- Be at least 18 years old\n
- Provide accurate business information\n
- Not use the Service for illegal activities\n\n
4. Subscription Plans\n
- Starter: N20,000/year (500 transactions/month)\n
- Pro: N54,000/year (Unlimited transactions)\n
- Auto-renewal with 30-day cancellation notice\n\n
5. Payment Processing\n
- 0.75% fee applies to third-party payment integrations\n
- All transactions in Naira (₦)\n\n
6. Termination\n
We may suspend accounts for:\n
- Non-payment beyond 15 days\n
- Violation of these Terms\n\n
7. Limitation of Liability\n
PAYVIDENCE is not liable for:\n
- Indirect damages\n
- Losses from service interruptions\n\n
8. Governing Law\n
These Terms are governed by Nigerian law. Disputes shall be resolved in Abuja courts.
''';

    _showBottomSheet(context, isDarkMode, 'Terms and\nConditions', termsAndConditionsContent);
  }

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(createAccountViewModelProvider);
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final responsiveData = ResponsiveInherited.of(context);

    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final phoneController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final passwordConfirmController = useTextEditingController();

    final _areFieldsEmpty = useState(true);
    final obscurePasswordText = useState(true);
    final obscurePasswordConfirmText = useState(true);

    bool areFieldsEmpty() {
      return firstNameController.text.toString().isEmpty ||
          lastNameController.text.toString().isEmpty ||
          phoneController.text.toString().isEmpty ||
          emailController.text.toString().isEmpty ||
          passwordController.text.toString().isEmpty ||
          passwordConfirmController.text.toString().isEmpty;
    }

    useEffect(() {
      void updateFieldsEmptyStatus() {
        final isEmpty = areFieldsEmpty();
        if (_areFieldsEmpty.value != isEmpty) {
          _areFieldsEmpty.value = isEmpty;
        }
      }

      firstNameController.addListener(updateFieldsEmptyStatus);
      lastNameController.addListener(updateFieldsEmptyStatus);
      emailController.addListener(updateFieldsEmptyStatus);
      phoneController.addListener(updateFieldsEmptyStatus);
      passwordController.addListener(updateFieldsEmptyStatus);
      passwordConfirmController.addListener(updateFieldsEmptyStatus);

      return () {
        firstNameController.removeListener(updateFieldsEmptyStatus);
        lastNameController.removeListener(updateFieldsEmptyStatus);
        emailController.removeListener(updateFieldsEmptyStatus);
        phoneController.removeListener(updateFieldsEmptyStatus);
        passwordController.removeListener(updateFieldsEmptyStatus);
        passwordConfirmController.removeListener(updateFieldsEmptyStatus);
      };
    }, []);

    return ResponsiveWrapper(
      child: PopScope(
        onPopInvoked: (didPop) {
          if (viewModel.isLoading) {
            viewModel.cancelOperation();
          }
        },
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: KeyboardDismissibleScaffold(
          appBar: AppBar(),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
              child: SafeArea(
                child: ListView(
                  children: [
                    SizedBox(
                      height: responsiveData.scaleHeight(16),
                    ),
                    Text(
                      'Enter your details',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    Text(
                      'Create an account to enjoy Payvidence.',
                      style: Theme.of(context).textTheme.displaySmall!,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(32),
                    ),
                    Text(
                      'First name',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    AppTextField(
                      hintText: 'First Name',
                      controller: firstNameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      validator: (val) {
                        if (!val!.trim().isValidName || val.isEmpty) {
                          return 'Enter a valid name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(20),
                    ),
                    Text(
                      'Last name',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    AppTextField(
                      hintText: 'Last Name',
                      controller: lastNameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      validator: (val) {
                        if (!val!.trim().isValidName || val.trim().isEmpty) {
                          return 'Enter a valid password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(20),
                    ),
                    Text(
                      'Email address',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    AppTextField(
                      hintText: 'Email address',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        FilteringTextInputFormatter.deny(RegExp(r'\s')),
                      ],
                      autofillHints: const [AutofillHints.email],
                      validator: (val) {
                        if (!val!.trim().isValidEmail || val.isEmpty) {
                          return 'Enter valid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(20),
                    ),
                    Text(
                      'Phone number',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    AppTextField(
                      hintText: 'Phone number',
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(11),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      validator: (val) {
                        if (!val!.trim().isValidPhone || val.isEmpty) {
                          return 'Enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(20),
                    ),
                    Text(
                      'Password',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    AppTextField(
                      hintText: 'Password (8+ characters)',
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Password is required';
                        }
                        if (val.length < 8) {
                          return 'Password must be at least 8 characters long';
                        }
                        if (!RegExp(r'[A-Za-z]').hasMatch(val)) {
                          return 'Password must contain at least one letter';
                        }
                        if (!RegExp(r'\d').hasMatch(val)) {
                          return 'Password must contain at least one number';
                        }
                        return null;
                      },
                      controller: passwordController,
                      obscureText: obscurePasswordText.value,
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(responsiveData.scaleHeight(16)),
                        child: GestureDetector(
                          onTap: () => obscurePasswordText.value = !obscurePasswordText.value,
                          child: SvgPicture.asset(
                            Assets.svg.password,
                            colorFilter: ColorFilter.mode(
                                isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn),
                            width: responsiveData.scaleWidth(24),
                            height: responsiveData.scaleHeight(24),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(20),
                    ),
                    Text(
                      'Confirm Password',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(8),
                    ),
                    AppTextField(
                      hintText: 'Confirm Password',
                      controller: passwordConfirmController,
                      obscureText: obscurePasswordConfirmText.value,
                      validator: (val) {
                        final password = passwordController.text.trim();

                        if (val == null || val.trim().isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (val != password) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      suffixIcon: Padding(
                        padding: EdgeInsets.all(responsiveData.scaleHeight(16)),
                        child: GestureDetector(
                          onTap: () => obscurePasswordConfirmText.value = !obscurePasswordConfirmText.value,
                          child: SvgPicture.asset(
                            Assets.svg.password,
                            colorFilter: ColorFilter.mode(
                                isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn),
                            width: responsiveData.scaleWidth(24),
                            height: responsiveData.scaleHeight(24),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(20),
                    ),
                    Text.rich(
                      TextSpan(
                        text: 'By continuing, you agree to Payvidence\'s ',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            fontSize: Responsive.fontSize(context, 14)),
                        children: [
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                fontSize: Responsive.fontSize(context, 14),
                                fontWeight: FontWeight.w700,
                                color: primaryColor2),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _showTermsBottomSheet(context, isDarkMode),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                fontSize: Responsive.fontSize(context, 14),
                                fontWeight: FontWeight.w700,
                                color: primaryColor2),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _showPrivacyBottomSheet(context, isDarkMode),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(32),
                    ),
                    AppButton(
                      buttonText: 'Create account',
                      isDisabled: _areFieldsEmpty.value,
                      isProcessing: viewModel.isLoading,
                      onPressed: () {
                        debugPrint("Button pressed");
                        if (_formKey.currentState!.validate()) {
                          debugPrint("Form is valid");
                          FocusScope.of(context).unfocus();
                          viewModel.createAccount(
                            firstName: firstNameController.text.trim(),
                            lastName: lastNameController.text.trim(),
                            phone: phoneController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            passwordConfirm: passwordConfirmController.text.trim(),
                            navigateOnSuccess: () {
                              locator<PayvidenceAppRouter>()
                                  .navigateNamed(PayvidenceRoutes.otp);
                            },
                          );
                        } else {
                          print("Form is not valid");
                        }
                      },
                    ),
                    SizedBox(
                      height: responsiveData.scaleHeight(36),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}