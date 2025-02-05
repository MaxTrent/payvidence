import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../routes/app_routes.gr.dart';


@RoutePage(name: 'UpdatePersonalDetailsRoute')
class UpdatePersonalDetails extends StatelessWidget {
  UpdatePersonalDetails({super.key});
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h,),
              Text('Update personal details', style: Theme.of(context).textTheme.displayLarge,),
              SizedBox(height: 8.h,),
              Text('You can update your profile here.', style: Theme.of(context).textTheme.displaySmall!,),
              SizedBox(height: 32.h,),
              Text('First name', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'First Name', controller: _emailController,),
              SizedBox(height: 20.h,),
              Text('Last name', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Last name', controller: _emailController,),
              SizedBox(height: 20.h,),
              Text('Email address', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Email address', controller: _emailController,),
              SizedBox(height: 20.h,),
              Text('Phone number', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Phone number', controller: _emailController),

              SizedBox(height: 32.h,),
              AppButton(buttonText: 'Update details', onPressed: (){
                context.router.replace(HomePageRoute());
              },),
            ],
          ),
        ),
      ),
    );
  }
}
