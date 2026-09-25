import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/employee_usecases.dart';
import 'employee_event.dart';
import 'employee_state.dart';

/// BLoC managing Employee list state, refresh operations, and errors.
class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final GetEmployeesUseCase getEmployeesUseCase;

  EmployeeBloc({required this.getEmployeesUseCase})
      : super(const EmployeeInitialState()) {
    on<LoadEmployeesEvent>(_onLoadEmployees);
    on<RefreshEmployeesEvent>(_onRefreshEmployees);
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
    // Preserve current list if available, or signal refreshing
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
}
