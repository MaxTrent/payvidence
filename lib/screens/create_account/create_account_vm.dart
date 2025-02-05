import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/create_account_model.dart';
import 'package:payvidence/routes/app_routes.dart';
import '../../data/api_services.dart';
import '../../utilities/base_state.dart';


class CreateAccountViewModel {
  final WidgetRef ref;
  CreateAccountViewModel(this.ref);


  static final firstNameProvider = StateProvider.autoDispose((_) => '');
  static final lastNameProvider = StateProvider.autoDispose((_) => '');
  static final phoneProvider = StateProvider.autoDispose((_) => '');
  static final emailProvider = StateProvider.autoDispose((_) => '');
  static final passwordProvider = StateProvider.autoDispose((_) => '');
  static final passwordConfirmProvider = StateProvider.autoDispose((_) => '');


  static final textEditingControllerProvider = 
      Provider.family.autoDispose<TextEditingController, String>(
    (ref, _) => TextEditingController()
  );


  static final firstNameControllerProvider =
  Provider.autoDispose<TextEditingController>((ref) {
    final controller = TextEditingController();
    controller.addListener(() {
      ref.read(firstNameProvider.notifier).state = controller.text;
    });
    return controller;
  });


  static final lastNameControllerProvider =
  Provider.autoDispose<TextEditingController>((ref) {
    final controller = TextEditingController();
    controller.addListener(() {
      ref.read(lastNameProvider.notifier).state = controller.text;
    });
    return controller;
  });


  static final phoneControllerProvider =
  Provider.autoDispose<TextEditingController>((ref) {
    final controller = TextEditingController();
    controller.addListener(() {
      ref.read(phoneProvider.notifier).state = controller.text;
    });
    return controller;
  });


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

  static final passwordConfirmControllerProvider =
  Provider.autoDispose<TextEditingController>((ref) {
    final controller = TextEditingController();
    controller.addListener(() {
      ref.read(passwordConfirmProvider.notifier).state = controller.text;
    });
    return controller;
  });

  static final obscurePasswordProvider = StateProvider.autoDispose((ref) => false);
  static final obscurePasswordConfirmProvider = StateProvider.autoDispose((ref) => false);


  static final createAccountNotifierProvider = 
      StateNotifierProvider.autoDispose<CreateAccountNotifier, BaseState<CreateAccountModel>>(
    (ref) => CreateAccountNotifier(
      apiService: ref.read(apiServiceProvider),
      onSuccess: () => ref.read(AppRoutes().goRouterProvider).go(AppRoutes.otp),
    ),
  );

  bool get obscurePassword => ref.watch(obscurePasswordProvider);
  bool get obscurePasswordConfirm => ref.watch(obscurePasswordConfirmProvider);


  BaseState<CreateAccountModel> get createAccountState => ref.watch(createAccountNotifierProvider);


  bool areAllFieldsFilled() =>
      ref.watch(firstNameProvider).isNotEmpty &&
          ref.watch(lastNameProvider).isNotEmpty &&
          ref.watch(emailProvider).isNotEmpty &&
          ref.watch(phoneProvider).isNotEmpty &&
          ref.watch(passwordProvider).isNotEmpty &&
          ref.watch(passwordConfirmProvider).isNotEmpty;

  Future<void> createAccount() async {

    ref.read(createAccountNotifierProvider.notifier).createAccount(
      ref.watch(firstNameControllerProvider).text,
      ref.watch(lastNameControllerProvider).text,
      ref.watch(phoneControllerProvider).text,
      ref.watch(emailControllerProvider).text,
      ref.watch(passwordControllerProvider).text,
      ref.watch(passwordConfirmControllerProvider).text,
    );

    ref.read(firstNameControllerProvider).clear();
    ref.read(lastNameControllerProvider).clear();
    ref.read(phoneControllerProvider).clear();
    ref.read(emailControllerProvider).clear();
    ref.read(passwordControllerProvider).clear();
    ref.read(passwordConfirmControllerProvider).clear();

  }

  void switchPasswordVisibility() {
    ref.read(obscurePasswordProvider.notifier).state =
        !ref.read(obscurePasswordConfirmProvider.notifier).state;
  }

  void switchPasswordConfirmVisibility() {
    ref.read(obscurePasswordConfirmProvider.notifier).state =
    !ref.read(obscurePasswordConfirmProvider.notifier).state;
  }
}

class CreateAccountNotifier extends BaseNotifier<CreateAccountModel> {
  CreateAccountNotifier({
    required super.apiService,
    required super.onSuccess,
  });

  Future<void> createAccount(
    String firstName,
    String lastName,
    String phone,
    String email,
    String password,
    String passwordConfirm,
  ) async {
    await executeRequest(
      () => apiService.createAccount(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
      ),
      dataMapper: (json) => CreateAccountModel.fromJson(json),
    );
  }
}