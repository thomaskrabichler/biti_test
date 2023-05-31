import 'package:biti_test/features/profile/profile.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  void initProfile() {
    UserDetails mockUser = const UserDetails(
      firstName: 'Kalle',
      lastName: 'Efternamn',
      personNumber: 'Förnamn',
      phoneNumber: 'Efternamn',
      description: 'Beskriving',
      status: 'Aktiv',
    );
    emit(state.copyWith(userDetails: () => mockUser));
  }

  void avatarColorChanged(Color color) =>
      emit(state.copyWith(avatarColor: () => color));

  void firstNameChanged(String name) {
    emit(
      state.copyWith(
        userDetails: () => state.userDetails.copyWith(firstName: name),
      ),
    );
    print(state.userDetails);
  }

  void lastNameChanged(String name) => emit(
        state.copyWith(
          userDetails: () => state.userDetails.copyWith(lastName: name),
        ),
      );

  void personNumberChanged(String personNumber) => emit(
        state.copyWith(
          userDetails: () =>
              state.userDetails.copyWith(personNumber: personNumber),
        ),
      );

  void phoneChanged(String phone) => emit(
        state.copyWith(
          userDetails: () => state.userDetails.copyWith(phoneNumber: phone),
        ),
      );

  void descriptionChanged(String description) => emit(
        state.copyWith(
          userDetails: () =>
              state.userDetails.copyWith(description: description),
        ),
      );

  void statusChanged(String status) => emit(
        state.copyWith(
          userDetails: () => state.userDetails.copyWith(status: status),
        ),
      );

  void clearAllUserDetails() {
    print(state.userDetails);
    if (!state.userDetails.isEmpty) {
      emit(
        state.copyWith(
          formStatus: () => FormStatus.clear,
          userDetails: () => const UserDetails(),
        ),
      );
    }
  }

  void saveUserDetails() =>
      emit(state.copyWith(formStatus: () => FormStatus.save));
}
