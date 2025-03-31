import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/screens/reset_password/reset_password_vm.dart';
import 'package:payvidence/utilities/validators.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../onboarding/onboarding.dart';



@RoutePage(name: 'ResetPasswordRoute')
class ResetPassword extends HookConsumerWidget {
  ResetPassword({super.key});


  @override
  Widget build(BuildContext context, ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final viewModel = ref.watch(resetPasswordViewModelProvider);
    final emailController = useTextEditingController();
    final isTextFieldEmpty = useState(true);

    useEffect(() {
      void listener() {
        isTextFieldEmpty.value = emailController.text.isEmpty;
      }
      emailController.addListener(listener);
      return () => emailController.removeListener(listener);
    }, []);


    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formKey,
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.w),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h,),
                Text('Reset password', style: Theme.of(context).textTheme.displayLarge,),
                SizedBox(height: 8.h,),
                Text('Confirm email address used for registration.', style: Theme.of(context).textTheme.displaySmall!,),
                SizedBox(height: 32.h,),
                Text('Email address', style: Theme.of(context).textTheme.displaySmall,),
                SizedBox(height: 8.h,),
                AppTextField(hintText: 'Email address', controller: emailController, validator: (val) {
                  if (!val!.isValidEmail || val.isEmpty) {
                    return 'Enter valid email address';
                  }
                  return null;
                },),
                SizedBox(height: 32.h,),
                AppButton(
                  isDisabled: isTextFieldEmpty.value,
                  isProcessing: viewModel.isLoading, buttonText: 'Continue', onPressed: (){
                  // locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.otpLogin);

                  if (formKey.currentState!.validate()) {
                    print("Form is valid");
                    FocusScope.of(context).unfocus();
                    viewModel.resetPasswordInit(
                      email: emailController.text.trim(),
                      navigateOnSuccess: () {
                        print('navigating');
                        locator<PayvidenceAppRouter>().popUntil(
                                (route) => route is OnboardingScreen);
                        locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.otpReset);
                      },
                    );
                  } else {
                    print("Form is not valid");
                  }
                },),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
