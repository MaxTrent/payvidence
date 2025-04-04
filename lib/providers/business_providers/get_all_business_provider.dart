import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payvidence/repositories/repository/business_repository.dart';
import '../../model/business_model.dart';
import '../../shared_dependency/shared_dependency.dart';


final getAllBusinessProvider =
    AsyncNotifierProvider<GetAllBusinessNotifier, List<Business>>(() {
  return GetAllBusinessNotifier();
});



class GetAllBusinessNotifier extends AsyncNotifier<List<Business>> {
  @override
  Future<List<Business>> build() {
    //final userModel = getUser();
    return locator<IBusinessRepository>().fetchAllBusiness();
  }

  Future<Business> updateBusiness(String id, Map<String, dynamic> requestData) {
    //final userModel = getUser();
    return locator<IBusinessRepository>().updateBusiness(id, requestData);
  }

// Add methods to mutate the state
}
