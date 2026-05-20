import '../../domain/entities/user_profile.dart';

abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final UserProfile updatedProfile;
  UpdateProfileEvent(this.updatedProfile);
}