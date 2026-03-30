import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthRepository {
  Future<void> loginWithEmail(String email, String password);
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String lastName,
    required String phone,
    required String verifyMethod,
  });
  Future<void> verifyOtp(String otp);
  Future<void> resetPassword(String newPassword);
  Future<void> logout();
}

class MockAuthRepository implements AuthRepository {
  @override
  Future<void> loginWithEmail(String email, String password) => Future.value();

  @override
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String lastName,
    required String phone,
    required String verifyMethod,
  }) =>
      Future.value();

  @override
  Future<void> verifyOtp(String otp) => Future.value();

  @override
  Future<void> resetPassword(String newPassword) => Future.value();

  @override
  Future<void> logout() => Future.value();
}

final authRepositoryProvider = Provider<AuthRepository>(
  (_) => MockAuthRepository(),
);
