import 'package:dartz/dartz.dart';
import 'package:e_com_app/features/address/domain/entities/address.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/address.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_local_data_source.dart';
import '../models/address_model.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressLocalDataSource localDataSource;

  AddressRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Address>>> getAddresses() async {
    try {
      final addresses = await localDataSource.getAddresses();
      return Right(addresses);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addAddress(Address address) async {
    try {
      final model = AddressModel(
        id: address.id,
        fullName: address.fullName,
        phone: address.phone,
        street: address.street,
        city: address.city,
        state: address.state,
        zip: address.zip,
        isDefault: address.isDefault,
      );
      await localDataSource.addAddress(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateAddress(Address address) async {
    try {
      final model = AddressModel(
        id: address.id,
        fullName: address.fullName,
        phone: address.phone,
        street: address.street,
        city: address.city,
        state: address.state,
        zip: address.zip,
        isDefault: address.isDefault,
      );
      await localDataSource.updateAddress(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddress(String id) async {
    try {
      await localDataSource.deleteAddress(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setDefaultAddress(String id) async {
    try {
      await localDataSource.setDefaultAddress(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}