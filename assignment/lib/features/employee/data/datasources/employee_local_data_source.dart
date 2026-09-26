import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/employee_model.dart';

/// Contract for local caching of employee records using SharedPreferences.
abstract class EmployeeLocalDataSource {
  Future<List<EmployeeModel>> getLastEmployees();
  Future<void> cacheEmployees(List<EmployeeModel> employees);
  Future<void> clearCache();
}

const String cachedEmployeesKey = 'CACHED_EMPLOYEES_LIST';

class EmployeeLocalDataSourceImpl implements EmployeeLocalDataSource {
  final SharedPreferences sharedPreferences;

  EmployeeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<EmployeeModel>> getLastEmployees() async {
    final jsonString = sharedPreferences.getString(cachedEmployeesKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(jsonString) as List<dynamic>;
        return decoded
            .map((item) => EmployeeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (_) {
        throw const CacheException(message: 'Failed to decode cached employees');
      }
    } else {
      throw const CacheException(message: 'No cached employee data found');
    }
  }

  @override
  Future<void> cacheEmployees(List<EmployeeModel> employees) async {
    final listJson = employees.map((e) => e.toJson()).toList();
    await sharedPreferences.setString(cachedEmployeesKey, jsonEncode(listJson));
  }

  @override
  Future<void> clearCache() async {
    await sharedPreferences.remove(cachedEmployeesKey);
  }
}
