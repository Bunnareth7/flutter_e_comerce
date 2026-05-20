import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpParams {
  final String email;
  final String password;
  final String name;
  SignUpParams({required this.email, required this.password, required this.name});
}

class SignUpUseCase implements UseCase<User, SignUpParams> {
  final AuthRepository repository;
  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) {
    return repository.signUp(params.email, params.password, params.name);
  }
}