import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/providers/business_providers/current_business_provider.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';
import 'package:payvidence/screens/business_detail/business_detail_vm.dart';

import '../../components/app_button.dart';
import '../../components/custom_shimmer.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../providers/client_providers/get_all_client_provider.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'BusinessDetailRoute')
class BusinessDetail extends HookConsumerWidget with AutoRouteAware {
  final String businessId;

  const BusinessDetail({super.key, @QueryParam('businessId') this.businessId = ''});

  @override
  void didPopNext() {}

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(businessDetailViewModel(businessId));
    final router = AutoRouter.of(context);

    useEffect(() {
      void onRouteChange() => viewModel.fetchBusinessInformation(businessId);
      router.addListener(onRouteChange);
      viewModel.fetchBusinessInformation(businessId);
      return () => router.removeListener(onRouteChange);
    }, [businessId]);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, viewModel, ref),
          Expanded(child: _buildDetails(context, viewModel)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, BusinessDetailViewModel viewModel, WidgetRef ref) {
    return Container(
      height: 320.h,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: viewModel.businessInfo?.issuerSignatureUrl != null
              ? NetworkImage(viewModel.businessInfo!.logoUrl!)
              : AssetImage(Assets.png.payvidenceLogo.path) as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconButton(context, Assets.svg.backArrow, () => Navigator.of(context).pop()),
              _iconButton(context, Assets.svg.delete, () => _buildConfirmDeleteBottomSheet(context, viewModel, ref)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton(BuildContext context, String asset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        width: 48.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(56.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: SvgPicture.asset(asset),
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context, BusinessDetailViewModel viewModel) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      children: [
        SizedBox(height: 24.h),
        _buildTextOrShimmer(context, viewModel.isLoading, viewModel.businessInfo?.name ?? '', 24.h, 150.w, 22.sp),
        SizedBox(height: 12.h),
        _buildAddressRow(context, viewModel),
        SizedBox(height: 24.h),
        _buildInfoSection(context, 'Phone number', viewModel.businessInfo?.phoneNumber ?? 'N/A', viewModel.isLoading),
        SizedBox(height: 16.h),
        _buildInfoSection(context, 'Receipts issuer', viewModel.businessInfo?.issuer ?? 'N/A', viewModel.isLoading),
        SizedBox(height: 16.h),
        _buildInfoSection(context, 'Issuer role', viewModel.businessInfo?.issuerRole ?? 'N/A', viewModel.isLoading),
        SizedBox(height: 16.h),
        _buildSignature(context, viewModel),
        SizedBox(height: 32.h),
        _buildBankDetails(context, viewModel),
        SizedBox(height: 40.h),
        _buildButtons(context),
        SizedBox(height: 14.h),
      ],
    );
  }

  Widget _buildAddressRow(BuildContext context, BusinessDetailViewModel viewModel) {
    return viewModel.isLoading
        ? CustomShimmer(height: 16.h, width: 200.w)
        : Row(
      children: [
        SvgPicture.asset(Assets.svg.location),
        SizedBox(width: 6.w),
        Text(viewModel.businessInfo?.address ?? '', style: Theme.of(context).textTheme.displaySmall),
      ],
    );
  }

  Widget _buildTextOrShimmer(
      BuildContext context, bool isLoading, String text, double shimmerHeight, double shimmerWidth, double? fontSize) {
    return isLoading
        ? CustomShimmer(height: shimmerHeight, width: shimmerWidth)
        : Text(text, style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: fontSize));
  }

  Widget _buildInfoSection(BuildContext context, String title, String value, bool isLoading) {
    return isLoading
        ? CustomShimmer(height: 16.h, width: double.infinity)
        : Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.displaySmall),
        Text(value, style: Theme.of(context).textTheme.displaySmall),
      ],
    );
  }

  Widget _buildSignature(BuildContext context, BusinessDetailViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Issuer signature', style: Theme.of(context).textTheme.displaySmall),
        Container(
          height: 64.h,
          width: 120.w,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: viewModel.businessInfo?.issuerSignatureUrl != null
                  ? NetworkImage(viewModel.businessInfo!.issuerSignatureUrl!)
                  : AssetImage(Assets.png.signature.path) as ImageProvider,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBankDetails(BuildContext context, BusinessDetailViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bank details', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: 18.sp)),
        SizedBox(height: 20.h),
        _buildInfoSection(context, 'Bank name', viewModel.businessInfo?.bankName ?? 'N/A', viewModel.isLoading),
        SizedBox(height: 16.h),
        _buildInfoSection(context, 'Account number', viewModel.businessInfo?.accountNumber ?? 'N/A', viewModel.isLoading),
        SizedBox(height: 16.h),
        _buildInfoSection(context, 'Account name', viewModel.businessInfo?.accountName ?? 'N/A', viewModel.isLoading),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        AppButton(
          buttonText: 'Edit business details',
          onPressed: () => locator<PayvidenceAppRouter>().navigate(EditBusinessRoute(businessId: businessId)),
        ),
        SizedBox(height: 8.h),
        AppButton(
          buttonText: 'Edit bank details',
          onPressed: () {
            locator<PayvidenceAppRouter>().navigate(EditBankDetailsRoute(businessId: businessId));
          },
          backgroundColor: Colors.white,
          textColor: primaryColor2,
        ),
        SizedBox(height: 14.h),
      ],
    );
  }

  Future<dynamic> _buildConfirmDeleteBottomSheet(BuildContext context, BusinessDetailViewModel viewModel, WidgetRef ref) {
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          height: 368.h,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(40.r))),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              children: [
                SizedBox(height: 38.h),
                Text('Confirm delete', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22.sp)),
                SizedBox(height: 12.h),
                Text('Are you sure you want to delete this business?\n\nAll details and statistics will be gone.',
                    textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall),
                SizedBox(height: 47.h),
                AppButton(buttonText: 'Delete business', onPressed: () {
                  viewModel.deleteBusiness(
                    navigateOnSuccess: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      // locator<PayvidenceAppRouter>().back();
                    },
                  );
                }, backgroundColor: appRed),
                SizedBox(height: 8.h),
                AppButton(buttonText: 'Cancel', onPressed: () {
                  Navigator.pop(context);
                }, backgroundColor: Colors.white,textColor: Colors.black,),
              ],
            ),
          ),
        );
      },
    );
  }
}