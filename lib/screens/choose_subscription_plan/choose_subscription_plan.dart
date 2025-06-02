import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/extensions.dart';
import '../../components/custom_shimmer.dart';
import '../../components/subscription_card.dart';
import '../../routes/payvidence_app_router.gr.dart';
import 'choose_subscription_plan_vm.dart';
import '../../utilities/responsive.dart';
import '../../utilities/responsive_wrapper.dart';

@RoutePage(name: 'ChooseSubscriptionPlanRoute')
class ChooseSubscriptionPlan extends HookConsumerWidget {
  const ChooseSubscriptionPlan({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final viewModel = ref.watch(chooseSubscriptionPlanViewModel);
    final responsiveData = ResponsiveInherited.of(context);

    useEffect(() {
      Future.delayed(Duration.zero, () {
        viewModel.fetchPlans();
      });
      return null;
    }, []);

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
          child: ListView(
            children: [
              Text(
                'Choose subscription plan',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: responsiveData.scaleHeight(24),
              ),
              if (viewModel.isLoading) ...[
                CustomShimmer(height: responsiveData.scaleHeight(108)),
                SizedBox(height: responsiveData.scaleHeight(24)),
                CustomShimmer(height: responsiveData.scaleHeight(108)),
                SizedBox(height: responsiveData.scaleHeight(24)),
                CustomShimmer(height: responsiveData.scaleHeight(108)),
                SizedBox(height: responsiveData.scaleHeight(24)),
                CustomShimmer(height: responsiveData.scaleHeight(108)),
              ] else ...[
                ...viewModel.plans.map(
                      (plan) => Padding(
                    padding: EdgeInsets.only(bottom: responsiveData.scaleHeight(24)),
                    child: GestureDetector(
                      onTap: () {
                        locator<PayvidenceAppRouter>()
                            .push(SubscriptionPlansRoute(planId: plan.id));
                      },
                      child: SubscriptionCard(
                        subscriptionTier: plan.name,
                        price: plan.amount.toString().toCommaSeparated(),
                        recommended: plan.isRecommended,
                        active: false,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}