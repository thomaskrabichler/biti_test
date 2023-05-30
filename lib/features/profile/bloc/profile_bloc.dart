import 'package:biti_test/features/profile/profile.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';
part 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(const ProfileState()) {
    on<ProfileAvatarColorChanged>(_onAvatarColorChanged);
  }

  void _onAvatarColorChanged(
    ProfileAvatarColorChanged event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(avatarColor: () => event.color));
  }
}
