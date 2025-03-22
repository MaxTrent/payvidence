import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import '../components/subscription_card.dart';


@RoutePage(name: 'ChooseSubscriptionPlanRoute')
class ChooseSubscriptionPlan extends StatelessWidget {
  const ChooseSubscriptionPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose subscription plan', style: Theme.of(context).textTheme.displayLarge,),
            SizedBox(height: 24.h,),
            SubscriptionCard(subscriptionTier: 'Starter subscription plan', price: '0', active: true,),
            SizedBox(height: 24.h,),
            SubscriptionCard(recommended: true, subscriptionTier: 'Business subscription plan', price: '10,000'),
            SizedBox(height: 24.h,),
            GestureDetector(
                onTap: ()=> locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.subscriptionPlans),
                child: SubscriptionCard(subscriptionTier: 'Premium subscription plan', price: '50,000')),

          ],
        ),
      ),

    );
  }
}
