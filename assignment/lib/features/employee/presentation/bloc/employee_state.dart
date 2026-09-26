import 'package:equatable/equatable.dart';
import '../../domain/entities/employee_entity.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

class EmployeeInitialState extends EmployeeState {
  const EmployeeInitialState();
}

class EmployeeLoadingState extends EmployeeState {
  final bool isRefreshing;
  const EmployeeLoadingState({this.isRefreshing = false});

  @override
  List<Object?> get props => [isRefreshing];
}

class EmployeeLoadedState extends EmployeeState {
  final List<EmployeeEntity> employees;
  final bool isOperating;
  final String? successMessage;
  final String? errorMessage;

  const EmployeeLoadedState({
    required this.employees,
    this.isOperating = false,
    this.successMessage,
    this.errorMessage,
  });

  EmployeeLoadedState copyWith({
    List<EmployeeEntity>? employees,
    bool? isOperating,
    String? successMessage,
    String? errorMessage,
  }) {
    return EmployeeLoadedState(
      employees: employees ?? this.employees,
      isOperating: isOperating ?? this.isOperating,
      successMessage: successMessage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [employees, isOperating, successMessage, errorMessage];
}

class EmployeeEmptyState extends EmployeeState {
  const EmployeeEmptyState();
}

class EmployeeErrorState extends EmployeeState {
  final String errorMessage;

  const EmployeeErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
