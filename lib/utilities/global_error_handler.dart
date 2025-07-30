import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:payvidence/utilities/auth_navigation_helper.dart';

class GlobalErrorHandler {
  static void initialize() {
    // Set up global error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      // Log the error
      FlutterError.presentError(details);
      
      // Check if the error is related to authentication
      final error = details.exception.toString().toLowerCase();
      if (error.contains('unauthorized') || error.contains('401') || error.contains('unauthenticated')) {
        developer.log('Authentication error detected in global handler: ${details.exception}');
        _handleAuthError();
      }
    };
    
    // Handle async errors outside of Flutter
    PlatformDispatcher.instance.onError = (error, stack) {
      developer.log('Uncaught platform error: $error');
      
      // Check if the error is related to authentication
      final errorStr = error.toString().toLowerCase();
      if (errorStr.contains('unauthorized') || errorStr.contains('401') || errorStr.contains('unauthenticated')) {
        developer.log('Authentication error detected in platform handler: $error');
        _handleAuthError();
      }
      
      return true;
    };
  }
  
  static void _handleAuthError() {
    // Use a microtask to avoid calling setState during build
    Future.microtask(() async {
      try {
        await AuthNavigationHelper.forceLogoutAndNavigateToOnboarding();
      } catch (e) {
        developer.log('Error in auth error handler: $e');
      }
    });
  }
}