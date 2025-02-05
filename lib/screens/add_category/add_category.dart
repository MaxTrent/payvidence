import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/components/app_button.dart';

import '../../components/app_text_field.dart';

@RoutePage(name: 'AddCategoryRoute')
class AddCategory extends StatelessWidget {
  AddCategory({super.key});
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
            Text('Add new category', style: Theme.of(context).textTheme.displayLarge,),
            SizedBox(height: 8.h,),
            Text('Fill in the details below to add a new category.', style: Theme.of(context).textTheme.displaySmall!,),
            SizedBox(height: 32.h,),
            Text('Category name', style: Theme.of(context).textTheme.displaySmall,),
            SizedBox(height: 8.h,),
            AppTextField(hintText: 'Category name', controller: _controller,),
            SizedBox(height: 20.h,),
            Text('Category description', style: Theme.of(context).textTheme.displaySmall,),
            SizedBox(height: 8.h,),
            AppTextField(
              height: 128, hintText: 'Category description', controller: _controller, ),
            SizedBox(height: 32.h,),
            AppButton(buttonText: 'Save category', onPressed: (){})
          ],
        ),
      ),
    );
  }
}
