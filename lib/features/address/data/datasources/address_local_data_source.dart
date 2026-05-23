import 'package:sqflite/sqflite.dart';
import '../models/address_model.dart';

abstract class AddressLocalDataSource {
  Future<List<AddressModel>> getAddresses();
  Future<void> addAddress(AddressModel address);
  Future<void> updateAddress(AddressModel address);
  Future<void> deleteAddress(String id);
  Future<void> setDefaultAddress(String id);
}

class AddressLocalDataSourceImpl implements AddressLocalDataSource {
  final Database database;

  AddressLocalDataSourceImpl({required this.database});

  @override
  Future<List<AddressModel>> getAddresses() async {
    final maps = await database.query('addresses');
    return maps.map((e) => AddressModel.fromJson(e)).toList();
  }

  @override
  Future<void> addAddress(AddressModel address) async {
    await database.insert('addresses', address.toJson());
  }

  @override
  Future<void> updateAddress(AddressModel address) async {
    await database.update('addresses', address.toJson(),
        where: 'id = ?', whereArgs: [address.id]);
  }

  @override
  Future<void> deleteAddress(String id) async {
    await database.delete('addresses', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> setDefaultAddress(String id) async {
    // First, set all addresses to isDefault = 0
    await database.update('addresses', {'isDefault': 0});
    // Then set the chosen one to 1
    await database.update('addresses', {'isDefault': 1},
        where: 'id = ?', whereArgs: [id]);
  }
}