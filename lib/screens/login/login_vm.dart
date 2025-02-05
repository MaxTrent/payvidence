import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/data/api_services.dart';
import 'package:payvidence/model/login_model.dart';
import 'package:payvidence/routes/app_routes.dart';
import 'package:payvidence/screens/device_info.dart';
import 'package:payvidence/utilities/base_state.dart';

import '../../routes/app_routes.gr.dart';
import '../../utilities/app_utils.dart';
import '../nav_screens/home_page.dart';

class LoginViewModel {
  final WidgetRef ref;
  LoginViewModel(this.ref);



  static final emailProvider = StateProvider.autoDispose((_) => '');
  static final passwordProvider = StateProvider.autoDispose((_) => '');
  static final obscureTextProvider = StateProvider.autoDispose((_) => false);

  // static final textEditingControllerProvider =
  //     Provider.family.autoDispose<TextEditingController, String>(
  //   (ref, _) => TextEditingController()
  // );

  static final emailControllerProvider =
      Provider.autoDispose<TextEditingController>((ref) {
    final controller = TextEditingController();
    controller.addListener(() {
      ref.read(emailProvider.notifier).state = controller.text;
    });
    return controller;
  });

  static final passwordControllerProvider =
      Provider.autoDispose<TextEditingController>((ref) {
    final controller = TextEditingController();
    controller.addListener(() {
      ref.read(passwordProvider.notifier).state = controller.text;
    });
    return controller;
  });

  static final loginNotifierProvider =
  StateNotifierProvider.autoDispose<LoginNotifier, BaseState<LoginModel>>(
        (ref) => LoginNotifier(
      apiService: ref.read(apiServiceProvider),
      onSuccess: () {
        final router = ref.read(navigationProvider);
        router.replace(const HomePageRoute());
        print('Navigation Complete');
      },
    ),
  );

  // Getters
  bool get obscureText => ref.watch(obscureTextProvider);
  BaseState<LoginModel> get loginState => ref.watch(loginNotifierProvider);

  bool areAllFieldsFilled() =>
      ref.watch(emailProvider).isNotEmpty &&
      ref.watch(passwordProvider).isNotEmpty;

  // bool get areAllFieldsFilled =>
  //     ref.watch(textEditingControllerProvider(email)).text.isNotEmpty &&
  //     ref.watch(textEditingControllerProvider(password)).text.isNotEmpty;

  Future<void> login() async {
    final deviceName = await getDeviceName();

    ref.read(loginNotifierProvider.notifier).login(
          ref.watch(emailControllerProvider).text,
          ref.watch(passwordControllerProvider).text,
          deviceName ?? "Unknown Device",
        );


    ref.read(emailControllerProvider).clear();
    ref.read(passwordControllerProvider).clear();
  }

  void switchVisibility() {
    ref.read(obscureTextProvider.notifier).state =
        !ref.read(obscureTextProvider.notifier).state;
  }
}

// class LoginNotifier extends BaseNotifier<LoginModel> {
//   LoginNotifier({
//     required super.apiService,
//     required super.onSuccess,
//   });
//
//   Future<void> login(String email, String password, String deviceName) async {
//
//     await executeRequest(
//       () => apiService.login(
//         email: email,
//         password: password,
//         deviceName: deviceName,
//       ),
//       // dataMapper: (json) => LoginModel.fromJson(json as Map<String, dynamic>),
//     );
//
//   }
// }

class LoginNotifier extends BaseNotifier<LoginModel> {

  LoginNotifier({
    required super.apiService,
    required super.onSuccess,
  });


  Future<void> login(String email, String password, String deviceName) async {
    AppUtils.debug('Starting login process');
    await executeRequest(
          () => apiService.login(
        email: email,
        password: password,
        deviceName: deviceName,
      ),
    );
    AppUtils.debug('Login process completed');
  }
}
