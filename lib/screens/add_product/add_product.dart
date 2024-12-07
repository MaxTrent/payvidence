import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/screens/routes/app_routes.dart';

import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';

class AddProduct extends StatelessWidget {
  AddProduct({super.key});

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
              Text('Enter product details', style: Theme.of(context).textTheme.displayLarge,),
              SizedBox(height: 8.h,),
              Text('Fill in all details carefully and correctly.', style: Theme.of(context).textTheme.displaySmall!,),
              SizedBox(height: 32.h,),
              Text('Product category', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              GestureDetector(
                  onTap: (){
                    context.push(AppRoutes.emptyCategory);
                  },
                  child: AppTextField(hintText: 'Select category', controller: _controller, suffixIcon: Icon(Icons.keyboard_arrow_down_sharp), enabled: false,)),
              SizedBox(height: 20.h,),
              Text('Product name', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Product name', controller: _controller,),
              SizedBox(height: 20.h,),
              Text('Product brand', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Select brand', controller: _controller, suffixIcon: Icon(Icons.keyboard_arrow_down_sharp), enabled: false,),
              SizedBox(height: 20.h,),
              Text('Product description', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(
                height: 128, hintText: '', controller: _controller, ),
              SizedBox(height: 20.h,),
              Text('Product quantity', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Product quantity', controller: _controller,),
              SizedBox(height: 20.h,),
              Text('Product price', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Product price', controller: _controller, prefixIcon: Padding(
                padding:  EdgeInsets.fromLTRB(16.w, 16.h, 6.w, 16.h),
                child: Text('₦', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp)),
              ), ),
              SizedBox(height: 20.h,),
              Text('Product image', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              SvgPicture.asset(Assets.svg.uploadImage),
              SizedBox(height: 20.h,),
              Text('Is VAT applicable to this product?', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Select option', controller: _controller, suffixIcon: Icon(Icons.keyboard_arrow_down_sharp),),
              SizedBox(height: 32.h,),
              AppButton(buttonText: 'Add product', onPressed: (){
                context.go('/addBusinessSuccess');
              })
            ],
          ),
        ),
      ),
    );
  }
}
