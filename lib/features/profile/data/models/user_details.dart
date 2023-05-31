import 'package:equatable/equatable.dart';

class UserDetails extends Equatable {
  final String firstName;
  final String lastName;
  final String personNumber;
  final String phoneNumber;
  final String description;
  final String status;

  const UserDetails({
    this.firstName = '',
    this.lastName = '',
    this.personNumber = '',
    this.phoneNumber = '',
    this.description = '',
    this.status = '',
  });

  UserDetails copyWith({
    String? firstName,
    String? lastName,
    String? personNumber,
    String? phoneNumber,
    String? description,
    String? status,
  }) {
    return UserDetails(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      personNumber: personNumber ?? this.personNumber,
      description: description ?? this.description,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
    );
  }

  bool get isEmpty =>
    firstName.isEmpty &&
    lastName.isEmpty &&
    personNumber.isEmpty &&
    phoneNumber.isEmpty &&
    description.isEmpty &&
    status.isEmpty;

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
