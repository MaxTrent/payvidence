import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../constants/app_colors.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
   



@RoutePage(name: 'CompleteDraftRoute')
class CompleteDraft extends StatelessWidget {
  CompleteDraft({super.key});

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: SafeArea(
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h,),
              Text('Complete draft', style: Theme.of(context).textTheme.displayLarge,),
              SizedBox(height: 8.h,),
              Text('Fill in the details below to record new sales.', style: Theme.of(context).textTheme.displaySmall!,),
              SizedBox(height: 32.h,),
              Text('Client name', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Client name', controller: _controller, suffixIcon: const Icon(Icons.keyboard_arrow_down),),
              SizedBox(height: 20.h,),
              Text('Product name', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Select product', controller: _controller, suffixIcon: const Icon(Icons.keyboard_arrow_down)),
              SizedBox(height: 20.h,),
              Text('Quantity available', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Quantity available', controller: _controller, fillColor: borderColor, filled: true,),
              SizedBox(height: 20.h,),
              Text('Quantity purchased', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Quantity purchased', controller: _controller,),
              SizedBox(height: 20.h,),
              Text('Discount percentage (if any)', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Discount percentage', controller: _controller,),
              SizedBox(height: 20.h,),
              Text('Product price', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Product price', controller: _controller, prefixIcon: Padding(
                padding:  EdgeInsets.fromLTRB(16.w, 16.h, 6.w, 16.h),
                child: Text('₦', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp)),
              ), ),SizedBox(height: 20.h,),
              Text('VAT rate', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: '', controller: _controller, suffixIcon: Padding(
                padding:  EdgeInsets.fromLTRB(16.w, 16.h, 6.w, 16.h),
                child: Text('%', style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 14.sp)),
              ), ),
              SizedBox(height: 20.h,),
              Text('Mode of payment', style: Theme.of(context).textTheme.displaySmall,),
              SizedBox(height: 8.h,),
              AppTextField(hintText: 'Select mode of payment', controller: _controller, suffixIcon: const Icon(Icons.keyboard_arrow_down),),

              SizedBox(height: 32.h,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppButton(buttonText: 'Generate receipt', onPressed: (){
                    locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.generateReceipt);
                  },),
                  SizedBox(height: 26.h,),
                  Text('Save as draft', style: Theme.of(context).textTheme.displayMedium!.copyWith(color: primaryColor2),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
