





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

import 'package:flutter/cupertino.dart';
import 'package:payvidence/data/api_services.dart';

import '../data/network/api_response.dart';
import '../shared_dependency/shared_dependency.dart';
import 'enum.dart';

class BaseChangeNotifier extends ChangeNotifier {
  // late DialogHandler dialogHandler;
  late ApiServices apiServices;
  // late AccountRepository accountRepository;
  // late WalletRepository walletRepository;
  // late DeliveryRepository expressDeliveryRepository;
  // late ShipmentRepository shipmentRepository;

  BaseChangeNotifier(
      {
  //     DialogHandler? dialogHandler,
        ApiServices? apiServices,
  //       AccountRepository? accountRepository,
  //       WalletRepository? walletRepository,
  //       DeliveryRepository? expressDeliveryRepository,
  //       ShipmentRepository? shipmentRepository,
      })
  {
  //   this.dialogHandler = dialogHandler ?? locator();
    this.apiServices = apiServices ?? locator();
  //   this.accountRepository = accountRepository ?? locator();
  //   this.walletRepository = walletRepository ?? locator();
  //   this.expressDeliveryRepository = expressDeliveryRepository ?? locator();
  //   this.shipmentRepository = shipmentRepository ?? locator();
  }

  void handleError({
    ApiErrorResponse? response,
    String? message,
    bool shouldDisplayError = true,
  }) {
    showToastMessage(
        message: message != "null" ? message.toString() : "An error occured",
        type: ToastMessageType.failure);
  }

  void showToastMessage({
    required String message,
    required ToastMessageType type,
  }) {
    // dialogHandler.showCustomTopToastDialog(
    //     message: message, toastMessageType: type);
  }
}
