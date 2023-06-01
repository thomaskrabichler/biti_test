part of 'profile_cubit.dart';

enum ProfileStatus {
  initial,
  loading,
  failure,
  success,
}

enum FormStatus {
  initial,
  editing,
  save,
  clear,
}

@immutable
class ProfileState extends Equatable {
  final Color avatarColor;
  final UserDetails userDetails;
  final UserAttributes selectedAttributes;
  final List<String> rules;
  final List<String> languages;
  final List<String> allergies;
  final List<Assignment> assignments;
  final FormStatus formStatus;

  const ProfileState({
    this.avatarColor = Colors.blueGrey,
    this.userDetails = const UserDetails(),
    this.selectedAttributes = const UserAttributes(),
    this.rules = const [],
    this.assignments = const [],
    this.languages = const [
      'Svenska',
      'Engelska',
      'Italienska',
      'Spanska',
      'Arabiska',
    ],
    this.allergies = const ['Palsdjur'],
    this.formStatus = FormStatus.initial,
  });

  ProfileState copyWith({
    FormStatus Function()? formStatus,
    Color Function()? avatarColor,
    UserDetails Function()? userDetails,
    UserAttributes Function()? selectedAttributes,
    List<String> Function()? rules,
    List<String> Function()? languages,
    List<String> Function()? allergies,
    List<Assignment> Function()? assignments,
  }) {
    return ProfileState(
      formStatus: formStatus != null ? formStatus() : this.formStatus,
      avatarColor: avatarColor != null ? avatarColor() : this.avatarColor,
      userDetails: userDetails != null ? userDetails() : this.userDetails,
      selectedAttributes: selectedAttributes != null
          ? selectedAttributes()
          : this.selectedAttributes,
      rules: rules != null ? rules() : this.rules,
      languages: languages != null ? languages() : this.languages,
      allergies: allergies != null ? allergies() : this.allergies,
      assignments: assignments != null ? assignments() : this.assignments,
    );
  }

  @override
  List<Object?> get props => [
        avatarColor,
        userDetails,
        selectedAttributes,
        rules,
        assignments,
        formStatus,
        languages,
        allergies,
      ];
}
