import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/screens/otp/otp_vm.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';


@RoutePage(name: 'OtpScreenRoute')
class OtpScreen extends ConsumerWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpText = ref.watch(OtpViewModel.otpTextProvider);
    final seconds = ref.watch(OtpViewModel.secondsProvider);
    final isComplete = ref.watch(OtpViewModel.isOtpCompleteProvider);
    final viewModel = ref.read(otpViewModelProvider);
    final verifyState = ref.watch(verifyOtpNotifierProvider);

    // Start countdown when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.startCountdown();
    });

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
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
              'A code has been sent to temiloluwaadams@gmail.com',
              style: Theme.of(context).textTheme.displaySmall!,
            ),
            SizedBox(height: 32.h),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Pinput(
                showCursor: true,
                length: 5,
                onChanged: (value) => ref.read(OtpViewModel.otpTextProvider.notifier).state = value,
                defaultPinTheme: PinTheme(
                  height: 68.h,
                  width: 64.w,
                  textStyle: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 24.sp),
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
              buttonText: 'Submit',
              onPressed: isComplete ? () {
                ref.read(verifyOtpNotifierProvider.notifier).verifyOtp(otpText);
              } : null,
              backgroundColor: isComplete ? primaryColor2 : primaryColor2.withOpacity(0.4),
            ),
            SizedBox(height: 58.h),
            if (verifyState.isLoading)
              const CircularProgressIndicator()
            else if (verifyState.error != null)
              Text(
                verifyState.error!,
                style: const TextStyle(color: Colors.red),
              )
            else
              GestureDetector(
                onTap: seconds == 0 ? viewModel.resendCode : null,
                child: Text.rich(
                  TextSpan(
                    children: [
                      if (seconds > 0) ...[
                        TextSpan(
                          text: 'Resend code in ',
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontWeight: FontWeight.w400
                          ),
                        ),
                        TextSpan(
                          text: '$seconds ',
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(
                          text: 'seconds',
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                            fontWeight: FontWeight.w400
                          ),
                        ),
                      ] else
                        TextSpan(
                          text: 'Resend code',
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
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
    );
  }
}