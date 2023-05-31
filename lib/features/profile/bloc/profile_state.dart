part of 'profile_cubit.dart';

enum ProfileStatus {
  initial,
  loading,
  failure,
  success,
}

enum FormStatus {
  initial,
  save,
  clear,
}


@immutable
class ProfileState extends Equatable {
  final Color avatarColor;
  final UserDetails userDetails;
  final List<UserAttribute> userAttributes;
  final List<String> rules;
  final List<Assignment> assignments;
  final FormStatus formStatus;

  const ProfileState({
    this.avatarColor = Colors.blueGrey,
    this.userDetails = const UserDetails(),
    this.userAttributes = const [],
    this.rules = const [],
    this.assignments = const [],
    this.formStatus = FormStatus.initial,
  });

  ProfileState copyWith({
    FormStatus Function()? formStatus,
    Color Function()? avatarColor,
    UserDetails Function()? userDetails,
    List<UserAttribute> Function()? userAttributes,
    List<String> Function()? rules,
    List<Assignment> Function()? assignments,
  }) {
    return ProfileState(
      formStatus: formStatus != null ? formStatus() : this.formStatus,
      avatarColor: avatarColor != null ? avatarColor() : this.avatarColor,
      userDetails: userDetails != null ? userDetails() : this.userDetails,
      userAttributes:
          userAttributes != null ? userAttributes() : this.userAttributes,
      rules: rules != null ? rules() : this.rules,
      assignments: assignments != null ? assignments() : this.assignments,
    );
  }

  @override
  List<Object?> get props => [
        avatarColor,
        userDetails,
        userAttributes,
        rules,
        assignments,
        formStatus,
      ];
}
