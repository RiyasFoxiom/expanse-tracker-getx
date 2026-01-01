import 'package:test_app/data/datasources/local_auth_datasource.dart';
import 'package:test_app/domain/repositories/local_auth_repository.dart';

class LocalAuthRepositoryImpl implements LocalAuthRepository {
  final LocalAuthDataSource dataSource;

  LocalAuthRepositoryImpl(this.dataSource);

  @override
  Future<bool> isAuthAvailable() {
    return dataSource.isAuthAvailable();
  }

  @override
  Future<bool> authenticate() {
    return dataSource.authenticate();
  }
}
