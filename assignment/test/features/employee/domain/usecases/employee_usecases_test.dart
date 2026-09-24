import 'package:assignment/core/utils/result.dart';
import 'package:assignment/features/employee/domain/entities/country_entity.dart';
import 'package:assignment/features/employee/domain/entities/employee_entity.dart';
import 'package:assignment/features/employee/domain/repositories/employee_repository.dart';
import 'package:assignment/features/employee/domain/usecases/employee_usecases.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEmployeeRepository extends Mock implements EmployeeRepository {}

void main() {
  late MockEmployeeRepository mockRepository;

  setUp(() {
    mockRepository = MockEmployeeRepository();
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

  const tCountry = CountryEntity(
    id: '1',
    country: 'Aruba',
    flag: 'https://example.com/flag.jpg',
    createdAt: '2024-07-19T05:14:59.127Z',
  );

  test('GetEmployeesUseCase should call repository.getEmployees', () async {
    final useCase = GetEmployeesUseCase(mockRepository);
    when(() => mockRepository.getEmployees())
        .thenAnswer((_) async => const Result.success([tEmployee]));

    final result = await useCase();

    expect(result, isA<Success<List<EmployeeEntity>>>());
    verify(() => mockRepository.getEmployees()).called(1);
  });

  test('GetEmployeeByIdUseCase should call repository.getEmployeeById', () async {
    final useCase = GetEmployeeByIdUseCase(mockRepository);
    when(() => mockRepository.getEmployeeById('12'))
        .thenAnswer((_) async => const Result.success(tEmployee));

    final result = await useCase('12');

    expect(result, isA<Success<EmployeeEntity>>());
    verify(() => mockRepository.getEmployeeById('12')).called(1);
  });

  test('CreateEmployeeUseCase should call repository.createEmployee', () async {
    final useCase = CreateEmployeeUseCase(mockRepository);
    when(() => mockRepository.createEmployee(tEmployee))
        .thenAnswer((_) async => const Result.success(tEmployee));

    final result = await useCase(tEmployee);

    expect(result, isA<Success<EmployeeEntity>>());
    verify(() => mockRepository.createEmployee(tEmployee)).called(1);
  });

  test('UpdateEmployeeUseCase should call repository.updateEmployee', () async {
    final useCase = UpdateEmployeeUseCase(mockRepository);
    when(() => mockRepository.updateEmployee('12', tEmployee))
        .thenAnswer((_) async => const Result.success(tEmployee));

    final result = await useCase('12', tEmployee);

    expect(result, isA<Success<EmployeeEntity>>());
    verify(() => mockRepository.updateEmployee('12', tEmployee)).called(1);
  });

  test('DeleteEmployeeUseCase should call repository.deleteEmployee', () async {
    final useCase = DeleteEmployeeUseCase(mockRepository);
    when(() => mockRepository.deleteEmployee('12'))
        .thenAnswer((_) async => const Result.success(null));

    final result = await useCase('12');

    expect(result, isA<Success<void>>());
    verify(() => mockRepository.deleteEmployee('12')).called(1);
  });

  test('GetCountriesUseCase should call repository.getCountries', () async {
    final useCase = GetCountriesUseCase(mockRepository);
    when(() => mockRepository.getCountries())
        .thenAnswer((_) async => const Result.success([tCountry]));

    final result = await useCase();

    expect(result, isA<Success<List<CountryEntity>>>());
    verify(() => mockRepository.getCountries()).called(1);
  });
}
