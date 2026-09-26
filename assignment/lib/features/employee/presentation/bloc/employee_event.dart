import 'package:equatable/equatable.dart';
import '../../domain/entities/employee_entity.dart';

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

/// Dispatched when user creates a new employee.
class CreateEmployeeEvent extends EmployeeEvent {
  final EmployeeEntity employee;

  const CreateEmployeeEvent(this.employee);

  @override
  List<Object?> get props => [employee];
}

/// Dispatched when user updates an existing employee.
class UpdateEmployeeEvent extends EmployeeEvent {
  final String id;
  final EmployeeEntity employee;

  const UpdateEmployeeEvent({required this.id, required this.employee});

  @override
  List<Object?> get props => [id, employee];
}

/// Dispatched when user deletes an employee.
class DeleteEmployeeEvent extends EmployeeEvent {
  final String id;

  const DeleteEmployeeEvent(this.id);

  @override
  List<Object?> get props => [id];
}
