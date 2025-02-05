import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 import 'package:pinput/pinput.dart';

import '../../components/app_button.dart';
import '../../constants/app_colors.dart';
import '../../routes/app_routes.gr.dart';


@RoutePage(name: 'OtpLoginRoute')
class OtpLogin extends StatelessWidget {
  const OtpLogin({super.key});

  @override
  Widget build(BuildContext context) {
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
              context.router.push(CreateNewPasswordRoute());
            }),
            SizedBox(
              height: 58.h,
            ),
            Text.rich(TextSpan(
                text: 'Resend code in ',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(fontWeight: FontWeight.w400),
                children: [
                  TextSpan(text: '17', style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontWeight: FontWeight.w700))
                ]))
          ],
        ),
      ),
    );
  }
}
