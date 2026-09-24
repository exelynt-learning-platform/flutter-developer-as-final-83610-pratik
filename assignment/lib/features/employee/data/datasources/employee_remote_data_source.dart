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

/// Implementation using Dio client connecting to mockapi.io.
class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final Dio dio;

  EmployeeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<EmployeeModel>> getEmployees() async {
    try {
      final response = await dio.get(ApiConstants.employeeEndpoint);
      if (response.statusCode == 200 && response.data is List) {
        final list = response.data as List<dynamic>;
        return list
            .map((item) => EmployeeModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw ServerException(
        message: 'Invalid response format from employee API',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Failed to fetch employees: ${e.toString()}');
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
        message: 'Employee with ID $id not found',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Failed to fetch employee: ${e.toString()}');
    }
  }

  @override
  Future<EmployeeModel> createEmployee(EmployeeModel employee) async {
    try {
      final response = await dio.post(
        ApiConstants.employeeEndpoint,
        data: employee.toJson(),
      );
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data is Map<String, dynamic>) {
        return EmployeeModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(
        message: 'Failed to create employee',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Failed to create employee: ${e.toString()}');
    }
  }

  @override
  Future<EmployeeModel> updateEmployee(String id, EmployeeModel employee) async {
    try {
      final response = await dio.put(
        ApiConstants.employeeByIdEndpoint(id),
        data: employee.toJson(),
      );
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return EmployeeModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(
        message: 'Failed to update employee $id',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Failed to update employee: ${e.toString()}');
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
        message: 'Failed to delete employee $id',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Failed to delete employee: ${e.toString()}');
    }
  }

  @override
  Future<List<CountryModel>> getCountries() async {
    try {
      final response = await dio.get(ApiConstants.countryEndpoint);
      if (response.statusCode == 200 && response.data is List) {
        final list = response.data as List<dynamic>;
        return list
            .map((item) => CountryModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      throw ServerException(
        message: 'Invalid response format from country API',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      if (e is ServerException || e is NetworkException) rethrow;
      throw ServerException(message: 'Failed to fetch countries: ${e.toString()}');
    }
  }

  Exception _handleDioException(DioException e) {
    if (e.error is ServerException) return e.error as ServerException;
    if (e.error is NetworkException) return e.error as NetworkException;
    return DioClient.mapDioException(e);
  }
}
