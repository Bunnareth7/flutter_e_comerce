import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/address.dart';
import '../repositories/address_repository.dart';

class GetAddresses implements UseCase<List<Address>, NoParams> {
  final AddressRepository repository;
  GetAddresses(this.repository);
  @override
  Future<Either<Failure, List<Address>>> call(NoParams params) =>
      repository.getAddresses();
}