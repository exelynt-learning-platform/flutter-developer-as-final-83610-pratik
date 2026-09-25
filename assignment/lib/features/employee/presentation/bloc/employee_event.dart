import 'package:equatable/equatable.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

/// Dispatched to trigger initial loading of employees.
class LoadEmployeesEvent extends EmployeeEvent {
  const LoadEmployeesEvent();
}

/// Dispatched when user pulls to refresh the employee list.
class RefreshEmployeesEvent extends EmployeeEvent {
  const RefreshEmployeesEvent();
}
