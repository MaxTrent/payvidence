import 'dart:developer' as developer;
import 'package:payvidence/data/local/session_constants.dart';
import 'package:payvidence/data/local/session_manager.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/auth_navigation_helper.dart';

import '../data/api_services.dart';

class TokenValidationService {
  static Future<void> validateTokenOnStartup() async {
    try {
      developer.log('Validating token on startup');
      
      final sessionManager = locator<SessionManager>();
      final isLoggedIn = sessionManager.get<bool>(SessionConstants.isUserLoggedIn) ?? false;
      
      if (!isLoggedIn) {
        developer.log('User not logged in, skipping token validation');
        return;
      }
      
      final token = sessionManager.get<String>(SessionConstants.accessTokenPref);
      final refreshToken = sessionManager.get<String>(SessionConstants.refreshToken);
      
      // Check if tokens exist
      if (token == null || token.isEmpty || refreshToken == null || refreshToken.isEmpty) {
        developer.log('Invalid tokens found, forcing logout');
        await AuthNavigationHelper.forceLogoutAndNavigateToOnboarding();
        return;
      }
      
      // Attempt to validate token by making a simple API call
      try {
        final response = await locator<ApiServices>().getAccount();
        if (!response.success) {
          developer.log('Token validation failed: ${response.error?.message}');
          await AuthNavigationHelper.forceLogoutAndNavigateToOnboarding();
        } else {
          developer.log('Token validation successful');
        }
      } catch (e) {
        developer.log('Token validation error: $e');
        await AuthNavigationHelper.forceLogoutAndNavigateToOnboarding();
      }
    } catch (e) {
      developer.log('Error during token validation: $e');
    }
  }
}