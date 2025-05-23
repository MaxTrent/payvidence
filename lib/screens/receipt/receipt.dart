import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/app_button.dart';
import '../../constants/app_colors.dart';
import '../../gen/assets.gen.dart';
import '../../routes/payvidence_app_router.dart';
import '../../shared_dependency/shared_dependency.dart';

@RoutePage(name: 'ReceiptRoute')
class Receipt extends StatelessWidget {
  const Receipt({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(Assets.png.receipts.path),
              SizedBox(
                height: 40.h,
              ),
              AppButton(
                buttonText: 'Share receipt',
                onPressed: () {
                  locator<PayvidenceAppRouter>()
                      .navigateNamed(PayvidenceRoutes.receipt);
                },
              ),
              SizedBox(
                height: 26.h,
              ),
              Text(
                'Download receipt',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: primaryColor2),
              )
            ],
          ),
        ),
      ),
    );
  }
}
