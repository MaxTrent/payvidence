import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/subscription_card.dart';
import '../../components/app_button.dart';
import '../../components/plan_list.dart';
import '../../constants/app_colors.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../onboarding/onboarding.dart';


@RoutePage(name: 'SubscriptionPlansRoute')
class SubscriptionPlans extends HookConsumerWidget {
  const SubscriptionPlans({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final selectedTier = useState<String>('Starter');

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: AppButton(
          buttonText: 'Renew ${selectedTier.value.toString()} plan',
          onPressed: () {
            locator<PayvidenceAppRouter>().popUntil(
                    (route) => route is OnboardingScreen);
            locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.login);
          }),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Subscription plans', style: Theme.of(context).textTheme.displayLarge,),
            SizedBox(height: 24.h,),
            Row(
              children: [
                _buildTierButton(context: context, tier: 'Starter', isSelected: selectedTier.value == 'Starter',
                onTap: () => selectedTier.value = 'Starter'),
                SizedBox(width: 12.w),
                _buildTierButton(context: context, tier: 'Business', isSelected: selectedTier.value == 'Business',
                    onTap: () => selectedTier.value = 'Business'),

                SizedBox(width: 12.w),
                _buildTierButton(context: context, tier: 'Premium', isSelected: selectedTier.value == 'Premium',
                    onTap: () => selectedTier.value = 'Premium'),

              ],
            ),
            SizedBox(
              height: 24.h,
            ),
            Expanded(child: _buildSubscriptionContent(context, selectedTier.value)),

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

  Widget _buildSubscriptionContent(BuildContext context, String tier) {
    switch (tier) {
      case 'Starter':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubscriptionCard(
              subscriptionTier: 'Starter subscription plan',
              price: '0', // Example price
              active: true,
            ),
            SizedBox(height: 40.h),
            Text(
              'What’s embedded in starter plan?',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontWeight: FontWeight.w400, fontSize: 20.sp),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView(
                children: [
                  PlanList(description: 'Business accounts allowed', status: '5'),
                  PlanList(description: 'Receipt generation per month', status: 'Unlimited'),
                  PlanList(description: 'Invoice generation per month', status: 'Unlimited'),
                  PlanList(description: 'Sales report', status: 'Yes'),
                  PlanList(description: 'Receipts printing', status: 'Yes'),
                  PlanList(description: 'Inventory management', status: 'Yes'),
                  PlanList(description: 'PDF and CSV export', status: 'Yes'),
                  PlanList(description: 'Client management', status: 'Yes'),
                  PlanList(description: 'Brand management', status: 'Yes'),
                  PlanList(description: 'Letterhead transactions', status: 'Yes'),
                  PlanList(description: 'Payment instructions', status: 'Yes'),
                  PlanList(description: 'Advanced reporting and analytics', status: 'Yes'),
                  PlanList(description: 'Templates', status: 'Yes'),
                ],
              ),
            ),
          ],
        );
      case 'Business':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubscriptionCard(
              subscriptionTier: 'Business subscription plan',
              price: '10000', // Example price
              active: false,
            ),
            SizedBox(height: 40.h),
            Text(
              'What’s embedded in business plan?',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontWeight: FontWeight.w400, fontSize: 20.sp),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView(
                children: [
                  PlanList(description: 'Business accounts allowed', status: '5'),
                  PlanList(description: 'Receipt generation per month', status: 'Unlimited'),
                  PlanList(description: 'Invoice generation per month', status: 'Unlimited'),
                  PlanList(description: 'Sales report', status: 'Yes'),
                  PlanList(description: 'Receipts printing', status: 'Yes'),
                  PlanList(description: 'Inventory management', status: 'Yes'),
                  PlanList(description: 'PDF and CSV export', status: 'Yes'),
                  PlanList(description: 'Client management', status: 'Yes'),
                  PlanList(description: 'Brand management', status: 'Yes'),
                  PlanList(description: 'Letterhead transactions', status: 'Yes'),
                  PlanList(description: 'Payment instructions', status: 'Yes'),
                  PlanList(description: 'Advanced reporting and analytics', status: 'Yes'),
                  PlanList(description: 'Templates', status: 'Yes'),],
              ),
            ),
          ],
        );
      case 'Premium':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubscriptionCard(
              subscriptionTier: 'Premium subscription plan',
              price: '50000', // Example price
              active: true,
            ),
            SizedBox(height: 40.h),
            Text(
              'What’s embedded in premium plan?',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontWeight: FontWeight.w400, fontSize: 20.sp),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView(
                children: [
                  PlanList(description: 'Business accounts allowed', status: '5'),
                  PlanList(description: 'Receipt generation per month', status: 'Unlimited'),
                  PlanList(description: 'Invoice generation per month', status: 'Unlimited'),
                  PlanList(description: 'Sales report', status: 'Yes'),
                  PlanList(description: 'Receipts printing', status: 'Yes'),
                  PlanList(description: 'Inventory management', status: 'Yes'),
                  PlanList(description: 'PDF and CSV export', status: 'Yes'),
                  PlanList(description: 'Client management', status: 'Yes'),
                  PlanList(description: 'Brand management', status: 'Yes'),
                  PlanList(description: 'Letterhead transactions', status: 'Yes'),
                  PlanList(description: 'Payment instructions', status: 'Yes'),
                  PlanList(description: 'Advanced reporting and analytics', status: 'Yes'),
                  PlanList(description: 'Templates', status: 'Yes'),
                ],
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

