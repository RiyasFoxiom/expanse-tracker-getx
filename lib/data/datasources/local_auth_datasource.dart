import 'package:test_app/core/services/local_auth_service.dart';

class LocalAuthDataSource {
  final LocalAuthService service;

  LocalAuthDataSource(this.service);

  Future<bool> isAuthAvailable() {
    return service.isDeviceSupported();
  }

  Future<bool> authenticate() {
    return service.authenticate();
  }
}
