import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:payvidence/routes/app_routes.dart';

import '../../components/app_button.dart';
import '../../components/app_text_field.dart';

class AddBrand extends StatelessWidget {
  AddBrand({super.key});

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h,),
            Text('Add new brand', style: Theme.of(context).textTheme.displayLarge,),
            SizedBox(height: 8.h,),
            Text('Fill in the details below to add a new brand.', style: Theme.of(context).textTheme.displaySmall!,),
            SizedBox(height: 32.h,),
            Text('Brand name', style: Theme.of(context).textTheme.displaySmall,),
            SizedBox(height: 8.h,),
            AppTextField(hintText: 'Brand name', controller: _controller,),
            SizedBox(height: 20.h,),
            Text('Brand description', style: Theme.of(context).textTheme.displaySmall,),
            SizedBox(height: 8.h,),
            AppTextField(
              height: 128, hintText: 'Brand description', controller: _controller, ),
            SizedBox(height: 32.h,),
            AppButton(buttonText: 'Save brand', onPressed: (){
              context.push(AppRoutes.productSuccess);
            })
          ],
        ),
      ),
    );
  }
}
