// import 'dart:ui';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:payvidence/utilities/base_state.dart';
// import '../data/api_services.dart';

// abstract class BaseNotifier<U, T extends BaseState<U>> extends StateNotifier<T> {
//   final ApiServices apiService;
//   final VoidCallback onSuccess;

//   BaseNotifier({
//     required this.apiService,
//     required this.onSuccess,
//     required T initialState,
//   }) : super(initialState);

//   Future<void> execute(
//     Future<U> Function() action, {
//     required T loadingState,
//     required T Function(U data) dataState,
//   }) async {
//     try {
//       state = loadingState;
//       final data = await action();
//       state = dataState(data);
//       onSuccess();
//     } catch (error) {
//       state = errorState(error);
//     }
//   }

//   T errorState(dynamic error);

//   // Helper for creating form notifiers
//   static StateNotifierProvider<Notifier, BaseState<Data>> formNotifier<Data, Notifier extends BaseNotifier<Data, BaseState<Data>>>(
//     Notifier Function(ApiServices, VoidCallback) create, {
//     required VoidCallback onSuccess,
//   }) {
//     return StateNotifierProvider<Notifier, BaseState<Data>>((ref) {
//       return create(
//         ref.read(apiServiceProvider),
//         onSuccess,
//       );
//     });
//   }
// }