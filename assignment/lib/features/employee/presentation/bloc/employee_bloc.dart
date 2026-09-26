import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/usecases/employee_usecases.dart';
import 'employee_event.dart';
import 'employee_state.dart';

/// BLoC managing complete Employee CRUD state, refresh operations, and feedback.
class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final GetEmployeesUseCase getEmployeesUseCase;
  final CreateEmployeeUseCase? createEmployeeUseCase;
  final UpdateEmployeeUseCase? updateEmployeeUseCase;
  final DeleteEmployeeUseCase? deleteEmployeeUseCase;

  EmployeeBloc({
    required this.getEmployeesUseCase,
    this.createEmployeeUseCase,
    this.updateEmployeeUseCase,
    this.deleteEmployeeUseCase,
  }) : super(const EmployeeInitialState()) {
    on<LoadEmployeesEvent>(_onLoadEmployees);
    on<RefreshEmployeesEvent>(_onRefreshEmployees);
    on<CreateEmployeeEvent>(_onCreateEmployee);
    on<UpdateEmployeeEvent>(_onUpdateEmployee);
    on<DeleteEmployeeEvent>(_onDeleteEmployee);
  }

  Future<void> _onLoadEmployees(
    LoadEmployeesEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(const EmployeeLoadingState(isRefreshing: false));
    final result = await getEmployeesUseCase();

    result.fold(
      onSuccess: (employees) {
        if (employees.isEmpty) {
          emit(const EmployeeEmptyState());
        } else {
          emit(EmployeeLoadedState(employees: employees));
        }
      },
      onError: (failure) {
        emit(EmployeeErrorState(errorMessage: failure.message));
      },
    );
  }

  Future<void> _onRefreshEmployees(
    RefreshEmployeesEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(const EmployeeLoadingState(isRefreshing: true));
    final result = await getEmployeesUseCase();

    result.fold(
      onSuccess: (employees) {
        if (employees.isEmpty) {
          emit(const EmployeeEmptyState());
        } else {
          emit(EmployeeLoadedState(employees: employees));
        }
      },
      onError: (failure) {
        emit(EmployeeErrorState(errorMessage: failure.message));
      },
    );
  }

  Future<void> _onCreateEmployee(
    CreateEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    final currentList = state is EmployeeLoadedState
        ? (state as EmployeeLoadedState).employees
        : <EmployeeEntity>[];

    if (state is EmployeeLoadedState) {
      emit((state as EmployeeLoadedState).copyWith(isOperating: true));
    }

    if (createEmployeeUseCase != null) {
      final result = await createEmployeeUseCase!(event.employee);
      result.fold(
        onSuccess: (created) {
          final updated = [created, ...currentList];
          emit(EmployeeLoadedState(
            employees: updated,
            isOperating: false,
            successMessage: '${created.name} added successfully',
          ));
        },
        onError: (failure) {
          if (state is EmployeeLoadedState) {
            emit((state as EmployeeLoadedState).copyWith(
              isOperating: false,
              errorMessage: failure.message,
            ));
          } else {
            emit(EmployeeErrorState(errorMessage: failure.message));
          }
        },
      );
    } else {
      // Fallback optimistic local addition
      final updated = [event.employee, ...currentList];
      emit(EmployeeLoadedState(
        employees: updated,
        isOperating: false,
        successMessage: '${event.employee.name} added successfully',
      ));
    }
  }

  Future<void> _onUpdateEmployee(
    UpdateEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    final currentList = state is EmployeeLoadedState
        ? (state as EmployeeLoadedState).employees
        : <EmployeeEntity>[];

    if (state is EmployeeLoadedState) {
      emit((state as EmployeeLoadedState).copyWith(isOperating: true));
    }

    if (updateEmployeeUseCase != null) {
      final result = await updateEmployeeUseCase!(event.id, event.employee);
      result.fold(
        onSuccess: (updatedEmployee) {
          final updatedList = currentList.map((e) {
            return e.id == event.id ? updatedEmployee : e;
          }).toList();
          emit(EmployeeLoadedState(
            employees: updatedList,
            isOperating: false,
            successMessage: '${updatedEmployee.name} updated successfully',
          ));
        },
        onError: (failure) {
          if (state is EmployeeLoadedState) {
            emit((state as EmployeeLoadedState).copyWith(
              isOperating: false,
              errorMessage: failure.message,
            ));
          } else {
            emit(EmployeeErrorState(errorMessage: failure.message));
          }
        },
      );
    } else {
      // Fallback optimistic local update
      final updatedList = currentList.map((e) {
        return e.id == event.id ? event.employee : e;
      }).toList();
      emit(EmployeeLoadedState(
        employees: updatedList,
        isOperating: false,
        successMessage: '${event.employee.name} updated successfully',
      ));
    }
  }

  Future<void> _onDeleteEmployee(
    DeleteEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    final currentList = state is EmployeeLoadedState
        ? (state as EmployeeLoadedState).employees
        : <EmployeeEntity>[];

    final employeeToDelete = currentList.firstWhere(
      (e) => e.id == event.id,
      orElse: () => EmployeeEntity(
        id: event.id,
        name: 'Employee',
        email: '',
        mobile: '',
        country: '',
        state: '',
        district: '',
        avatar: '',
        createdAt: '',
      ),
    );

    if (state is EmployeeLoadedState) {
      emit((state as EmployeeLoadedState).copyWith(isOperating: true));
    }

    if (deleteEmployeeUseCase != null) {
      final result = await deleteEmployeeUseCase!(event.id);
      result.fold(
        onSuccess: (_) {
          final remaining = currentList.where((e) => e.id != event.id).toList();
          if (remaining.isEmpty) {
            emit(const EmployeeEmptyState());
          } else {
            emit(EmployeeLoadedState(
              employees: remaining,
              isOperating: false,
              successMessage: '${employeeToDelete.name} deleted successfully',
            ));
          }
        },
        onError: (failure) {
          if (state is EmployeeLoadedState) {
            emit((state as EmployeeLoadedState).copyWith(
              isOperating: false,
              errorMessage: failure.message,
            ));
          } else {
            emit(EmployeeErrorState(errorMessage: failure.message));
          }
        },
      );
    } else {
      // Fallback optimistic local deletion
      final remaining = currentList.where((e) => e.id != event.id).toList();
      if (remaining.isEmpty) {
        emit(const EmployeeEmptyState());
      } else {
        emit(EmployeeLoadedState(
          employees: remaining,
          isOperating: false,
          successMessage: '${employeeToDelete.name} deleted successfully',
        ));
      }
    }
  }
}
