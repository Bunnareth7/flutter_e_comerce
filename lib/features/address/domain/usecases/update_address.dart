import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

class UpdateAddressParams {
  final Address address;
  UpdateAddressParams(this.address);
}

class UpdateAddress implements UseCase<void, UpdateAddressParams> {
  final AddressRepository repository;
  UpdateAddress(this.repository);
  @override
  Future<Either<Failure, void>> call(UpdateAddressParams params) =>
      repository.updateAddress(params.address);
}