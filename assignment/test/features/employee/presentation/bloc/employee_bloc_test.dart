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
class MockCreateEmployeeUseCase extends Mock implements CreateEmployeeUseCase {}
class MockUpdateEmployeeUseCase extends Mock implements UpdateEmployeeUseCase {}
class MockDeleteEmployeeUseCase extends Mock implements DeleteEmployeeUseCase {}

void main() {
  late MockGetEmployeesUseCase mockGetEmployeesUseCase;
  late MockCreateEmployeeUseCase mockCreateEmployeeUseCase;
  late MockUpdateEmployeeUseCase mockUpdateEmployeeUseCase;
  late MockDeleteEmployeeUseCase mockDeleteEmployeeUseCase;
  late EmployeeBloc employeeBloc;

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

  setUp(() {
    mockGetEmployeesUseCase = MockGetEmployeesUseCase();
    mockCreateEmployeeUseCase = MockCreateEmployeeUseCase();
    mockUpdateEmployeeUseCase = MockUpdateEmployeeUseCase();
    mockDeleteEmployeeUseCase = MockDeleteEmployeeUseCase();

    employeeBloc = EmployeeBloc(
      getEmployeesUseCase: mockGetEmployeesUseCase,
      createEmployeeUseCase: mockCreateEmployeeUseCase,
      updateEmployeeUseCase: mockUpdateEmployeeUseCase,
      deleteEmployeeUseCase: mockDeleteEmployeeUseCase,
    );
  });

  tearDown(() {
    employeeBloc.close();
  });

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

  group('CRUD Operations in EmployeeBloc', () {
    blocTest<EmployeeBloc, EmployeeState>(
      'CreateEmployeeEvent adds employee to the list and emits success message',
      seed: () => const EmployeeLoadedState(employees: [tEmployee]),
      build: () {
        when(() => mockCreateEmployeeUseCase(tEmployee))
            .thenAnswer((_) async => const Result.success(tEmployee));
        return employeeBloc;
      },
      act: (bloc) => bloc.add(const CreateEmployeeEvent(tEmployee)),
      expect: () => [
        const EmployeeLoadedState(employees: [tEmployee], isOperating: true),
        const EmployeeLoadedState(
          employees: [tEmployee, tEmployee],
          isOperating: false,
          successMessage: 'Prapti added successfully',
        ),
      ],
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'UpdateEmployeeEvent updates employee in the list and emits success message',
      seed: () => const EmployeeLoadedState(employees: [tEmployee]),
      build: () {
        const updated = EmployeeEntity(
          id: '12',
          name: 'Prapti Updated',
          email: 'prapti@gmail.com',
          mobile: '9985744152',
          country: 'india',
          state: 'MAHARASHTRA',
          district: 'Solapur',
          avatar: '',
          createdAt: '2026-09-11T17:22:12.472Z',
        );
        when(() => mockUpdateEmployeeUseCase('12', updated))
            .thenAnswer((_) async => const Result.success(updated));
        return employeeBloc;
      },
      act: (bloc) => bloc.add(
        const UpdateEmployeeEvent(
          id: '12',
          employee: EmployeeEntity(
            id: '12',
            name: 'Prapti Updated',
            email: 'prapti@gmail.com',
            mobile: '9985744152',
            country: 'india',
            state: 'MAHARASHTRA',
            district: 'Solapur',
            avatar: '',
            createdAt: '2026-09-11T17:22:12.472Z',
          ),
        ),
      ),
      expect: () => [
        const EmployeeLoadedState(employees: [tEmployee], isOperating: true),
        const EmployeeLoadedState(
          employees: [
            EmployeeEntity(
              id: '12',
              name: 'Prapti Updated',
              email: 'prapti@gmail.com',
              mobile: '9985744152',
              country: 'india',
              state: 'MAHARASHTRA',
              district: 'Solapur',
              avatar: '',
              createdAt: '2026-09-11T17:22:12.472Z',
            ),
          ],
          isOperating: false,
          successMessage: 'Prapti Updated updated successfully',
        ),
      ],
    );

    blocTest<EmployeeBloc, EmployeeState>(
      'DeleteEmployeeEvent removes employee from list and emits success message',
      seed: () => const EmployeeLoadedState(employees: [tEmployee]),
      build: () {
        when(() => mockDeleteEmployeeUseCase('12'))
            .thenAnswer((_) async => const Result.success(null));
        return employeeBloc;
      },
      act: (bloc) => bloc.add(const DeleteEmployeeEvent('12')),
      expect: () => [
        const EmployeeLoadedState(employees: [tEmployee], isOperating: true),
        const EmployeeEmptyState(),
      ],
    );
  });
}
