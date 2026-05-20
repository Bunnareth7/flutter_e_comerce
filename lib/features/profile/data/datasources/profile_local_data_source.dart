
import 'package:sqflite/sqflite.dart';
import '../models/user_profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfileModel> getProfile();
  Future<void> saveProfile(UserProfileModel profile);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final Database database;
  ProfileLocalDataSourceImpl({required this.database});

  @override
  Future<UserProfileModel> getProfile() async {
    final maps = await database.query('users');
    if (maps.isNotEmpty) return UserProfileModel.fromJson(maps.first);
    throw Exception('No user');
  }

  @override
  Future<void> saveProfile(UserProfileModel profile) async {
    await database.update('users', profile.toJson(), where: 'id = ?', whereArgs: [profile.id]);
  }
}