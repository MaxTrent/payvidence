import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/login/login_vm.dart';
import 'package:payvidence/screens/onboarding/onboarding.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';


@RoutePage(name: 'LoginRoute')
class Login extends HookConsumerWidget {
  Login({super.key});


  @override
  Widget build(BuildContext context, ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final viewModel = ref.watch(loginViewModelProvider);

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final areFieldsEmpty = useState(true);
    final obscureText = useState(true);

    bool checkFieldsEmpty() {
      return emailController.text.toString().isEmpty ||
          passwordController.text.toString().isEmpty;
    }

    useEffect(() {
      void updateFieldsEmptyStatus() {
        areFieldsEmpty.value = checkFieldsEmpty();
        print("Fields empty: ${areFieldsEmpty.value}");
      }

      emailController.addListener(updateFieldsEmptyStatus);
      passwordController.addListener(updateFieldsEmptyStatus);

      return () {
        emailController.removeListener(updateFieldsEmptyStatus);
        passwordController.removeListener(updateFieldsEmptyStatus);
      };
    }, [
    ]);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus,
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    'Log in',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  Text(
                    'Log in with your email address and password',
                    style: Theme.of(context).textTheme.displaySmall!,
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  Text(
                    'Email address',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    hintText: 'Email address',
                    controller:
                        emailController,
                    validator: (val) {
                      if (!val!.isValidEmail || val.isEmpty) {
                        return 'Enter valid email address';
                      }
                      return null;
                    },
                  ),

                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    'Password',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  AppTextField(
                    hintText: 'Password',
                    controller:passwordController,
                    validator: (val) {
                      if (!val!.isValidPassword || val.isEmpty) {
                        return 'Enter a valid password';
                      }
                      return null;
                    },
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(16.h),
                      child: GestureDetector(
                        onTap: () => obscureText.value = !obscureText.value,
                        child: SvgPicture.asset(
                          Assets.svg.password,
                          height: 24.h,
                          width: 24.w,
                        ),
                      ),
                    ),
                    obscureText: obscureText.value,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  GestureDetector(
                    onTap: () {
                      locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.forgotPassword);
                    },
                    child: Text(
                      'Forgot password?',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontSize: 14.sp, color: primaryColor2),
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                  ),
                  // viewModel.loginState.isLoading ? const LoadingIndicator():
                  AppButton(
                    buttonText: 'Log in',
                    isDisabled: areFieldsEmpty.value,
                    isProcessing: viewModel.isLoading,
                    onPressed: () {
                      print("Button pressed");
                      print("Fields empty: ${areFieldsEmpty.value}");
                      if (formKey.currentState!.validate()) {
                        print("Form is valid");
                        FocusScope.of(context).unfocus();
                        viewModel.login(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          navigateOnSuccess: () {
                            print('navigating');
                            locator<PayvidenceAppRouter>().popUntil(
                                    (route) => route is OnboardingScreen);
                            locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.home);
                          },
                        );
                      } else {
                        print("Form is not valid");
                      }
                    },



    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
