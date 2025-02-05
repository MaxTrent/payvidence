import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../components/app_button.dart';
import '../../gen/assets.gen.dart';

@RoutePage(name: 'AddProductSuccessRoute')
class AddProductSuccess extends StatelessWidget {
  const AddProductSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(Assets.svg.productSuccess),
            SizedBox(height: 40.h,),
            Text('Product added!', style: Theme.of(context).textTheme.displayLarge,),
            SizedBox(height: 10.h,),
            Text('Vanz Sneakers has been successfully added to your products. You can start generating receipts and invoices for the product.',textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp, ))
          ],
        ),
      ),
      floatingActionButton: AppButton(buttonText: 'Alright!', onPressed: (){
        // context.go(AppRoutes.allBusiness);
      }),
    );
  }
}
