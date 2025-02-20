import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'constants/app_theme.dart';
import 'env_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await loadEnvFile();
  print('Env file loaded.');

  final baseUrl = dotenv.env['BASE_URL'] ?? '';
  if (baseUrl.isEmpty) {
    throw Exception("BASE_URL is missing or empty in .env file!");
  }
  print('Base URL: $baseUrl');
  try {
    await initializeSharedDependencies(baseUrl: baseUrl);
    print('Shared dependencies initialized.');
    runApp(ProviderScope(child: MyApp(appTheme: AppTheme())));
  } catch (e) {
    print(e);
  }
}

// final appRoutes = AppRoutes();



class MyApp extends StatelessWidget {
  final AppTheme appTheme;

  const MyApp({super.key, required this.appTheme});

  @override
  Widget build(BuildContext context) {
    final _appRouter = locator<PayvidenceAppRouter>();
    // final goRouter = ref.watch(appRoutes.goRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      builder: (_, child) => MaterialApp.router(
        title: 'Payvidence',
        debugShowCheckedModeBanner: false,
        theme: appTheme.light,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
