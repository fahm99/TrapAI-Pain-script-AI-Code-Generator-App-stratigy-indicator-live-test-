import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> signUp(String email, String password, String name);
  Future<void> resetPassword(String email);
  Future<void> verifyOTP(String email, String otp);
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
  Future<void> loginWithGoogle();
}
