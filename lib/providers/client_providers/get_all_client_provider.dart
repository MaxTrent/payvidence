import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/model/client_model.dart';
import 'package:payvidence/model/product_model.dart';
import 'package:payvidence/providers/business_providers/current_business_provider.dart';
import 'package:payvidence/providers/product_providers/product_fillter_provider.dart';
import 'package:payvidence/repositories/repository/business_repository.dart';
import 'package:payvidence/repositories/repository/product_repository.dart';

import '../../model/business_model.dart';
import '../../repositories/repository/client_repository.dart';
import '../../shared_dependency/shared_dependency.dart';

final getAllClientsProvider =
    AsyncNotifierProvider<GetAllClientsNotifier, List<ClientModel>>(() {
  return GetAllClientsNotifier();
});

class GetAllClientsNotifier extends AsyncNotifier<List<ClientModel>> {
  @override
  Future<List<ClientModel>> build() {
    //final userModel = getUser();
    return locator<IClientRepository>()
        .fetchAllClients(ref.watch(getCurrentBusinessProvider)!.id!);
  }
// Add methods to mutate the state
}
