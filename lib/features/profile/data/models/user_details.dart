import 'package:equatable/equatable.dart';

enum UserStatus {
  active,
  inactive,
}

class UserDetails extends Equatable {
  final String firstName;
  final String lastName;
  final String personNumber;
  final String phoneNumber;
  final String description;
  final UserStatus status;

  const UserDetails({
    this.firstName = '',
    this.lastName = '',
    this.personNumber = '',
    this.phoneNumber = '',
    this.description = '',
    this.status = UserStatus.active,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        personNumber,
        phoneNumber,
        description,
        status,
      ];
}
