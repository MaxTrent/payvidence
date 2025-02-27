import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:payvidence/datasource/data/business_datasource.dart';
import 'package:payvidence/repositories/repository/business_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/api_services.dart';
import '../data/local/session_manager.dart';
import '../data/network/network_service.dart';
import '../routes/payvidence_app_router.dart';

GetIt locator = GetIt.instance;

Future<void> initializeSharedDependencies({required String baseUrl}) async {
  print('Initializing dependencies...');

  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerSingleton(sharedPreferences);

  locator.registerLazySingleton<SessionManager>(
        () => SessionManager(sharedPreferences: locator()),
  );
  locator.registerLazySingleton(() => Dio());

  locator.registerLazySingleton<PayvidenceAppRouter>(() => PayvidenceAppRouter());

  locator.registerLazySingleton<NetworkService>(
        () => NetworkService(dio: locator(), baseUrl: baseUrl),
  );

  locator.registerLazySingleton<ApiServices>(
        () => ApiServices(),
  );
  locator.registerLazySingleton<IBusinessDatasource>(
        () => BusinessDatasource(locator()),
  );
  locator.registerLazySingleton<IBusinessRepository>(
        () => BusinessRepository(locator()),
  );
  print('Dependencies initialized successfully.');

}
