import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';
import 'package:payvidence/screens/business_detail/business_detail_vm.dart';
import 'package:payvidence/data/local/session_constants.dart';
import 'package:payvidence/data/local/session_manager.dart';
import 'package:payvidence/providers/business_providers/get_all_business_provider.dart';
import 'package:payvidence/providers/business_providers/current_business_provider.dart';
import '../../components/app_button.dart';
import '../../components/custom_shimmer.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/responsive.dart';
import '../../utilities/responsive_wrapper.dart';

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
      Future(() => viewModel.fetchBusinessInformation(businessId));
      return null;
    }, [businessId]);

    return ResponsiveWrapper(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, viewModel, ref),
            Expanded(child: _buildDetails(context, viewModel)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, BusinessDetailViewModel viewModel, WidgetRef ref) {
    final responsiveData = ResponsiveInherited.of(context);
    return Container(
      height: responsiveData.scaleHeight(320),
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
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
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
    final responsiveData = ResponsiveInherited.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: responsiveData.scaleHeight(48),
        width: responsiveData.scaleHeight(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(responsiveData.largeRadius),
        ),
        child: Padding(
          padding: EdgeInsets.all(responsiveData.scaleHeight(12)),
          child: SvgPicture.asset(asset),
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context, BusinessDetailViewModel viewModel) {
    final responsiveData = ResponsiveInherited.of(context);
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
      children: [
        SizedBox(height: responsiveData.scaleHeight(24)),
        _buildTextOrShimmer(context, viewModel.isLoading, viewModel.businessInfo?.name ?? '', responsiveData.scaleHeight(24), responsiveData.scaleWidth(150), Responsive.fontSize(context, 22)),
        SizedBox(height: responsiveData.scaleHeight(12)),
        _buildAddressRow(context, viewModel),
        SizedBox(height: responsiveData.scaleHeight(24)),
        _buildInfoSection(context, 'Phone number', viewModel.businessInfo?.phoneNumber ?? 'N/A', viewModel.isLoading),
        SizedBox(height: responsiveData.scaleHeight(16)),
        _buildInfoSection(context, 'Receipts issuer', viewModel.businessInfo?.issuer ?? 'N/A', viewModel.isLoading),
        SizedBox(height: responsiveData.scaleHeight(16)),
        _buildInfoSection(context, 'Issuer role', viewModel.businessInfo?.issuerRole ?? 'N/A', viewModel.isLoading),
        SizedBox(height: responsiveData.scaleHeight(16)),
        _buildSignature(context, viewModel),
        SizedBox(height: responsiveData.scaleHeight(32)),
        _buildBankDetails(context, viewModel),
        SizedBox(height: responsiveData.scaleHeight(40)),
        _buildButtons(context),
        SizedBox(height: responsiveData.scaleHeight(14)),
      ],
    );
  }

  Widget _buildAddressRow(BuildContext context, BusinessDetailViewModel viewModel) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final responsiveData = ResponsiveInherited.of(context);

    return viewModel.isLoading
        ? CustomShimmer(height: responsiveData.scaleHeight(16), width: responsiveData.scaleWidth(200))
        : Row(
      children: [
        SvgPicture.asset(Assets.svg.location,
            colorFilter: ColorFilter.mode(isDarkMode ? Colors.white : Colors.black, BlendMode.srcIn)),
        SizedBox(width: responsiveData.scaleWidth(6)),
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
    final responsiveData = ResponsiveInherited.of(context);
    return isLoading
        ? CustomShimmer(height: responsiveData.scaleHeight(16), width: double.infinity)
        : Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.displaySmall),
        Text(value, style: Theme.of(context).textTheme.displaySmall),
      ],
    );
  }

  Widget _buildSignature(BuildContext context, BusinessDetailViewModel viewModel) {
    final responsiveData = ResponsiveInherited.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Issuer signature', style: Theme.of(context).textTheme.displaySmall),
        Container(
          height: responsiveData.scaleHeight(64),
          width: responsiveData.scaleWidth(120),
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
    final responsiveData = ResponsiveInherited.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bank details', style: Theme.of(context).textTheme.displaySmall?.copyWith(fontSize: Responsive.fontSize(context, 18))),
        SizedBox(height: responsiveData.scaleHeight(20)),
        _buildInfoSection(context, 'Bank name', viewModel.businessInfo?.bankName ?? 'N/A', viewModel.isLoading),
        SizedBox(height: responsiveData.scaleHeight(16)),
        _buildInfoSection(context, 'Account number', viewModel.businessInfo?.accountNumber ?? 'N/A', viewModel.isLoading),
        SizedBox(height: responsiveData.scaleHeight(16)),
        _buildInfoSection(context, 'Account name', viewModel.businessInfo?.accountName ?? 'N/A', viewModel.isLoading),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    final responsiveData = ResponsiveInherited.of(context);
    return Column(
      children: [
        AppButton(
          buttonText: 'Edit business details',
          onPressed: () => locator<PayvidenceAppRouter>().navigate(EditBusinessRoute(businessId: businessId)),
        ),
        SizedBox(height: responsiveData.scaleHeight(8)),
        AppButton(
          buttonText: 'Edit bank details',
          onPressed: () {
            locator<PayvidenceAppRouter>().navigate(EditBankDetailsRoute(businessId: businessId));
          },
          backgroundColor: Colors.transparent,
          textColor: primaryColor2,
        ),
        SizedBox(height: responsiveData.scaleHeight(14)),
      ],
    );
  }

  Future<dynamic> _buildConfirmDeleteBottomSheet(BuildContext context, BusinessDetailViewModel viewModel, WidgetRef ref) {
    final responsiveData = ResponsiveInherited.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          height: responsiveData.scaleHeight(368),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF2C2C2C) : Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(responsiveData.largeRadius)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: responsiveData.paddingHorizontal, vertical: responsiveData.scaleHeight(10)),
            child: Column(
              children: [
                SizedBox(height: responsiveData.scaleHeight(38)),
                Text('Confirm delete',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: Responsive.fontSize(context, 22))),
                SizedBox(height: responsiveData.scaleHeight(12)),
                Text('Are you sure you want to delete this business?\n\nAll details and statistics will be gone.',
                    textAlign: TextAlign.center, style: Theme.of(context).textTheme.displaySmall),
                SizedBox(height: responsiveData.scaleHeight(47)),
                AppButton(
                  buttonText: 'Delete business',
                  onPressed: () {
                    Navigator.of(context).pop(); // Close bottom sheet first
                    viewModel.deleteBusiness(
                      navigateOnSuccess: () {
                        // Check if deleted business was the current one and switch to next available
                        final currentBusiness = ref.read(getCurrentBusinessProvider);
                        if (currentBusiness?.id == businessId) {
                          // Get fresh business list and switch to first available
                          Future.microtask(() async {
                            await ref.refresh(getAllBusinessProvider.future);
                            final allBusinesses = ref.read(getAllBusinessProvider).value ?? [];
                            if (allBusinesses.isNotEmpty) {
                              ref.read(getCurrentBusinessProvider.notifier).setCurrentBusiness(allBusinesses.first);
                              locator<SessionManager>().save(key: SessionConstants.businessId, value: allBusinesses.first.id);
                            }
                          });
                        }
                        locator<PayvidenceAppRouter>().navigate(const AllBusinessesRoute());
                      },
                    );
                  },
                  backgroundColor: appRed,
                ),
                SizedBox(height: responsiveData.scaleHeight(8)),
                AppButton(
                  buttonText: 'Cancel',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.transparent,
                  textColor: isDarkMode ? Colors.white : Colors.black,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}