import 'package:assignment/core/errors/exceptions.dart';
import 'package:assignment/core/errors/failures.dart';
import 'package:assignment/core/utils/result.dart';
import 'package:assignment/features/employee/data/datasources/employee_remote_data_source.dart';
import 'package:assignment/features/employee/data/models/country_model.dart';
import 'package:assignment/features/employee/data/models/employee_model.dart';
import 'package:assignment/features/employee/data/repositories/employee_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEmployeeRemoteDataSource extends Mock
    implements EmployeeRemoteDataSource {}

class FakeEmployeeModel extends Fake implements EmployeeModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeEmployeeModel());
  });

  late MockEmployeeRemoteDataSource mockRemoteDataSource;
  late EmployeeRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockEmployeeRemoteDataSource();
    repository = EmployeeRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  const tEmployeeModel = EmployeeModel(
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

  const tCountryModel = CountryModel(
    id: '1',
    country: 'Aruba',
    flag: 'https://example.com/flag.jpg',
    createdAt: '2024-07-19T05:14:59.127Z',
  );

  group('getEmployees', () {
    test('should return Success with list of entities when remote succeeds', () async {
      when(() => mockRemoteDataSource.getEmployees())
          .thenAnswer((_) async => [tEmployeeModel]);

      final result = await repository.getEmployees();

      expect(result, isA<Success>());
      expect(result.dataOrNull?.length, 1);
      expect(result.dataOrNull?.first.name, 'Prapti');
    });

    test('should return Error with ServerFailure when remote throws ServerException', () async {
      when(() => mockRemoteDataSource.getEmployees())
          .thenThrow(const ServerException(message: 'Server error', statusCode: 500));

      final result = await repository.getEmployees();

      expect(result, isA<Error>());
      expect(result.failureOrNull, isA<ServerFailure>());
    });

    test('should return Error with NetworkFailure when remote throws NetworkException', () async {
      when(() => mockRemoteDataSource.getEmployees())
          .thenThrow(const NetworkException(message: 'Network offline'));

      final result = await repository.getEmployees();

      expect(result, isA<Error>());
      expect(result.failureOrNull, isA<NetworkFailure>());
    });
  });

  group('getEmployeeById', () {
    test('should return Success with single employee entity', () async {
      when(() => mockRemoteDataSource.getEmployeeById('12'))
          .thenAnswer((_) async => tEmployeeModel);

      final result = await repository.getEmployeeById('12');

      expect(result, isA<Success>());
      expect(result.dataOrNull?.id, '12');
    });
  });

  group('createEmployee', () {
    test('should return Success with created entity', () async {
      when(() => mockRemoteDataSource.createEmployee(any()))
          .thenAnswer((_) async => tEmployeeModel);

      final result = await repository.createEmployee(tEmployeeModel);

      expect(result, isA<Success>());
      expect(result.dataOrNull?.name, 'Prapti');
    });
  });

  group('updateEmployee', () {
    test('should return Success with updated entity', () async {
      when(() => mockRemoteDataSource.updateEmployee('12', any()))
          .thenAnswer((_) async => tEmployeeModel);

      final result = await repository.updateEmployee('12', tEmployeeModel);

      expect(result, isA<Success>());
      expect(result.dataOrNull?.name, 'Prapti');
    });
  });

  group('deleteEmployee', () {
    test('should return Success(null) when deletion succeeds', () async {
      when(() => mockRemoteDataSource.deleteEmployee('12'))
          .thenAnswer((_) async => Future.value());

      final result = await repository.deleteEmployee('12');

      expect(result, isA<Success>());
    });
  });

  group('getCountries', () {
    test('should return Success with country list', () async {
      when(() => mockRemoteDataSource.getCountries())
          .thenAnswer((_) async => [tCountryModel]);

      final result = await repository.getCountries();

      expect(result, isA<Success>());
      expect(result.dataOrNull?.first.country, 'Aruba');
    });
  });
}
