import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
 import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/constants/app_colors.dart';
import '../../components/app_text_field.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
    

@RoutePage(name: 'AddBusinessRoute')
class AddBusiness extends HookConsumerWidget {
  AddBusiness({super.key});
  // final _controller = TextEditingController();

  @override
  Widget build(BuildContext context, ref) {

    final businessNameController = useTextEditingController();
    final businessAddressController = useTextEditingController();
    final phoneNumberController = useTextEditingController();
    final issuerController = useTextEditingController();
    final roleController = useTextEditingController();
    final logoImage = useState<File?>(null);
    final signatureImage = useState<File?>(null);



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
              SizedBox(height: 12.h,),
              _buildSectionTitle(context, 'Business name'),
              AppTextField(hintText: 'Business name', controller: businessNameController,),
              _buildSectionTitle(context, 'Business address'),
              AppTextField(hintText: 'Business address', controller: businessAddressController,),
              _buildSectionTitle(context, 'Business phone number'),
              AppTextField(hintText: 'Business phone number', controller: phoneNumberController,),
              _buildSectionTitle(context, 'Business logo'),
              SvgPicture.asset(Assets.svg.uploadImage),
              _buildSectionTitle(context, 'Who issues receipts and invoices?'),
              AppTextField(hintText: '', controller: issuerController, fillColor: borderColor, filled: true,),
              _buildSectionTitle(context, 'What is the role of this issuer? '),
              AppTextField(hintText: 'Role of issuer', controller: roleController,),
              _buildSectionTitle(context, 'Issuer signature'),
              SvgPicture.asset(Assets.svg.uploadImage),
              SizedBox(height: 32.h,),
              AppButton(buttonText: 'Add business', onPressed: (){
                locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.addBusiness);
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding:  EdgeInsets.only(top: 20.h, bottom: 8.w),
      child: Text(title, style: Theme.of(context).textTheme.displaySmall),
    );
  }
}
