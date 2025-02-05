import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
 import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/constants/app_colors.dart';
import 'package:payvidence/screens/add_business_success/add_business_success.dart';

import '../../components/app_text_field.dart';
import '../../gen/assets.gen.dart';
import '../../routes/app_routes.gr.dart';

@RoutePage(name: 'AddBusinessRoute')
class AddBusiness extends StatelessWidget {
  AddBusiness({super.key});
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView(
            children: [
              Text('Set-up business', style: Theme.of(context).textTheme.displayLarge,),
              SizedBox(height: 8.h,),
              Text('Fill in all details to add your business.', style: Theme.of(context).textTheme.displaySmall!,),
              SizedBox(height: 32.h,),
              Text('Business name', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Business name', controller: _controller,),
              SizedBox(height: 20.h,),
              Text('Business address', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Business address', controller: _controller,),
              SizedBox(height: 20.h,),
              Text('Business phone number', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Business phone number', controller: _controller,),
              SizedBox(height: 20.h,),
              Text('Business logo', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              SvgPicture.asset(Assets.svg.uploadImage),
              SizedBox(height: 20.h,),
              Text('Who issues receipts and invoices?', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: '', controller: _controller, fillColor: borderColor, filled: true,),
              SizedBox(height: 20.h,),
              Text('What is the role of this issuer? ', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Role of issuer', controller: _controller,),
              SizedBox(height: 20.h,),
              Text('Issuer signature', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              SvgPicture.asset(Assets.svg.uploadImage),
              SizedBox(height: 32.h,),
              AppButton(buttonText: 'Add business', onPressed: (){
                context.router.replace(const AddBusinessSuccessRoute());
              })
            ],
          ),
        ),
      ),
    );
  }
}
