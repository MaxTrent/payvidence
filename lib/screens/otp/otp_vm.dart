import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';


class OtpState {
  final int seconds;

  OtpState(this.seconds);
}

final otpViewModelProvider = StateNotifierProvider.autoDispose<OtpViewModel, OtpState>(
  (ref) => OtpViewModel(),
);

class OtpViewModel extends StateNotifier<OtpState> {
  Timer? _timer;

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