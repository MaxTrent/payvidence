import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/app_button.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.gr.dart';
   



@RoutePage(name: 'ClientSuccessRoute')
class ClientSuccess extends StatelessWidget {
  const ClientSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AppButton(
          buttonText: 'Alright!',
          onPressed: (){
            context.router.replace(LoginRoute());
          }),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.svg.clientSuccess),
              SizedBox(
                height: 40.h,
              ),
              Text(
                'Client added! ',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                'Elizabeth Ojo has been successfully added to your clients. You can now select the client while generating receipt and invoice.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall!,
              ),
              SizedBox(
                height: 32.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
