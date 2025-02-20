import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import '../../components/app_button.dart';
import '../../constants/app_colors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.gr.dart';
import 'onboarding_vm.dart';


@RoutePage(name: 'OnboardingScreenRoute')
class OnboardingScreen extends HookConsumerWidget {
  static String routeName = "/onboardingScreen";
  OnboardingScreen({super.key});

  final _pageController = PageController();

  @override
  Widget build(BuildContext context, ref) {
    // final viewModel = OnboardingScreenViewModel(ref);
    final viewModel = ref.watch(onboardingScreenViewModelProvider);

    return Scaffold(
      backgroundColor: scaffoldBackground,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
                allowImplicitScrolling: true,
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: _pageController,
                onPageChanged: (index) {
                  viewModel.changeIndex(index);
                },
                children: [
                  OnboardingPage(
                    text: 'Your digital transaction evidence',
                    subtext:
                        'Easily issue receipts, invoices, and purchase orders to clients on the go.',
                    image: Assets.png.onboarding1.path,
                  ),
                  OnboardingPage(
                    text: 'Simplify your inventory management',
                    subtext:
                        'Manage all your transactions, invoices, receipts, and sales reports in one centralized location.',
                    image: Assets.png.onboarding2.path,
                  ),
                  OnboardingPage(
                    text: 'Gain Insights with Analytics',
                    subtext:
                        'Access reports to understand sales performance and make smarter decisions.',
                    image: Assets.png.onboarding3.path,
                  )
                ]),
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: CustomCurveClipper(),
                child: Container(
                  height: 310.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: scaffoldBackground,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black, // Shadow color with transparency
                        offset: Offset(0, -2.h), // Horizontal and vertical offset
                        blurRadius: 4.r, // Amount of blur
                        spreadRadius: 10, // Spread of the shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 62.h,
                        ),
                        PageIndicator(
                          viewModel: viewModel,
                        ),
                        SizedBox(
                          height: 45.h,
                        ),
                        AppButton(buttonText: 'Get started', onPressed: () {
                          context.router.push(const CreateAccountRoute());
                        },),
                        SizedBox(height: 26.h),
                        GestureDetector(
                          onTap: (){
                            locator<PayvidenceAppRouter>().navigateNamed(PayvidenceRoutes.login);
                            // context.router.push(const LoginRoute());
                          },
                          child: Text(
                            'Log in instead',
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(color: primaryColor2),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class PageIndicator extends StatelessWidget {
  const PageIndicator({
    required this.viewModel,
    super.key,
  });

  final OnboardingScreenViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 6.w),
            height: 8.h,
            width: viewModel.currentPageIndex == index ? 20.w : 8.h,
            decoration: BoxDecoration(
                color: viewModel.currentPageIndex == index
                    ? primaryColor2
                    : primaryColor2.withOpacity(0.4),
                borderRadius: BorderRadius.circular(32.r)),
          );
        }));
  }
}

class OnboardingPage extends StatelessWidget {
  OnboardingPage({
    required this.image,
    required this.subtext,
    required this.text,
    super.key,
  });

  String text;
  String subtext;
  String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 40.h,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(subtext,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.w400, color: const Color(0xff333030))),
          SizedBox(
            height: 85.h,
          ),
          Image.asset(image)
        ],
      ),
    );
  }
}

class CustomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start at top left
    path.moveTo(0, 0); // Start at the top left corner

    // Create an inward curved top edge
    path.quadraticBezierTo(
        size.width / 2, // Control point x
        40.h, // Control point y (pulls the curve downward)
        size.width, // End point x
        0 // End point y (back to the top at the end)
        );

    // Draw right side
    path.lineTo(size.width, size.height);

    // Draw bottom
    path.lineTo(0, size.height);

    // Close the path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
