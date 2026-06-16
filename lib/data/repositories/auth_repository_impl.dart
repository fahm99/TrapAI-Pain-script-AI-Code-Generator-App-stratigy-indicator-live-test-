import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/mock_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final MockDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<UserEntity> login(String email, String password) {
    return _dataSource.login(email, password);
  }

  @override
  Future<UserEntity> signUp(String email, String password, String name) {
    return _dataSource.signUp(email, password, name);
  }

  @override
  Future<void> resetPassword(String email) {
    return _dataSource.resetPassword(email);
  }

  @override
  Future<void> verifyOTP(String email, String otp) {
    return _dataSource.verifyOTP(email, otp);
  }

  @override
  Future<void> signOut() {
    return _dataSource.signOut();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return _dataSource.currentUser;
  }

  @override
  Future<void> loginWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
