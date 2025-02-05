import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
 
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../constants/app_colors.dart';


@RoutePage(name: 'UpdateQuantityRoute')
class UpdateQuantity extends StatelessWidget {
   UpdateQuantity({super.key});

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
              Text('Update quantity', style: Theme.of(context).textTheme.displayLarge,),
              SizedBox(height: 8.h,),
              Text('You can change the quantity of products here.', style: Theme.of(context).textTheme.displaySmall!,),
              SizedBox(height: 32.h,),
              Text('Available quantity ', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(enabled: false, hintText: 'Available quantity ', controller: _emailController, filled: true,fillColor: appGrey,appBorderColor: borderColor,),
              SizedBox(height: 20.h,),
              Text('Sold quantity ', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(enabled: false, hintText: 'Sold quantity ', controller: _emailController, filled: true,fillColor: appGrey,appBorderColor: borderColor,),
              SizedBox(height: 20.h,),
              Text('Restocked quantity ', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Restocked quantity ', controller: _emailController,),
              SizedBox(height: 20.h,),

              SizedBox(height: 32.h,),
              AppButton(buttonText: 'Update record', onPressed: (){
                context.router.maybePop();
              },),
            ],
          ),
        ),
      ),
    );
  }
}
