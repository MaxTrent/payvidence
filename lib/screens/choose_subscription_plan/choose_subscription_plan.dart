import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/extensions.dart';
import '../../components/custom_shimmer.dart';
import '../../components/subscription_card.dart';
import '../../routes/payvidence_app_router.gr.dart';
import 'choose_subscription_plan_vm.dart';


@RoutePage(name: 'ChooseSubscriptionPlanRoute')
class ChooseSubscriptionPlan extends HookConsumerWidget {
  ChooseSubscriptionPlan({super.key});

  @override
  Widget build(BuildContext context, ref) {


    final viewModel = ref.watch(chooseSubscriptionPlanViewModel);

    useEffect(() {
      Future.delayed(Duration.zero, () {
        viewModel.fetchPlans();
      });
      return null;
    }, []);


    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose subscription plan', style: Theme.of(context).textTheme.displayLarge,),
            SizedBox(height: 24.h,),
            if (viewModel.isLoading) ...[
              CustomShimmer(height: 108.h),
              SizedBox(height: 24.h),
              CustomShimmer(height: 108.h),
              SizedBox(height: 24.h),
              CustomShimmer(height: 108.h),
              SizedBox(height: 24.h),
              CustomShimmer(height: 108.h),
            ] else ...[
              ...viewModel.plans.map(
                    (plan) => Padding(
                  padding: EdgeInsets.only(bottom: 24.h), // Space between cards
                  child: GestureDetector(
                    onTap: () {
                      locator<PayvidenceAppRouter>().push(
                          SubscriptionPlansRoute(planId: plan.id));},
                    child: SubscriptionCard(
                      subscriptionTier: plan.name,
                      price: plan.amount.toString().toCommaSeparated(),
                      // recommended: plan.isRecommended,
                      active: false,
                    ),
                  ),
                ),
              ),
            ]
            // SubscriptionCard(subscriptionTier: 'Starter subscription plan', price: '0', active: true,),
            // SizedBox(height: 24.h,),
            // SubscriptionCard(recommended: true, subscriptionTier: 'Business subscription plan', price: '10,000'),
            // SizedBox(height: 24.h,),
            // GestureDetector(
            //     onTap: ()=> locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.subscriptionPlans),
            //     child: SubscriptionCard(subscriptionTier: 'Premium subscription plan', price: '50,000')),

          ],
        ),
      ),

    );
  }
}
