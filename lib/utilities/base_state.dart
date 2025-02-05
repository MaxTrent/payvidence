import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/api_services.dart';
import 'app_utils.dart';

class BaseState<T> {
  final bool isLoading;
  final T? data;
  final String? error;

  BaseState({
    required this.isLoading,
    this.data,
    this.error,
  });

  BaseState.loading() : this(isLoading: true);
  BaseState.success(T data) : this(isLoading: false, data: data);
  BaseState.error(String error) : this(isLoading: false, error: error);
}


abstract class BaseNotifier<T> extends StateNotifier<BaseState<T>> {
  final ApiServices apiService;
  final VoidCallback onSuccess;

  BaseNotifier({
    required this.apiService,
    required this.onSuccess,
  }) : super(BaseState(isLoading: false));

  /// Generic execution method
  // Future<void> executeRequest(
  //   Future<T> Function() request, {
  //   T Function(dynamic)? dataMapper,
  // }) async {
  //   try {
  //     state = BaseState.loading();
  //     final response = await request();
  //
  //     final mappedData = dataMapper != null
  //         ? dataMapper(response)
  //         : response;
  //
  //     state = BaseState.success(mappedData);
  //     onSuccess();
  //   } catch (error) {
  //     state = BaseState.error(error.toString());
  //     _handleError(error);
  //   }
  // }

  Future<void> executeRequest(
      Future<T> Function() request, {
        T Function(dynamic)? dataMapper,
      }) async {
    try {
      AppUtils.debug('Setting loading state');
      state = BaseState.loading();

      AppUtils.debug('Making request');
      final response = await request();

      final mappedData = dataMapper != null
          ? dataMapper(response)
          : response;

      AppUtils.debug('Setting success state');
      state = BaseState.success(mappedData);

      AppUtils.debug('Calling onSuccess callback');
      onSuccess();
      AppUtils.debug('onSuccess callback completed');
    } catch (error) {
      AppUtils.debug('Error in executeRequest: $error');
      state = BaseState.error(error.toString());
      _handleError(error);
    }
  }

  void _handleError(dynamic error) {
    print('Error occurred: $error, ${error.runtimeType}');
  }

  static StateNotifierProvider<Notifier, BaseState<T>> createProvider<T, Notifier extends BaseNotifier<T>>(
    Notifier Function(ApiServices, VoidCallback) create, {
    required VoidCallback onSuccess,
  }) {
    return StateNotifierProvider<Notifier, BaseState<T>>((ref) {
      return create(
        ref.read(apiServiceProvider),
        onSuccess,
      );
    });
  }
}

