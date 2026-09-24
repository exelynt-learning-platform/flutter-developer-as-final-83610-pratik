import 'package:assignment/core/constants/api_constants.dart';
import 'package:assignment/core/errors/exceptions.dart';
import 'package:assignment/features/employee/data/datasources/employee_remote_data_source.dart';
import 'package:assignment/features/employee/data/models/country_model.dart';
import 'package:assignment/features/employee/data/models/employee_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late MockDio mockDio;
  late EmployeeRemoteDataSourceImpl dataSource;

  setUp(() {
    mockDio = MockDio();
    dataSource = EmployeeRemoteDataSourceImpl(dio: mockDio);
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
    test('should return list of employees when statusCode is 200', () async {
      when(() => mockDio.get(ApiConstants.employeeEndpoint)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiConstants.employeeEndpoint),
          data: [tEmployeeModel.toJson()],
          statusCode: 200,
        ),
      );

      final result = await dataSource.getEmployees();

      expect(result.length, 1);
      expect(result.first.name, 'Prapti');
      verify(() => mockDio.get(ApiConstants.employeeEndpoint)).called(1);
    });

    test('should throw ServerException when response format is invalid', () async {
      when(() => mockDio.get(ApiConstants.employeeEndpoint)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiConstants.employeeEndpoint),
          data: 'Not a list',
          statusCode: 200,
        ),
      );

      expect(() => dataSource.getEmployees(), throwsA(isA<ServerException>()));
    });
  });

  group('getEmployeeById', () {
    test('should return employee when statusCode is 200', () async {
      when(() => mockDio.get(ApiConstants.employeeByIdEndpoint('12'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiConstants.employeeByIdEndpoint('12')),
          data: tEmployeeModel.toJson(),
          statusCode: 200,
        ),
      );

      final result = await dataSource.getEmployeeById('12');

      expect(result.id, '12');
      expect(result.name, 'Prapti');
      verify(() => mockDio.get(ApiConstants.employeeByIdEndpoint('12'))).called(1);
    });
  });

  group('createEmployee', () {
    test('should return created employee on 201', () async {
      when(
        () => mockDio.post(
          ApiConstants.employeeEndpoint,
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiConstants.employeeEndpoint),
          data: tEmployeeModel.toJson(),
          statusCode: 201,
        ),
      );

      final result = await dataSource.createEmployee(tEmployeeModel);

      expect(result.name, 'Prapti');
    });
  });

  group('updateEmployee', () {
    test('should return updated employee on 200', () async {
      when(
        () => mockDio.put(
          ApiConstants.employeeByIdEndpoint('12'),
          data: any(named: 'data'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiConstants.employeeByIdEndpoint('12')),
          data: tEmployeeModel.toJson(),
          statusCode: 200,
        ),
      );

      final result = await dataSource.updateEmployee('12', tEmployeeModel);

      expect(result.id, '12');
      expect(result.name, 'Prapti');
    });
  });

  group('deleteEmployee', () {
    test('should complete successfully on 200', () async {
      when(() => mockDio.delete(ApiConstants.employeeByIdEndpoint('12'))).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiConstants.employeeByIdEndpoint('12')),
          statusCode: 200,
        ),
      );

      await expectLater(dataSource.deleteEmployee('12'), completes);
      verify(() => mockDio.delete(ApiConstants.employeeByIdEndpoint('12'))).called(1);
    });
  });

  group('getCountries', () {
    test('should return list of countries on 200', () async {
      when(() => mockDio.get(ApiConstants.countryEndpoint)).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ApiConstants.countryEndpoint),
          data: [tCountryModel.toJson()],
          statusCode: 200,
        ),
      );

      final result = await dataSource.getCountries();

      expect(result.length, 1);
      expect(result.first.country, 'Aruba');
    });
  });
}
