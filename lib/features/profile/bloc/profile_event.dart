part of 'profile_bloc.dart';
class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class ProfileAvatarColorChanged extends ProfileEvent {

    final Color color;

  const ProfileAvatarColorChanged(this.color);
  @override
  List<Object?> get props => [color];
}
