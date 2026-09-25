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

  const EmployeeLoadedState({required this.employees});

  @override
  List<Object?> get props => [employees];
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
