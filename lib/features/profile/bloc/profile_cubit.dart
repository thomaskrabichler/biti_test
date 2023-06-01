import 'package:biti_test/features/profile/profile.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(const ProfileState());

  void initProfile() {
    UserDetails user = const UserDetails(
      firstName: 'Kalle',
      lastName: 'Efternamn',
      personNumber: 'Förnamn',
      phoneNumber: 'Efternamn',
      description: 'Beskriving',
      status: 'Aktiv',
    );

    UserAttributes initialAttributes = const UserAttributes(
      gender: 'Man',
      language: const ['Svenska', 'Engelska'],
      allergies: const ['Palsdjur'],
    );

    emit(state.copyWith(
      userDetails: () => user,
      selectedAttributes: () => initialAttributes,
    ));
  }

  void updateGender(String gender) {
    emit(state.copyWith(
        selectedAttributes: () =>
            state.selectedAttributes.copyWith(gender: gender)));
    print(state.selectedAttributes.gender);
  }

  void avatarColorChanged(Color color) => emit(
        state.copyWith(
          formStatus: () => FormStatus.editing,
          avatarColor: () => color,
        ),
      );

  void firstNameChanged(String name) {
    emit(
      state.copyWith(
        formStatus: () => FormStatus.editing,
        userDetails: () => state.userDetails.copyWith(firstName: name),
      ),
    );
  }

  void lastNameChanged(String name) => emit(
        state.copyWith(
          formStatus: () => FormStatus.editing,
          userDetails: () => state.userDetails.copyWith(lastName: name),
        ),
      );

  void personNumberChanged(String personNumber) => emit(
        state.copyWith(
          formStatus: () => FormStatus.editing,
          userDetails: () =>
              state.userDetails.copyWith(personNumber: personNumber),
        ),
      );

  void phoneChanged(String phone) => emit(
        state.copyWith(
          formStatus: () => FormStatus.editing,
          userDetails: () => state.userDetails.copyWith(phoneNumber: phone),
        ),
      );

  void descriptionChanged(String description) => emit(
        state.copyWith(
          formStatus: () => FormStatus.editing,
          userDetails: () =>
              state.userDetails.copyWith(description: description),
        ),
      );

  void statusChanged(String status) => emit(
        state.copyWith(
          formStatus: () => FormStatus.editing,
          userDetails: () => state.userDetails.copyWith(status: status),
        ),
      );

  void clearAllUserDetails() {
    emit(state.copyWith(
      formStatus: () => FormStatus.clear,
      userDetails: () => const UserDetails(),
    ));
  }

  void saveUserDetails() {
    //...writing to db
    emit(state.copyWith(formStatus: () => FormStatus.save));
  }

  void formChanged() {
    print(state.userDetails);
    emit(state.copyWith(formStatus: () => FormStatus.editing));
  }
}
