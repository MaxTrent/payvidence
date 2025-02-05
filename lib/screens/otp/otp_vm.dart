import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/data/api_services.dart';
import 'package:payvidence/model/verify_otp_model.dart';
import 'package:payvidence/routes/app_routes.dart';
import 'package:payvidence/utilities/base_state.dart';

class OtpViewModel {
  final Ref ref;
  OtpViewModel(this.ref);

  // OTP UI State Providers
  static final secondsProvider = StateProvider.autoDispose<int>((_) => 17);
  static final otpTextProvider = StateProvider.autoDispose<String>((_) => '');
  static final isOtpCompleteProvider = Provider.autoDispose<bool>((ref) {
    return ref.watch(otpTextProvider).length == 5;
  });

  Timer? _timer;

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

class VerifyOtpNotifier extends BaseNotifier<VerifyOtpModel> {
  VerifyOtpNotifier({
    required super.apiService,
    required super.onSuccess,
  });

  Future<void> verifyOtp(String otp) async {
    await executeRequest(
      () => apiService.verifyOtp(otp),
      dataMapper: (json) => VerifyOtpModel.fromJson(json),
    );
  }
}

// Provider Definitions
final otpViewModelProvider = Provider.autoDispose<OtpViewModel>((ref) {
  final vm = OtpViewModel(ref);
  ref.onDispose(() => vm.dispose());
  return vm;
});

final verifyOtpNotifierProvider = StateNotifierProvider.autoDispose<
  VerifyOtpNotifier, BaseState<VerifyOtpModel>>(
  (ref) => VerifyOtpNotifier(
    apiService: ref.read(apiServiceProvider),
    onSuccess: () => ref.read(AppRoutes().goRouterProvider).go(AppRoutes.accountSuccess),
  ),
);