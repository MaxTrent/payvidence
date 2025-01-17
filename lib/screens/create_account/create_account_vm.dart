import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/create_account_model.dart';

import '../../data/api_services.dart';
import '../../utilities/base_notifier.dart';
import '../../utilities/base_state.dart';

class CreateAccountViewModel {
  final WidgetRef ref;
  CreateAccountViewModel(this.ref);

  // final _formKey = GlobalKey<FormState>();
  // final _firstNameController = TextEditingController();
  // final _lastNameController = TextEditingController();
  // static final emailController = TextEditingController();
  // final _phoneNumberController = TextEditingController();
  // final _passwordController = TextEditingController();
  static final requestPasswordResetEmailNotifierProvider =
  StateNotifierProvider<CreateAccountNotifier,
      CreateAccountState>((ref) {
    final apiService = ref.read(apiServiceProvider);
    final goRouter = ref.read(goRouterProvider);
    final navigatorKey = ref.read(navigatorKeyProvider);
    return CreateAccountNotifier(
      apiService,
          () {
        context.go();
      },
    );
  });

  static final obscureTextProvider =
      StateProvider.family<bool, String>((ref, value) => false);

  static final textEditingControllerProvider = Provider.family
      .autoDispose<TextEditingController, String>((ref, fieldName) {
    return TextEditingController();
  });

  bool obscureText(value) => ref.watch(obscureTextProvider(value));

  TextEditingController textEditingController(value) =>
      ref.watch(textEditingControllerProvider(value));

  void switchVisibility(String value) {
    ref.read(obscureTextProvider(value).notifier).state =
        !ref.read(obscureTextProvider(value).notifier).state;
  }

  bool areAllFieldsFilled(List<String> fieldNames) {
    for (final fieldName in fieldNames) {
      final controller = ref.read(textEditingControllerProvider(fieldName));
      if (controller.text.trim().isEmpty) {
        return false;
      }
    }
    return true;
  }
}

class CreateAccountState extends BaseState {
  final CreateAccountModel? data;

  CreateAccountState({required bool isLoading, this.data, String? error})
      : super(isLoading: isLoading, error: error);
}



class CreateAccountNotifier
    extends BaseNotifier<CreateAccountState> {
  CreateAccountNotifier(ApiServices apiService, VoidCallback onSuccess)
      : super(
            apiService, onSuccess, CreateAccountState(isLoading: false));

  Future<void> createAccount(
      String firstName,
      String lastName,
      String phone,
      String email,
      String password,
      String passwordConfirm) async {
    await execute(
      () => apiService.createAccount(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          email: email,
          password: password,
          passwordConfirm: passwordConfirm),
      loadingState: CreateAccountState(isLoading: true),
      dataState: (data) =>
          CreateAccountState(isLoading: false, data: data),
    );
  }

  @override
  CreateAccountState errorState(dynamic error) {
    return CreateAccountState(isLoading: false, error: error.toString());
  }
}
