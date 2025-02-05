import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../components/app_button.dart';
import '../../components/app_text_field.dart';
import '../../routes/app_routes.dart';
import '../../routes/app_routes.gr.dart';

@RoutePage(name: 'AddClientRoute')
class AddClient extends StatelessWidget {
   AddClient({super.key});

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SafeArea(
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 16.h,
              ),
              Text(
                'Add new client',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                'Fill in the details below to add your client.',
                style: Theme.of(context).textTheme.displaySmall!,
              ),
              SizedBox(
                height: 32.h,
              ),
              Text(
                'Client name',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(
                height: 8.h,
              ),
              AppTextField(
                hintText: 'Client name',
                controller: _controller,
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Client phone number',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(
                height: 8.h,
              ),
              AppTextField(
                hintText: 'Client phone number',
                controller: _controller,
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Client address',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              SizedBox(
                height: 8.h,
              ),
              AppTextField(
                hintText: 'Client address',
                controller: _controller,
              ),
              SizedBox(
                height: 32.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppButton(
                    buttonText: 'Add client',
                    onPressed: () {
                      context.router.push(const ClientSuccessRoute());
                    },
                  ),
                  SizedBox(
                    height: 8.h,
                  ),

                  // Text('Remove client', style: Theme.of(context).textTheme.displayMedium!.copyWith(color: primaryColor2),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
