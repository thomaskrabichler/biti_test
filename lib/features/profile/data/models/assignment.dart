import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Assignment extends Equatable {
  final String title;
  final String assignmentType;
  final List<String> planningType;
  final List<String> time;

  const Assignment({
    required this.title,
    required this.assignmentType,
    required this.planningType,
    required this.time,
  });

  @override
  List<Object?> get props => [
        title,
        assignmentType,
        planningType,
        time,
      ];
}
