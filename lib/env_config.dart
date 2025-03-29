import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:payvidence/utilities/app_logger.dart';

Future<void> loadEnvFile({String path = '.env'}) async {
  try {
    await dotenv.load(fileName: path);
    if (dotenv.env.isEmpty) {
      throw Exception("dotenv.env is empty—check if .env file is correctly placed and listed in pubspec.yaml");
    }
  } catch (e) {
    AppLogger.print("Failed to load env file: $e");
    rethrow; // propagate the error
  }
}