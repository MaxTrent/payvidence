import 'dart:developer' as developer;
import 'package:payvidence/routes/payvidence_app_router.dart';
import 'package:payvidence/routes/payvidence_app_router.gr.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/data/local/session_constants.dart';
import 'package:payvidence/data/local/session_manager.dart';

class AuthNavigationHelper {
  static Future<void> forceLogoutAndNavigateToOnboarding() async {
    try {
      developer.log('Force logout initiated');
      
      // Clear user session
      await locator<SessionManager>().clear();
      developer.log('User session cleared');
      
      // Get router instance
      final router = locator<PayvidenceAppRouter>();
      
      // Force navigation to onboarding with multiple attempts
      Future.microtask(() {
        try {
          // First attempt: replaceAll
          router.replaceAll([OnboardingScreenRoute()]);
          developer.log('Navigation to onboarding completed (method 1)');
        } catch (e) {
          developer.log('Navigation method 1 failed: $e');
          try {
            // Second attempt: navigate
            router.navigate(OnboardingScreenRoute());
            developer.log('Navigation to onboarding completed (method 2)');
          } catch (e2) {
            developer.log('Navigation method 2 failed: $e2');
            try {
              // Third attempt: push replacement
              router.replace(OnboardingScreenRoute());
              developer.log('Navigation to onboarding completed (method 3)');
            } catch (e3) {
              developer.log('All navigation methods failed: $e3');
            }
          }
        }
      });
    } catch (e) {
      developer.log('Fatal error during force logout: $e');
    }
  }
}