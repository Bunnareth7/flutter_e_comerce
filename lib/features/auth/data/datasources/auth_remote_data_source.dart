import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> signUp(String email, String password, String name);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'test@test.com' && password == '123456') {
      return UserModel(
        id: '1',
        email: email,
        name: 'Test User',
        token: 'dummy_token',
      );
    } else {
      throw Exception('Invalid credentials');
    }
  }

  @override
  Future<UserModel> signUp(String email, String password, String name) async {
    await Future.delayed(const Duration(seconds: 2));
    return UserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      token: 'new_token',
    );
  }
}