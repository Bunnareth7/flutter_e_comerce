import 'package:dartz/dartz.dart';
import 'package:e_com_app/features/address/domain/entities/address.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

class AddAddressParams {
  final Address address;
  AddAddressParams(this.address);
}

class AddAddress implements UseCase<void, AddAddressParams> {
  final AddressRepository repository;
  AddAddress(this.repository);
  @override
  Future<Either<Failure, void>> call(AddAddressParams params) =>
      repository.addAddress(params.address);
}