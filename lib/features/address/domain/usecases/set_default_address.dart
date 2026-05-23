import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/address_repository.dart';

class SetDefaultAddressParams {
  final String id;
  SetDefaultAddressParams(this.id);
}

class SetDefaultAddress implements UseCase<void, SetDefaultAddressParams> {
  final AddressRepository repository;
  SetDefaultAddress(this.repository);
  @override
  Future<Either<Failure, void>> call(SetDefaultAddressParams params) =>
      repository.setDefaultAddress(params.id);
}