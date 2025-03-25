import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/subscription_card.dart';
import 'package:payvidence/utilities/extensions.dart';
import '../../components/app_button.dart';
import '../../components/custom_shimmer.dart';
import '../../components/plan_list.dart';
import '../../constants/app_colors.dart';
import '../../model/plan_model.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../choose_subscription_plan/choose_subscription_plan_vm.dart';
import '../onboarding/onboarding.dart';

@RoutePage(name: 'SubscriptionPlansRoute')
class SubscriptionPlans extends HookConsumerWidget {
  final String planId;

  const SubscriptionPlans({super.key, @QueryParam('planId') this.planId = ''});

  @override
  Widget build(BuildContext context, ref) {
    final selectedTier = useState<String>('');
    final viewModel = ref.watch(chooseSubscriptionPlanViewModel);

    useEffect(() {
      if (viewModel.plans.isEmpty) {
        viewModel.fetchPlans().then((_) {
          if (planId.isNotEmpty) {
            final initialPlan = viewModel.plans.firstWhere(
              (plan) => plan.id == planId,
              orElse: () => viewModel.plans.first,
            );
            selectedTier.value = initialPlan.name;
          }
        });
      } else if (planId.isNotEmpty) {
        final initialPlan = viewModel.plans.firstWhere(
          (plan) => plan.id == planId,
          orElse: () => viewModel.plans.first,
        );
        selectedTier.value = initialPlan.name;
      }
      return null;
    }, [planId]);

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: AppButton(
          buttonText: selectedTier.value.isEmpty
              ? 'Renew plan'
              : 'Renew ${selectedTier.value} plan',
          onPressed: () {
            locator<PayvidenceAppRouter>()
                .popUntil((route) => route is OnboardingScreen);
            locator<PayvidenceAppRouter>()
                .navigateNamed(PayvidenceRoutes.login);
          }),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Subscription plans',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(
              height: 24.h,
            ),
            viewModel.isLoading
                ? Row(
                    children: [
                      CustomShimmer(width: 83.w, height: 45.h),
                      SizedBox(width: 12.w),
                      CustomShimmer(width: 83.w, height: 45.h),
                      SizedBox(width: 12.w),
                      CustomShimmer(width: 83.w, height: 45.h),
                    ],
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: viewModel.plans.map((plan) {
                        return Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: _buildTierButton(
                            context: context,
                            tier: plan.name,
                            isSelected: selectedTier.value == plan.name,
                            onTap: () => selectedTier.value = plan.name,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
            SizedBox(
              height: 24.h,
            ),
            Expanded(
              child: viewModel.isLoading
                  ? _buildLoadingShimmer()
                  : viewModel.plans.isEmpty
                      ? const Center(child: Text('No plans available'))
                      : _buildSubscriptionContent(
                          context,
                          viewModel.plans.firstWhere(
                            (plan) => plan.name == selectedTier.value,
                            orElse: () => viewModel.plans.first,
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierButton({
    required BuildContext context,
    required String tier,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45.h,
        width: 83.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(43.r),
          color: isSelected ? primaryColor2 : Colors.transparent,
          border: Border.all(
            color: isSelected ? primaryColor2 : Colors.white,
          ),
        ),
        child: Center(
          child: Text(
            tier,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: isSelected ? Colors.white : Colors.black,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomShimmer(height: 150.h),
        SizedBox(height: 40.h),
        CustomShimmer(height: 20.h),
        SizedBox(height: 20.h),
        CustomShimmer(height: 200.h),
      ],
    );
  }

  Widget _buildSubscriptionContent(BuildContext context, Plan plan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubscriptionCard(
          subscriptionTier: plan.name,
          price:
              '₦${plan.amount.toString().toCommaSeparated}',
          active: true,
          recommended: plan.isRecommended,
        ),
        SizedBox(height: 40.h),
        Text(
          'What’s embedded in ${plan.name.toLowerCase()}?',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 20.sp,
              ),
        ),
        SizedBox(height: 20.h),
        Expanded(
          child: ListView(
            children: [
              PlanList(
                  description: 'Business accounts allowed',
                  status: plan.businessAccountsAllowed.toString()),
              PlanList(
                  description: 'Receipt generation per month',
                  status: plan.receiptGenerationPerMonth.toString()),
              PlanList(
                  description: 'Invoice generation per month',
                  status: plan.invoiceGenerationPerMonth.toString()),
              PlanList(
                  description: 'Sales report',
                  status: plan.salesReport.toString()),
              PlanList(
                  description: 'Receipts printing',
                  status: plan.receiptPrinting.toString()),
              PlanList(
                  description: 'Inventory management',
                  status: plan.inventoryManagement.toString()),
              PlanList(
                  description: 'PDF and CSV export',
                  status: plan.pdfCsvExport.toString()),
              PlanList(description: 'Client management', status: plan.clientManagement.toString()),
              PlanList(description: 'Brand management', status: plan.brandManagement.toString()),
              PlanList(description: 'Letterhead transactions', status: plan.letterheadTransaction.toString()),
              PlanList(description: 'Payment instructions', status: plan.paymentInstructions.toString()),
              PlanList(
                  description: 'Advanced reporting and analytics',
                  status: plan.advancedReportingAndAnalytics.toString()),
              PlanList(description: 'Templates', status: plan.templates.toString()),
            ],
          ),
        ),
      ],
    );
  }
}
