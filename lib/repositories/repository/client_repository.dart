import 'package:payvidence/datasource/data/client_datasource.dart';

import '../../model/client_model.dart';

abstract class IClientRepository {
  Future<List<ClientModel>> fetchAllClients(String businessId);
}

class ClientRepository extends IClientRepository {
  final IClientDatasource clientDatasource;

  ClientRepository(this.clientDatasource);

  @override
  Future<List<ClientModel>> fetchAllClients(String businessId) {
    return clientDatasource.fetchAllClients(businessId);
  }
}
