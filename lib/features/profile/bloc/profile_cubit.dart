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
      languages: ['Svenska', 'Engelska'],
      allergies: ['Palsdjur'],
    );

    emit(state.copyWith(
      userDetails: () => user,
      selectedAttributes: () => initialAttributes,
    ));
  }

  void updateGender(String gender) {
    emit(
      state.copyWith(
        selectedAttributes: () =>
            state.selectedAttributes.copyWith(gender: gender),
      ),
    );
  }

  void selectLanguage(String language) {
    final selectedLanguages =
        List<String>.from(state.selectedAttributes.languages);
    if (selectedLanguages.contains(language)) {
      selectedLanguages.remove(language);
    } else {
      selectedLanguages.add(language);
    }

    emit(
      state.copyWith(
        selectedAttributes: () =>
            state.selectedAttributes.copyWith(languages: selectedLanguages),
      ),
    );
  }

  void selectAllergie(String allergie) {
    final selectedAllergies =
        List<String>.from(state.selectedAttributes.allergies);
    if (selectedAllergies.contains(allergie)) {
      selectedAllergies.remove(allergie);
    } else {
      selectedAllergies.add(allergie);
    }

    emit(
      state.copyWith(
        selectedAttributes: () =>
            state.selectedAttributes.copyWith(allergies: selectedAllergies),
      ),
    );
  }

  void addLanguage(String newLanguage) {
    final updatedLanguages = List<String>.from(state.languages);
    if (newLanguage.isNotEmpty) {
      updatedLanguages.add(newLanguage);

      emit(state.copyWith(languages: () => updatedLanguages));
    }
  }

  void addAllergie(String newAllergie) {
    final updatedAllergies = List<String>.from(state.allergies);
    if (newAllergie.isNotEmpty) {
      updatedAllergies.add(newAllergie);

      emit(state.copyWith(allergies: () => updatedAllergies));
    }
  }

  void addRule(String newRule) {
    final updatedRules = List<String>.from(state.rules);
    if (newRule.isNotEmpty) {
      updatedRules.add(newRule);

      emit(state.copyWith(rules: () => updatedRules));
    }
  }

  void deleteRule(String rule) {
    final updatedRules = List<String>.from(state.rules);
    if (updatedRules.contains(rule)) {
      updatedRules.remove(rule);

      emit(state.copyWith(rules: () => updatedRules));
    }
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
    emit(state.copyWith(formStatus: () => FormStatus.editing));
  }
}
