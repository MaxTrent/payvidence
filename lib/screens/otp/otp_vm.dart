import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/data/api_services.dart';
import 'package:payvidence/model/verify_otp_model.dart';
import 'package:payvidence/utilities/base_notifier.dart';
import 'package:payvidence/utilities/base_state.dart';


class OtpState {
  final int seconds;

  OtpState(this.seconds);
}

final otpViewModelProvider = StateNotifierProvider.autoDispose<OtpViewModel, OtpState>(
  (ref) => OtpViewModel(),
);

class OtpViewModel extends StateNotifier<OtpState> {
  Timer? _timer;

static final otpTextProvider = StateProvider<String>((ref) => '');
static final isOtpCompleteProvider = StateProvider((ref) {
  return ref.watch(otpTextProvider).length == 5; 
});
static final otpController = Provider((ref)=>TextEditingController());
// bool get isOtpComplete => ref.watch(isOtpCompleteProvider);

  OtpViewModel() : super(OtpState(17)) {
    startCountdown();
  }

  void startCountdown() {
    _timer?.cancel();
    state = OtpState(17);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.seconds == 0) {
        timer.cancel();
      } else {
        state = OtpState(state.seconds - 1);
      }
    });
  }

  void resendCode() {
    startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}


class VerifyOtpState extends BaseState {
  final VerifyOtpModel? data;

  VerifyOtpState({required super.isLoading, this.data, super.error});
}

class VerifyOtpNotifier extends BaseNotifier<VerifyOtpState> {
  VerifyOtpNotifier(ApiServices apiService, VoidCallback onSuccess)
      : super(apiService, onSuccess, VerifyOtpState(isLoading: false));

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
      loadingState: VerifyOtpState(isLoading: true),
      dataState: (data) => VerifyOtpState(isLoading: false, data: data),
    );
  }

  @override
  VerifyOtpState errorState(dynamic error) {
    return VerifyOtpState(isLoading: false, error: error.toString());
  }
}
