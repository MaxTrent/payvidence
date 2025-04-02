import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:payvidence/model/client_model.dart';
import '../../data/network/api_response.dart';
import '../../data/network/network_service.dart';
import '../../utilities/payvidence_endpoints.dart';

abstract class IClientDatasource {
  Future<List<ClientModel>> fetchAllClients(String businessId);
}

class ClientDatasource extends IClientDatasource {
  final NetworkService networkService;

  ClientDatasource(this.networkService);

  @override
  Future<List<ClientModel>> fetchAllClients(String businessId) async {
    //final NetworkService _networkService = locator<NetworkService>();
    try {
      final Either<Failure, Success> response = await networkService
          .get('${PayvidenceEndpoints.business}/$businessId/client');
      //LoggerService.info("Product Categories:: ${response.toString()}");

      return response.fold((fail) {
        throw fail.error;
      }, (success) {
        List jsonList = success.data['data'] as List;
        // print(success.data);
        return jsonList.map((json) => ClientModel.fromJson(json)).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }

      rethrow;
    }
  }
}
