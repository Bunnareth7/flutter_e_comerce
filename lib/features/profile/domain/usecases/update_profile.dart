import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileParams {
  final UserProfile profile;
  UpdateProfileParams(this.profile);
}

class UpdateProfile implements UseCase<UserProfile, UpdateProfileParams> {
  final ProfileRepository repository;
  UpdateProfile(this.repository);
  @override
  Future<Either<Failure, UserProfile>> call(UpdateProfileParams params) => repository.updateProfile(params.profile);
}