import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:payvidence/screens/nav_screens/home.dart';

import '../../components/app_button.dart';
import '../../gen/assets.gen.dart';
import '../../providers/client_providers/get_all_client_provider.dart';
import '../../routes/payvidence_app_router.dart';
import '../../routes/payvidence_app_router.gr.dart';
import '../../shared_dependency/shared_dependency.dart';
import '../clients/clients.dart';
   



@RoutePage(name: 'ClientSuccessRoute')
class ClientSuccess extends HookConsumerWidget {
  final String name;

  const ClientSuccess({super.key,@QueryParam('name') this.name = ''});

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      floatingActionButton: AppButton(
          buttonText: 'Alright!',
          onPressed: (){
            // locator<PayvidenceAppRouter>().popUntil(
            //         (route) => route is Clients);
            ref.read(getAllClientsProvider.notifier).fetchClients();
           Navigator.of(context).pop();
           Navigator.of(context).pop();
            // locator<PayvidenceAppRouter>().back();
          }),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(Assets.svg.clientSuccess),
              SizedBox(
                height: 40.h,
              ),
              Text(
                'Client added! ',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                '$name has been successfully added to your clients. You can now select the client while generating receipt and invoice.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displaySmall!,
              ),
              SizedBox(
                height: 32.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
