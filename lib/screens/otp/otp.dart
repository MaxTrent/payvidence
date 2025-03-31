import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinput/pinput.dart';

import '../../components/app_button.dart';
import '../../constants/app_colors.dart';
import '../../data/local/session_constants.dart';
import '../../data/local/session_manager.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import 'otp_vm.dart';

@RoutePage(name: 'OtpScreenRoute')
class OtpScreen extends HookConsumerWidget {
  OtpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final email = locator<SessionManager>().get(SessionConstants.userEmail);
    final viewModel = ref.read(otpViewModelProvider);
    final pinController = useTextEditingController();
    final seconds = useState(17);
    final isTextFieldEmpty = useState(true);
    Timer? timer;

    void startTimer() {
      seconds.value = 17;
      timer?.cancel();
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (seconds.value > 0) {
          seconds.value--;
        } else {
          timer.cancel();
        }
      });
    }

    void resendCode() {
      viewModel.resendOtp();
      startTimer();
    }

    useEffect(() {
      void listener() {
        isTextFieldEmpty.value = pinController.text.isEmpty;
      }

      pinController.addListener(listener);
      return () => pinController.removeListener(listener);
    }, []);

    useEffect(() {
      startTimer();
      return () => timer?.cancel();
    }, []);

    // final isComplete = pinController.text.length == 5;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),
                Text(
                  'Enter OTP sent',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: 8.h),
                Text(
                  'A code has been sent to $email',
                  style: Theme.of(context).textTheme.displaySmall!,
                ),
                SizedBox(height: 32.h),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    controller: pinController,
                    showCursor: true,
                    length: 5,
                    defaultPinTheme: PinTheme(
                      height: 68.h,
                      width: 64.w,
                      textStyle: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontSize: 24.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: borderColor),
                      ),
                    ),
                    separatorBuilder: (index) => SizedBox(width: 8.w),
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {
                      debugPrint('onCompleted: $pin');
                    },
                  ),
                ),
                SizedBox(height: 32.h),
                AppButton(
                  isProcessing: viewModel.isLoading,
                  isDisabled: isTextFieldEmpty.value,
                  buttonText: 'Submit',
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print("Form is valid");
                      FocusScope.of(context).unfocus();
                      viewModel.verifyOtp(
                        otp: pinController.text,
                        navigateOnSuccess: () {
                          locator<PayvidenceAppRouter>()
                              .navigateNamed(PayvidenceRoutes.accountSuccess);
                        },
                      );
                    } else {
                      print("Form is not valid");
                    }
                  },
                ),
                SizedBox(height: 58.h),
                GestureDetector(
                  onTap: seconds.value == 0 ? resendCode : null,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        if (seconds.value > 0) ...[
                          TextSpan(
                            text: 'Resend code in ',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                          TextSpan(
                            text: '${seconds.value} ',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'seconds',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontWeight: FontWeight.w400),
                          ),
                        ] else
                          TextSpan(
                            text: 'Resend code',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff4E38B2),
                                ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
