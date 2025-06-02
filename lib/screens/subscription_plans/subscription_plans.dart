import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/components/subscription_card.dart';
import 'package:payvidence/screens/subscription_plans/subscription_plans_vm.dart';
import 'package:payvidence/utilities/extensions.dart';
import 'package:payvidence/utilities/responsive.dart';
import 'package:payvidence/utilities/responsive_wrapper.dart';
import '../../components/app_button.dart';
import '../../components/custom_shimmer.dart';
import '../../components/plan_list.dart';
import '../../constants/app_colors.dart';
import '../../model/plan_model.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../../utilities/theme_mode.dart';
import '../choose_subscription_plan/choose_subscription_plan_vm.dart';

@RoutePage(name: 'SubscriptionPlansRoute')
class SubscriptionPlans extends HookConsumerWidget {
  final String planId;

  const SubscriptionPlans({super.key, @QueryParam('planId') this.planId = ''});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTier = useState<String>('');
    final choosePlanVm = ref.watch(chooseSubscriptionPlanViewModel);
    final subscriptionPlansVm = ref.watch(subscriptionPlansViewModelProvider);
    final theme = useThemeMode();
    final isDarkMode = theme.mode == ThemeMode.dark;
    final responsiveData = ResponsiveInherited.of(context); // Define here, inside build

    void setInitialPlan() {
      if (planId.isNotEmpty && choosePlanVm.plans.isNotEmpty) {
        selectedTier.value = choosePlanVm.plans
            .firstWhere(
              (plan) => plan.id == planId,
          orElse: () => choosePlanVm.plans.first,
        )
            .name;
      }
    }

    useEffect(() {
      if (choosePlanVm.plans.isEmpty) {
        choosePlanVm.fetchPlans().then((_) => setInitialPlan());
      } else {
        setInitialPlan();
      }
      return null;
    }, [planId]);

