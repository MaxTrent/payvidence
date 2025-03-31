import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/client_model.dart';
import 'package:payvidence/model/product_model.dart';
import 'package:payvidence/providers/business_providers/current_business_provider.dart';
import 'package:payvidence/providers/product_providers/product_fillter_provider.dart';
import 'package:payvidence/repositories/repository/business_repository.dart';
import 'package:payvidence/repositories/repository/product_repository.dart';
import 'package:payvidence/repositories/repository/client_repository.dart';
import '../../model/business_model.dart';
import '../../shared_dependency/shared_dependency.dart';

final getAllClientsProvider = AsyncNotifierProvider<GetAllClientsNotifier, List<ClientModel>>(() {
  return GetAllClientsNotifier();
});

class GetAllClientsNotifier extends AsyncNotifier<List<ClientModel>> {
  @override
  Future<List<ClientModel>> build() {
    final businessId = ref.watch(getCurrentBusinessProvider)?.id;
    if (businessId == null) {
      return Future.value([]);
    }
    return locator<IClientRepository>().fetchAllClients(businessId);
  }

  // Method to manually refresh the client list
  Future<void> fetchClients() async {
    final businessId = ref.read(getCurrentBusinessProvider)?.id;
    if (businessId == null) {
      state = const AsyncValue.data([]);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final clients = await locator<IClientRepository>().fetchAllClients(businessId);
      state = AsyncValue.data(clients);
      print("Refreshed clients: ${clients.length}");
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      print("Error refreshing clients: $e");
    }
  }
}