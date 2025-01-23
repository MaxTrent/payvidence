import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/screens/otp/otp_vm.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_colors.dart';


final otpViewModelProvider = StateNotifierProvider.autoDispose<OtpViewModel, OtpState>(
  (ref) => OtpViewModel(),
);


class OtpScreen extends ConsumerWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context, ref) {
    // final viewModel = OtpViewModel(ref);
     final state = ref.watch(otpViewModelProvider);
    final viewModel = ref.read(otpViewModelProvider.notifier);


    // WidgetsBinding.instance.addPostFrameCallback((_) {
      // viewModel.startCountdown();
    // });


    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 16.h,
            ),
            Text(
              'Enter OTP sent',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(
              height: 8.h,
            ),
            Text(
              'A code has been sent to temiloluwaadams@gmail.com',
              style: Theme.of(context).textTheme.displaySmall!,
            ),
            SizedBox(
              height: 32.h,
            ),
            Directionality(
              textDirection: TextDirection.ltr,
              child: Pinput(
                showCursor: true,
                controller: TextEditingController(),
                // focusNode: viewModel.focusNode,
                length: 5,
                defaultPinTheme: PinTheme(
                  height: 68.h,
                  width: 64.w,
                  textStyle: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 24.sp,),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: borderColor),
                  ),
                ),
                // androidSmsAutofillMethod:
                // AndroidSmsAutofillMethod.smsUserConsentApi,
                // listenForMultipleSmsOnAndroid: true,
                separatorBuilder: (index) =>  SizedBox(width: 8.w),
                // validator: (value) {
                //   return null;
                // },
                hapticFeedbackType: HapticFeedbackType.lightImpact,
                onCompleted: (pin) {
                  debugPrint('onCompleted: $pin');
                },
                onChanged: (value) {
                  debugPrint('onChanged: $value');
                },
                cursor: const Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [],
                ),
              ),
            ),
            SizedBox(
              height: 32.h,
            ),
            AppButton(buttonText: 'Submit', onPressed: () {
              context.push('/accountSuccess');
            }),
            SizedBox(
              height: 58.h,
            ),
             GestureDetector(
              onTap: state.seconds == 0 ? viewModel.resendCode : null,
              child: Text.rich(
                TextSpan(
                  children: [
                    if (state.seconds > 0) ...[
                      TextSpan(
                        text: 'Resend code in ',
                        style:Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: '${state.seconds} ',
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
                    .copyWith(fontWeight: FontWeight.w400,
                              color: Color(0xff4E38B2),
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
