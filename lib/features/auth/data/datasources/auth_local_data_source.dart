import 'package:sqflite/sqflite.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getLastUser();
  Future<void> deleteUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Database database;

  AuthLocalDataSourceImpl({required this.database});

  @override
  Future<void> cacheUser(UserModel user) async {
    await database.insert('users', user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<UserModel?> getLastUser() async {
    final List<Map<String, dynamic>> maps = await database.query('users');
    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    }
    return null;
  }

  @override
  Future<void> deleteUser() async {
    await database.delete('users');
  }
}
