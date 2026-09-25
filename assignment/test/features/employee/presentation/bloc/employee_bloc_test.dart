import 'package:assignment/core/errors/failures.dart';
import 'package:assignment/core/utils/result.dart';
import 'package:assignment/features/employee/domain/entities/employee_entity.dart';
import 'package:assignment/features/employee/domain/usecases/employee_usecases.dart';
import 'package:assignment/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:assignment/features/employee/presentation/bloc/employee_event.dart';
import 'package:assignment/features/employee/presentation/bloc/employee_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetEmployeesUseCase extends Mock implements GetEmployeesUseCase {}

void main() {
  late MockGetEmployeesUseCase mockGetEmployeesUseCase;
  late EmployeeBloc employeeBloc;

  setUp(() {
    mockGetEmployeesUseCase = MockGetEmployeesUseCase();
    employeeBloc = EmployeeBloc(getEmployeesUseCase: mockGetEmployeesUseCase);
  });

  tearDown(() {
    employeeBloc.close();
  });

  const tEmployee = EmployeeEntity(
    id: '12',
    name: 'Prapti',
    email: 'prapti@gmail.com',
    mobile: '9985744152',
    country: 'india',
    state: 'MAHARASHTRA',
    district: 'Solapur',
    avatar: 'https://example.com/avatar.jpg',
    createdAt: '2026-09-11T17:22:12.472Z',
  );

  test('initial state should be EmployeeInitialState', () {
    expect(employeeBloc.state, const EmployeeInitialState());
  });

  group('LoadEmployeesEvent', () {
    blocTest<EmployeeBloc, EmployeeState>(
      'emits [EmployeeLoadingState, EmployeeLoadedState] when data fetch succeeds',
      build: () {
        when(() => mockGetEmployeesUseCase())
            .thenAnswer((_) async => const Result.success([tEmployee]));
        return employeeBloc;
      },
      act: (bloc) => bloc.add(const LoadEmployeesEvent()),
      expect: () => [
        const EmployeeLoadingState(isRefreshing: false),
        const EmployeeLoadedState(employees: [tEmployee]),
      ],
      verify: (_) {
        verify(() => mockGetEmployeesUseCase()).called(1);
      },
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [EmployeeLoadingState, EmployeeEmptyState] when data fetch returns empty list',
      build: () {
        when(() => mockGetEmployeesUseCase())
            .thenAnswer((_) async => const Result.success([]));
        return employeeBloc;
      },
      act: (bloc) => bloc.add(const LoadEmployeesEvent()),
      expect: () => [
        const EmployeeLoadingState(isRefreshing: false),
        const EmployeeEmptyState(),
      ],
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'emits [EmployeeLoadingState, EmployeeErrorState] when data fetch fails',
      build: () {
        when(() => mockGetEmployeesUseCase()).thenAnswer(
          (_) async => const Result.error(
            ServerFailure(message: 'Failed to fetch employees from server'),
          ),
        );
        return employeeBloc;
      },
      act: (bloc) => bloc.add(const LoadEmployeesEvent()),
      expect: () => [
        const EmployeeLoadingState(isRefreshing: false),
        const EmployeeErrorState(errorMessage: 'Failed to fetch employees from server'),
      ],
    );
  });

  group('RefreshEmployeesEvent', () {
    blocTest<EmployeeBloc, EmployeeState>(
      'emits [EmployeeLoadingState(isRefreshing: true), EmployeeLoadedState] on refresh success',
      build: () {
        when(() => mockGetEmployeesUseCase())
            .thenAnswer((_) async => const Result.success([tEmployee]));
        return employeeBloc;
      },
      act: (bloc) => bloc.add(const RefreshEmployeesEvent()),
      expect: () => [
        const EmployeeLoadingState(isRefreshing: true),
        const EmployeeLoadedState(employees: [tEmployee]),
      ],
    );
  });
}
