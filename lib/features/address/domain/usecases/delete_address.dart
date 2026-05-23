import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/address_repository.dart';

class DeleteAddressParams {
  final String id;
  DeleteAddressParams(this.id);
}

class DeleteAddress implements UseCase<void, DeleteAddressParams> {
  final AddressRepository repository;
  DeleteAddress(this.repository);
  @override
  Future<Either<Failure, void>> call(DeleteAddressParams params) =>
      repository.deleteAddress(params.id);
}