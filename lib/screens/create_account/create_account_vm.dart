import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';


final createAccountViewModelProvider =
ChangeNotifierProvider<CreateAccountViewModel>((ref) {
  return CreateAccountViewModel(ref);
});


class CreateAccountViewModel extends BaseChangeNotifier{
  final Ref ref;
  CreateAccountViewModel(this.ref);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> createAccount({
  required String firstName,
  required String lastName,
  required String phone,
  required String email,
  required String password,
  required String passwordConfirm,
    required Function() navigateOnSuccess,
  }) async {
    try {

      _isLoading = true;
      notifyListeners();
      final response = await apiServices.createAccount(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          email: email,
          password: password,
          passwordConfirm: passwordConfirm,
      );

      if (response.success) {
        _isLoading = false;
        notifyListeners();
        navigateOnSuccess();

      } else {
        _isLoading = false;
        notifyListeners();
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "An error occurred!";
        handleError(message: errorMessage);
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception(e);
    }
  }}



  // static final createAccountNotifierProvider =
  //     StateNotifierProvider.autoDispose<CreateAccountNotifier, BaseState<CreateAccountModel>>(
  //   (ref) => CreateAccountNotifier(
  //     apiService: ref.read(apiServiceProvider),
  //     onSuccess: () {
  //       final router = ref.read(navigationProvider);
  //       router.replace(const OtpScreenRoute());
  //       print('Navigation Complete');
  //       // ref.read(AppRoutes().goRouterProvider).go(AppRoutes.otp);
  //     }
  //   ),
  // );

  // bool get obscurePassword => ref.watch(obscurePasswordProvider);
  // bool get obscurePasswordConfirm => ref.watch(obscurePasswordConfirmProvider);


  // BaseState<CreateAccountModel> get createAccountState => ref.watch(createAccountNotifierProvider);


  // bool areAllFieldsFilled() =>
  //     ref.watch(firstNameProvider).isNotEmpty &&
  //         ref.watch(lastNameProvider).isNotEmpty &&
  //         ref.watch(emailProvider).isNotEmpty &&
  //         ref.watch(phoneProvider).isNotEmpty &&
  //         ref.watch(passwordProvider).isNotEmpty &&
  //         ref.watch(passwordConfirmProvider).isNotEmpty;

  // Future<void> createAccount() async {
  //
  //   ref.read(createAccountNotifierProvider.notifier).createAccount(
  //     ref.watch(firstNameControllerProvider).text,
  //     ref.watch(lastNameControllerProvider).text,
  //     ref.watch(phoneControllerProvider).text,
  //     ref.watch(emailControllerProvider).text,
  //     ref.watch(passwordControllerProvider).text,
  //     ref.watch(passwordConfirmControllerProvider).text,
  //   );
  //
  //   ref.read(firstNameControllerProvider).clear();
  //   ref.read(lastNameControllerProvider).clear();
  //   ref.read(phoneControllerProvider).clear();
  //   ref.read(emailControllerProvider).clear();
  //   ref.read(passwordControllerProvider).clear();
  //   ref.read(passwordConfirmControllerProvider).clear();
  //
  // }



// class CreateAccountNotifier extends BaseNotifier<CreateAccountModel> {
//   CreateAccountNotifier({
//     required super.apiService,
//     required super.onSuccess,
//   });
//
//   Future<void> createAccount(
//     String firstName,
//     String lastName,
//     String phone,
//     String email,
//     String password,
//     String passwordConfirm,
//   ) async {
//     await executeRequest(
//       () => apiService.createAccount(
//         firstName: firstName,
//         lastName: lastName,
//         phone: phone,
//         email: email,
//         password: password,
//         passwordConfirm: passwordConfirm,
//       ),
//       dataMapper: (json) => CreateAccountModel.fromJson(json),
//     );
//   }
// }