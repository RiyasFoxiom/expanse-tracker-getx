// core/services/local_auth_service.dart
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  /// Check if any form of local auth is supported (biometrics or device passcode)
  Future<bool> isDeviceSupported() async {
    try {
      return await _auth.isDeviceSupported();
    } catch (e) {
      debugPrint('Error checking device support: $e');
      return false;
    }
  }

  /// Optional: Check if biometrics are specifically enrolled
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Trigger authentication with fallback to passcode/PIN
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Authenticate to access your budget',
        biometricOnly: false,
        
        // options: const AuthenticationOptions(
        //   stickyAuth: true,
        //   biometricOnly: false, // Allow fallback to passcode/PIN
        //   useErrorDialogs: true,
        // ),
      );
    } catch (e) {
      debugPrint('Authentication failed: $e');
      return false;
    }
  }

  Future<void> stopAuthentication() => _auth.stopAuthentication();
}
