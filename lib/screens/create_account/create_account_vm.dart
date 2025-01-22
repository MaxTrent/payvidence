import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/create_account_model.dart';
import 'package:payvidence/routes/app_routes.dart';

import '../../data/api_services.dart';
import '../../utilities/base_notifier.dart';
import '../../utilities/base_state.dart';

class CreateAccountViewModel {
  final WidgetRef ref;
  CreateAccountViewModel(this.ref);

  static const firstName = 'firstName';
  static const lastName = 'lastName';
  static const phone = 'phone';
  static const email = 'email';
  static const password = 'password';
  static const passwordConfirm = 'passwordConfirm';

  // final _formKey = GlobalKey<FormState>();
  // final _firstNameController = TextEditingController();
  // final _lastNameController = TextEditingController();
  // static final emailController = TextEditingController();
  // final _phoneNumberController = TextEditingController();
  // final _passwordController = TextEditingController();
  static final createAccountNotifierProvider =
      StateNotifierProvider<CreateAccountNotifier, CreateAccountState>((ref) {
    final apiService = ref.read(apiServiceProvider);
    final goRouter = ref.read(AppRoutes().goRouterProvider);
    // final navigatorKey = ref.read(navigatorKeyProvider);
    return CreateAccountNotifier(
      apiService,
      () {
        goRouter.go(AppRoutes.otp);
      },
    );
  });

  static final obscureTextProvider =
      StateProvider.family<bool, String>((ref, value) => false);

  static final textEditingControllerProvider = Provider.family
      .autoDispose<TextEditingController, String>((ref, fieldName) {
    return TextEditingController();
  });

  Future<void> createAccount() async {
    ref.read(createAccountNotifierProvider.notifier).createAccount(
        ref.watch(textEditingControllerProvider(firstName)).text,
        ref.watch(textEditingControllerProvider(lastName)).text,
        ref.watch(textEditingControllerProvider(phone)).text,
        ref.watch(textEditingControllerProvider(email)).text,
        ref.watch(textEditingControllerProvider(password)).text,
        ref.watch(textEditingControllerProvider(passwordConfirm)).text
    );
  }

  CreateAccountState get createAccountState =>
      ref.watch(createAccountNotifierProvider);

  bool obscureText(value) => ref.watch(obscureTextProvider(value));

  TextEditingController textEditingController(value) =>
      ref.watch(textEditingControllerProvider(value));

  void switchVisibility(String value) {
    ref.read(obscureTextProvider(value).notifier).state =
        !ref.read(obscureTextProvider(value).notifier).state;
  }

  bool areAllFieldsFilled() => ref.watch(textEditingControllerProvider(firstName)).text.isNotEmpty &&
        ref.watch(textEditingControllerProvider(lastName)).text.isNotEmpty &&
        ref.watch(textEditingControllerProvider(email)).text.isNotEmpty &&
        ref.watch(textEditingControllerProvider(phone)).text.isNotEmpty &&
        ref.watch(textEditingControllerProvider(password)).text.isNotEmpty &&
        ref.watch(textEditingControllerProvider(passwordConfirm)).text.isNotEmpty;
}

class CreateAccountState extends BaseState {
  final CreateAccountModel? data;

  CreateAccountState({required super.isLoading, this.data, super.error});
}

class CreateAccountNotifier extends BaseNotifier<CreateAccountState> {
  CreateAccountNotifier(ApiServices apiService, VoidCallback onSuccess)
      : super(apiService, onSuccess, CreateAccountState(isLoading: false));

  Future<void> createAccount(String firstName, String lastName, String phone,
      String email, String password, String passwordConfirm) async {
    await execute(
      () => apiService.createAccount(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          email: email,
          password: password,
          passwordConfirm: passwordConfirm),
      loadingState: CreateAccountState(isLoading: true),
      dataState: (data) => CreateAccountState(isLoading: false, data: data),
    );
  }

  @override
  CreateAccountState errorState(dynamic error) {
    return CreateAccountState(isLoading: false, error: error.toString());
  }
}
