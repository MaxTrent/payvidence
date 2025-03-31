import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/screens/update_personal_details/update_personal_details_vm.dart';
import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../components/custom_shimmer.dart';
import '../../routes/payvidence_app_router.gr.dart';

@RoutePage(name: 'UpdatePersonalDetailsRoute')
class UpdatePersonalDetails extends HookConsumerWidget {
  const UpdatePersonalDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(updatePersonalDetailsViewModelProvider);
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);

    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final phoneController = useTextEditingController();


    useEffect(() {
      print("fetching user info");
      viewModel.fetchUserInformation();
      return null;
    }, []);


    useEffect(() {
      if (viewModel.userInfo != null && !viewModel.isLoading) {
        print("useEffect - userInfo: ${viewModel.userInfo}");
        firstNameController.text = viewModel.userInfo?.account.firstName ?? "";
        lastNameController.text = viewModel.userInfo?.account.lastName ?? "";
        emailController.text = viewModel.userInfo?.account.email ?? "";
        phoneController.text = viewModel.userInfo?.account.phoneNumber ?? "";
        print("Controllers set - FirstName: ${firstNameController.text}, LastName: ${lastNameController.text}");
      }
      return null;
    }, [viewModel.userInfo, viewModel.isLoading]);


    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SafeArea(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),
                  Text(
                    'Update personal details',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'You can update your profile here.',
                    style: Theme.of(context).textTheme.displaySmall!,
                  ),
                  SizedBox(height: 32.h),
                  if (viewModel.isLoading) ...[
                    Text('First name', style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(height: 8.h),
                    CustomShimmer(height: 50.h),
                    SizedBox(height: 20.h),
                    Text('Last name', style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(height: 8.h),
                    CustomShimmer(height: 50.h),
                    SizedBox(height: 20.h),
                    Text('Email address', style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(height: 8.h),
                    CustomShimmer(height: 50.h),
                    SizedBox(height: 20.h),
                    Text('Phone number', style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(height: 8.h),
                    CustomShimmer(height: 50.h),
                  ] else ...[
                    Text('First name', style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(height: 8.h),
                    AppTextField(
                      hintText: 'First Name',
                      enabled: false,
                      controller: firstNameController,
                    ),
                    SizedBox(height: 20.h),
                    Text('Last name', style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(height: 8.h),
                    AppTextField(
                      hintText: 'Last Name',
                      enabled: false,
                      controller: lastNameController,
                    ),
                    SizedBox(height: 20.h),
                    Text('Email address', style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(height: 8.h),
                    AppTextField(
                      hintText: 'Email address',
                      enabled: false,
                      controller: emailController,
                    ),
                    SizedBox(height: 20.h),
                    Text('Phone number', style: Theme.of(context).textTheme.displaySmall),
                    SizedBox(height: 8.h),
                    AppTextField(
                      hintText: 'Phone number',
                      enabled: false,
                      controller: phoneController,
                    ),
                  ],
                  SizedBox(height: 32.h),
                  AppButton(
                    buttonText: 'Update details',
                    onPressed: viewModel.isLoading
                        ? null
                        : () {
                      // context.router.replace(HomePageRoute());
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}