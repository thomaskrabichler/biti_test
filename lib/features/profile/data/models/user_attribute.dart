import 'package:equatable/equatable.dart';

class UserAttributes extends Equatable {
  final String gender;
  final List<String> language;
  final List<String> allergies;

  const UserAttributes({
    this.gender = '',
    this.language = const [],
    this.allergies = const [],
  });

  UserAttributes copyWith({
    String? gender,
    List<String>? language,
    List<String>? allergies,
  }) {
    return UserAttributes(
      gender: gender ?? this.gender,
      language: language ?? this.language,
      allergies: allergies ?? this.allergies,
    );
  }
  @override
  List<Object?> get props => [gender, language, allergies];
}
