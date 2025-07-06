import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/components/keyboard_dismissible_scaffold.dart';
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
                                fontWeight: FontWeight.w700),
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                fontSize: Responsive.fontSize(context, 14),
                                fontWeight: FontWeight.w700),
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
    );
  }
}