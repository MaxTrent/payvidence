import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/utilities/base_notifier.dart';

final otpViewModelProvider = ChangeNotifierProvider((ref) {
  return OtpViewModel(ref);
});

class OtpViewModel extends BaseChangeNotifier {
  final Ref ref;
  OtpViewModel(this.ref);

  // OTP UI State Providers
  static final secondsProvider = StateProvider.autoDispose<int>((_) => 17);
  static final otpTextProvider = StateProvider.autoDispose<String>((_) => '');
  static final isOtpCompleteProvider = Provider.autoDispose<bool>((ref) {
    return ref.watch(otpTextProvider).length == 5;
  });

  Timer? _timer;

  Future<void> verifyOtp({
    required String otp,
    required Function() navigateOnSuccess,
  }) async {
    try {
      final response = await apiServices.verifyOtp(otp);

      if (response.success) {
        navigateOnSuccess();
      } else {
        var errorMessage = response.error?.errors?.first.message ??
            response.error?.message ??
            "An error occurred!";
        handleError(message: errorMessage);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void startCountdown() {
    _timer?.cancel();
    ref.read(secondsProvider.notifier).state = 17;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final current = ref.read(secondsProvider);
      if (current == 0) {
        timer.cancel();
      } else {
        ref.read(secondsProvider.notifier).state = current - 1;
      }
    });
  }

  void resendCode() {
    startCountdown();
  }

  void dispose() {
    _timer?.cancel();
  }
}

// class VerifyOtpNotifier extends BaseNotifier<VerifyOtpModel> {
//   VerifyOtpNotifier({
//     required super.apiService,
//     required super.onSuccess,
//   });
//
//   Future<void> verifyOtp(String otp) async {
//     await executeRequest(
//       () => apiService.verifyOtp(otp),
//       dataMapper: (json) => VerifyOtpModel.fromJson(json),
//     );
//   }
// }

// final verifyOtpNotifierProvider = StateNotifierProvider.autoDispose<
//   VerifyOtpNotifier, BaseState<VerifyOtpModel>>(
//   (ref) => VerifyOtpNotifier(
//     apiService: ref.read(apiServiceProvider),
//     onSuccess: () {
//       final router = ref.read(navigationProvider);
//       router.replace(const AccountSuccessRoute());
//       print('Navigation Complete');
//       // ref.read(AppRoutes().goRouterProvider).go(AppRoutes.accountSuccess);\
// }
//   ),
// );
