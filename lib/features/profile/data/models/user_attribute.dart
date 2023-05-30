import 'package:equatable/equatable.dart';

class UserAttribute extends Equatable {
  final String attributeName;
  final List<String> attributeContent;

  const UserAttribute({
    required this.attributeName,
    required this.attributeContent,
  });

  @override
  List<Object?> get props => throw UnimplementedError();
}
