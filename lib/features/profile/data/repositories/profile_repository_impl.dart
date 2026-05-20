import 'package:dartz/dartz.dart';
import 'package:e_com_app/features/profile/data/model/user_profile_model.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;
  ProfileRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final profile = await localDataSource.getProfile();
      return Right(profile);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(UserProfile profile) async {
    try {
      final model = UserProfileModel(
        id: profile.id,
        email: profile.email,
        name: profile.name,
        phone: profile.phone,
        address: profile.address,
        avatarUrl: profile.avatarUrl,
      );
      await localDataSource.saveProfile(model);
      return Right(profile);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}