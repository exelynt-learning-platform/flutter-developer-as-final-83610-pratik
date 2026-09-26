import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/country_model.dart';
import '../models/employee_model.dart';

/// Abstract contract for Remote Employee & Country API operations.
abstract class EmployeeRemoteDataSource {
  Future<List<EmployeeModel>> getEmployees();
  Future<EmployeeModel> getEmployeeById(String id);
  Future<EmployeeModel> createEmployee(EmployeeModel employee);
  Future<EmployeeModel> updateEmployee(String id, EmployeeModel employee);
  Future<void> deleteEmployee(String id);
  Future<List<CountryModel>> getCountries();
}

/// Remote Data Source implementation communicating directly with MockAPI endpoints:
/// GET /country
/// GET /employee
/// GET /employee/:id
/// POST /employee
/// PUT /employee/:id
/// DELETE /employee/:id
class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final Dio dio;

  EmployeeRemoteDataSourceImpl({Dio? dio}) : dio = dio ?? DioClient().dio;

  @override
  Future<List<EmployeeModel>> getEmployees() async {
    try {
      final response = await dio.get(ApiConstants.employeeEndpoint);
      if (response.statusCode == 200) {
        if (response.data is List) {
          return (response.data as List)
              .map((json) => EmployeeModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
        throw const ServerException(message: 'Invalid response format from server');
      }
      throw ServerException(
        message: 'Failed to fetch employees',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.error is ServerException) throw e.error as ServerException;
      if (e.error is NetworkException) throw e.error as NetworkException;
      throw ServerException(
        message: e.message ?? 'Failed to fetch employees',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<EmployeeModel> getEmployeeById(String id) async {
    try {
      final response = await dio.get(ApiConstants.employeeByIdEndpoint(id));
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return EmployeeModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(
        message: 'Employee with ID #$id not found',
        statusCode: response.statusCode ?? 404,
      );
    } on DioException catch (e) {
      if (e.error is ServerException) throw e.error as ServerException;
      if (e.error is NetworkException) throw e.error as NetworkException;
      throw ServerException(
        message: e.message ?? 'Employee with ID #$id not found',
        statusCode: e.response?.statusCode ?? 404,
      );
    }
  }

  @override
  Future<EmployeeModel> createEmployee(EmployeeModel employee) async {
    try {
      final payload = employee.toJson();
      if (payload['id'] == '0' || payload['id'] == '' || payload['id'] == null) {
        payload.remove('id');
      }
      final response = await dio.post(
        ApiConstants.employeeEndpoint,
        data: payload,
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return EmployeeModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(
        message: 'Failed to create employee',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.error is ServerException) throw e.error as ServerException;
      if (e.error is NetworkException) throw e.error as NetworkException;
      throw ServerException(
        message: e.message ?? 'Failed to create employee',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<EmployeeModel> updateEmployee(String id, EmployeeModel employee) async {
    try {
      final response = await dio.put(
        ApiConstants.employeeByIdEndpoint(id),
        data: employee.toJson(),
      );
      if (response.statusCode == 200) {
        return EmployeeModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(
        message: 'Failed to update employee',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.error is ServerException) throw e.error as ServerException;
      if (e.error is NetworkException) throw e.error as NetworkException;
      throw ServerException(
        message: e.message ?? 'Failed to update employee',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> deleteEmployee(String id) async {
    try {
      final response = await dio.delete(ApiConstants.employeeByIdEndpoint(id));
      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      }
      throw ServerException(
        message: 'Failed to delete employee',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      if (e.error is ServerException) throw e.error as ServerException;
      if (e.error is NetworkException) throw e.error as NetworkException;
      throw ServerException(
        message: e.message ?? 'Failed to delete employee',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<List<CountryModel>> getCountries() async {
    try {
      final response = await dio.get(ApiConstants.countryEndpoint);
      if (response.statusCode == 200 && response.data is List) {
        return (response.data as List)
            .map((json) => CountryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return const [];
    } catch (_) {
      return const [];
    }
  }
}
