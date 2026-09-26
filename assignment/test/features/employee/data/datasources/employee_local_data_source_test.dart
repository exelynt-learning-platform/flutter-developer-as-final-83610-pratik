import 'dart:convert';
import 'package:assignment/core/errors/exceptions.dart';
import 'package:assignment/features/employee/data/datasources/employee_local_data_source.dart';
import 'package:assignment/features/employee/data/models/employee_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;
  late EmployeeLocalDataSourceImpl dataSource;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    dataSource = EmployeeLocalDataSourceImpl(sharedPreferences: mockPrefs);
  });

  const tEmployeeModel = EmployeeModel(
    id: '12',
    name: 'Prapti',
    email: 'prapti@gmail.com',
    mobile: '9985744152',
    country: 'india',
    state: 'MAHARASHTRA',
    district: 'Solapur',
    avatar: '',
    createdAt: '2026-09-11T17:22:12.472Z',
  );

  group('EmployeeLocalDataSourceImpl', () {
    test('getLastEmployees returns cached employees when available', () async {
      final jsonString = jsonEncode([tEmployeeModel.toJson()]);
      when(() => mockPrefs.getString(cachedEmployeesKey)).thenReturn(jsonString);

      final result = await dataSource.getLastEmployees();

      expect(result.length, 1);
      expect(result.first.name, 'Prapti');
    });

    test('getLastEmployees throws CacheException when no cache is stored', () async {
      when(() => mockPrefs.getString(cachedEmployeesKey)).thenReturn(null);

      expect(() => dataSource.getLastEmployees(), throwsA(isA<CacheException>()));
    });

    test('cacheEmployees encodes and saves employee list to sharedPreferences', () async {
      when(() => mockPrefs.setString(cachedEmployeesKey, any()))
          .thenAnswer((_) async => true);

      await dataSource.cacheEmployees([tEmployeeModel]);

      verify(() => mockPrefs.setString(cachedEmployeesKey, any())).called(1);
    });

    test('clearCache removes the key from sharedPreferences', () async {
      when(() => mockPrefs.remove(cachedEmployeesKey)).thenAnswer((_) async => true);

      await dataSource.clearCache();

      verify(() => mockPrefs.remove(cachedEmployeesKey)).called(1);
    });
  });
}
