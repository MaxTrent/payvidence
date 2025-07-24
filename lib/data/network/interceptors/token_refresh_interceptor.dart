import 'package:dio/dio.dart';
import 'package:payvidence/data/local/session_constants.dart';
import 'package:payvidence/data/local/session_manager.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:payvidence/utilities/payvidence_endpoints.dart';
import 'package:payvidence/utilities/auth_navigation_helper.dart';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class TokenRefreshInterceptor extends Interceptor {
  final Dio dio;
  bool _isRefreshing = false;
  
  TokenRefreshInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only handle 401 unauthorized errors with specific message
    if (err.response?.statusCode == 401 && 
        err.response?.data is Map && 
        err.response?.data['message'] == 'unauthorized') {
      
      // Get the original request
      final options = err.requestOptions;
      
      // Log detailed information in debug mode
      if (kDebugMode) {
        developer.log('401 Unauthorized detected in TokenRefreshInterceptor');
        developer.log('Request path: ${options.path}');
        developer.log('Request method: ${options.method}');
      }
      
      // Don't try to refresh if this is already a refresh token request
      // or if we're already in the process of refreshing
      if (options.path == PayvidenceEndpoints.refreshToken || _isRefreshing) {
        developer.log('Skipping token refresh: ${_isRefreshing ? "already refreshing" : "refresh token request"}');
        // Let the connection interceptor handle the redirect
        return handler.next(err);
      }
      
      try {
        _isRefreshing = true;
        developer.log('Token expired, attempting to refresh...');
        
        // Get the refresh token
        final refreshToken = locator<SessionManager>().get<String>(SessionConstants.refreshToken);
        
        if (refreshToken == null || refreshToken.isEmpty) {
          developer.log('No refresh token available, cannot refresh');
          return handler.next(err);
        }
        
        // Create a new Dio instance for the refresh request to avoid interceptor loops
        final refreshDio = Dio(BaseOptions(
          baseUrl: dio.options.baseUrl,
          headers: {'Authorization': 'Bearer $refreshToken'},
        ));
        
        // Add logging in debug mode
        if (kDebugMode) {
          refreshDio.interceptors.add(LogInterceptor(
            requestBody: true,
            responseBody: true,
            logPrint: (log) => developer.log(log.toString()),
          ));
        }
        
        developer.log('Making refresh token request to: ${PayvidenceEndpoints.refreshToken}');
        
        // Make the refresh token request
        final response = await refreshDio.get(PayvidenceEndpoints.refreshToken);
        
        developer.log('Refresh token response status: ${response.statusCode}');
        if (kDebugMode && response.data != null) {
          developer.log('Refresh token response has data: ${response.data != null}');
          developer.log('Refresh token response has data.data: ${response.data['data'] != null}');
        }
        
        if (response.statusCode == 200 && response.data != null && 
            response.data['data'] != null) {
          
          final newToken = response.data['data']['access_token'] as String?;
          final newRefreshToken = response.data['data']['refresh_token'] as String?;
          
          developer.log('New access token received: ${newToken != null ? "yes" : "no"}');
          developer.log('New refresh token received: ${newRefreshToken != null ? "yes" : "no"}');
          
          if (newToken != null && newToken.isNotEmpty) {
            // Save the new tokens
            await locator<SessionManager>().save(key: SessionConstants.accessTokenPref, value: newToken);
            developer.log('New access token saved');
            
            if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
              await locator<SessionManager>().save(key: SessionConstants.refreshToken, value: newRefreshToken);
              developer.log('New refresh token saved');
            }
            
            // Also update the user logged in status to ensure it's true
            await locator<SessionManager>().save(key: SessionConstants.isUserLoggedIn, value: true);
            developer.log('User logged in status set to true');
            
            developer.log('Token refreshed successfully, retrying original request');
            
            // Retry the original request with the new token
            options.headers['Authorization'] = 'Bearer $newToken';
            
            // Create a new request with the updated token
            final response = await dio.fetch(options);
            developer.log('Original request retried successfully');
            return handler.resolve(response);
          }
        }
        
        // If we get here, token refresh failed
        developer.log('Token refresh failed, forcing logout and navigation');
        await AuthNavigationHelper.forceLogoutAndNavigateToOnboarding();
        return handler.next(err);
      } catch (e) {
        developer.log('Error during token refresh: $e');
        await AuthNavigationHelper.forceLogoutAndNavigateToOnboarding();
        return handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    }
    
    // For all other errors, just pass them through
    return handler.next(err);
  }
}