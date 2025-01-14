import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/api_services.dart';

abstract class BaseNotifier<T> extends StateNotifier<T> {
  final ApiServices apiService;
  final VoidCallback onSuccess;

  BaseNotifier(this.apiService, this.onSuccess, T state) : super(state);

  Future<void> execute(Function action,
      {required T loadingState,
        required T Function(dynamic data) dataState}) async {
    try {
      state = loadingState;
      final data = await action();
      state = dataState(data);
      onSuccess();
    } catch (error) {
      state = errorState(error);
    }
  }

  T errorState(dynamic error);
}