import '../../domain/entities/user_profile.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UserProfile updatedProfile;
  UpdateProfile(this.updatedProfile);
}