    return ResponsiveWrapper(
      child: Scaffold(
        appBar: AppBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: responsiveData.scaleHeight(8)),
          child: SizedBox(
            // width: 350.w, // Commented out as it was not active
            child: AppButton(
              isProcessing: subscriptionPlansVm.isLoading,
              buttonText: selectedTier.value.isEmpty
                  ? 'Choose a plan'
                  : 'Continue with ${selectedTier.value} plan',
              onPressed: selectedTier.value.isEmpty || subscriptionPlansVm.isLoading
                  ? null
                  : () {
                final selectedPlan = choosePlanVm.plans.firstWhere(
                      (plan) => plan.name == selectedTier.value,
                  orElse: () => choosePlanVm.plans.first,
                );
                subscriptionPlansVm.createSubscription(
                  planId: selectedPlan.id,
                  navigateOnSuccess: (paymentLink, callbackUrl, cancelAction) {
                    locator<PayvidenceAppRouter>().push(PaymentWebViewRoute(
                        paymentLink: paymentLink,
                        callbackUrl: callbackUrl,
                        cancelAction: cancelAction));
                  },
                );
              },
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsiveData.paddingHorizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Subscription plans',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: responsiveData.scaleHeight(24)),
                choosePlanVm.isLoading
                    ? Row(
                  children: [
                    CustomShimmer(
                        width: responsiveData.scaleWidth(83),
                        height: responsiveData.scaleHeight(45)),
                    SizedBox(width: responsiveData.scaleWidth(12)),
                    CustomShimmer(
                        width: responsiveData.scaleWidth(83),
                        height: responsiveData.scaleHeight(45)),
                    SizedBox(width: responsiveData.scaleWidth(12)),
                    CustomShimmer(
                        width: responsiveData.scaleWidth(83),
                        height: responsiveData.scaleHeight(45)),
                  ],
                )
                    : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: choosePlanVm.plans.map((plan) {
                      return Padding(
                        padding: EdgeInsets.only(right: responsiveData.scaleWidth(12)),
                        child: _buildTierButton(
                          context: context,
                          tier: plan.name,
                          isSelected: selectedTier.value == plan.name,
                          onTap: () => selectedTier.value = plan.name,
                          isDarkMode: isDarkMode,
                          responsiveData: responsiveData, // Pass responsiveData
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: responsiveData.scaleHeight(24)),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: responsiveData.scaleHeight(80)),
                    child: choosePlanVm.isLoading
                        ? _buildLoadingShimmer(responsiveData) // Pass responsiveData
                        : choosePlanVm.plans.isEmpty
                        ? const Center(child: Text('No plans available'))
                        : _buildSubscriptionContent(
                      context,
                      choosePlanVm.plans.firstWhere(
                            (plan) => plan.name == selectedTier.value,
                        orElse: () => choosePlanVm.plans.first,
                      ),
                      responsiveData, // Pass responsiveData
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTierButton({
    required BuildContext context,
    required String tier,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDarkMode,
    required ResponsiveData responsiveData, // Receive as parameter
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: responsiveData.scaleHeight(45),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(responsiveData.smallRadius * 2.15), // Approx 43.r
          color: isSelected ? primaryColor2 : Colors.transparent,
          border: Border.all(
            color: isSelected ? primaryColor2 : isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: responsiveData.scaleWidth(16), vertical: responsiveData.scaleHeight(12)),
          child: Center(
            child: Text(
              tier,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: isSelected ? Colors.white : isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer(ResponsiveData responsiveData) { // Receive as parameter
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomShimmer(height: responsiveData.scaleHeight(150)),
        SizedBox(height: responsiveData.scaleHeight(40)),
        CustomShimmer(height: responsiveData.scaleHeight(20)),
        SizedBox(height: responsiveData.scaleHeight(20)),
        CustomShimmer(height: responsiveData.scaleHeight(200)),
      ],
    );
  }

  Widget _buildSubscriptionContent(
      BuildContext context, Plan plan, ResponsiveData responsiveData) { // Receive as parameter
    return ListView(
      children: [
        SubscriptionCard(
          subscriptionTier: plan.name,
          price: plan.amount.toStringAsFixed(0).toCommaSeparated(),
          active: true,
          recommended: plan.isRecommended,
          checkOut: false,
        ),
        SizedBox(height: responsiveData.scaleHeight(40)),
        Text(
          'What’s embedded in ${plan.name.toLowerCase()}?',
          style: Theme.of(context).textTheme.displayMedium!.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: Responsive.fontSize(context, 20),
          ),
        ),
        SizedBox(height: responsiveData.scaleHeight(20)),
        PlanList(
            description: 'Business accounts allowed',
            status: plan.businessAccountsAllowed.toString()),
        PlanList(
            description: 'Receipt generation per month',
            status: plan.receiptGenerationPerMonth.toString()),
        PlanList(
            description: 'Invoice generation per month',
            status: plan.invoiceGenerationPerMonth.toString()),
        PlanList(description: 'Sales report', status: plan.salesReport ? 'Yes' : 'No'),
        PlanList(description: 'Receipt sharing', status: plan.receiptSharing ? 'Yes' : 'No'),
        PlanList(description: 'Receipts printing', status: plan.receiptPrinting ? 'Yes' : 'No'),
        PlanList(
            description: 'Inventory management',
            status: plan.inventoryManagement ? 'Yes' : 'No'),
        PlanList(description: 'PDF and CSV export', status: plan.pdfCsvExport ? 'Yes' : 'No'),
        PlanList(description: 'Client management', status: plan.clientManagement ? 'Yes' : 'No'),
        PlanList(description: 'Brand management', status: plan.brandManagement ? 'Yes' : 'No'),
        PlanList(
            description: 'Letterhead transactions',
            status: plan.letterheadTransaction ? 'Yes' : 'No'),
        PlanList(
            description: 'Payment instructions',
            status: plan.paymentInstructions ? 'Yes' : 'No'),
        PlanList(
            description: 'Advanced reporting and analytics',
            status: plan.advancedReportingAndAnalytics ? 'Yes' : 'No'),
        PlanList(description: 'Templates', status: plan.templates.toString()),
      ],
    );
  }
}