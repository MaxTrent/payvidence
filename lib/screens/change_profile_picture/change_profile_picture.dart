import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/app_button.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/screens/change_profile_picture/change_profile_picture_vm.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';

import '../../gen/assets.gen.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'ChangeProfilePictureRoute')
class ChangeProfilePicture extends HookConsumerWidget {
  const ChangeProfilePicture({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(changeProfilePictureViewModelProvider);
    final isImageSelected = useState(false);

    useEffect(() {
      void listener() {
        isImageSelected.value = viewModel.selectedImage != null;
      }
      viewModel.addListener(listener);
      return () => viewModel.removeListener(listener);
    }, [viewModel]);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Text(
                'Change profile picture',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 8.h),
              Text(
                'You can update your picture here.',
                style: Theme.of(context).textTheme.displaySmall!,
              ),
              SizedBox(height: 32.h),
              Center(
                child: CircleAvatar(
                  radius: 100.r,
                  backgroundColor: Colors.purple,
                  backgroundImage: viewModel.selectedImage != null
                      ? FileImage(viewModel.selectedImage!)
                      : null,
                  child: viewModel.selectedImage == null
                      ? SvgPicture.asset(Assets.svg.defaultProfilepic, fit: BoxFit.cover,)
                      : null,
                ),
              ),
              SizedBox(height: 32.h),
              AppButton(
                isProcessing: viewModel.isLoading,
                isDisabled: viewModel.isLoading || !isImageSelected.value,
                buttonText: viewModel.selectedImage == null ? 'Choose image' : 'Upload image',
                onPressed: () {
                  if (viewModel.selectedImage == null) {
                    viewModel.pickImage();
                  } else {
                    viewModel.uploadImage(
                      navigateOnSuccess: () {
                        locator<PayvidenceAppRouter>().back();
                        },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}