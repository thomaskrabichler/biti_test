import 'package:equatable/equatable.dart';

class UserAttributes extends Equatable {
  final String gender;
  final List<String> languages;
  final List<String> allergies;

  const UserAttributes({
    this.gender = '',
    this.languages = const [],
    this.allergies = const [],
  });

  UserAttributes copyWith({
    String? gender,
    List<String>? languages,
    List<String>? allergies,
  }) {
    return UserAttributes(
      gender: gender ?? this.gender,
      languages: languages ?? this.languages,
      allergies: allergies ?? this.allergies,
    );
  }
  @override
  List<Object?> get props => [gender, languages, allergies];
}
