import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/employee_local_data_source.dart';
import '../datasources/employee_remote_data_source.dart';
import '../models/employee_model.dart';

/// Concrete implementation of EmployeeRepository interacting with remote and local data sources.
class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeRemoteDataSource remoteDataSource;
  final EmployeeLocalDataSource? localDataSource;

  EmployeeRepositoryImpl({
    required this.remoteDataSource,
    this.localDataSource,
  });

  @override
  Future<Result<List<EmployeeEntity>>> getEmployees() async {
    try {
      final models = await remoteDataSource.getEmployees();
      if (localDataSource != null) {
        await localDataSource!.cacheEmployees(models);
      }
      return Result.success(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      if (localDataSource != null) {
        try {
          final cached = await localDataSource!.getLastEmployees();
          if (cached.isNotEmpty) {
            return Result.success(cached.map((m) => m.toEntity()).toList());
          }
        } catch (_) {}
      }
      return Result.error(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      if (localDataSource != null) {
        try {
          final cached = await localDataSource!.getLastEmployees();
          if (cached.isNotEmpty) {
            return Result.success(cached.map((m) => m.toEntity()).toList());
          }
        } catch (_) {}
      }
      return Result.error(NetworkFailure(message: e.message));
    } catch (e) {
      return Result.error(
        ServerFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<EmployeeEntity>> getEmployeeById(String id) async {
    try {
      final model = await remoteDataSource.getEmployeeById(id);
      return Result.success(model.toEntity());
    } on ServerException catch (e) {
      return Result.error(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Result.error(NetworkFailure(message: e.message));
    } catch (e) {
      return Result.error(
        ServerFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<EmployeeEntity>> createEmployee(EmployeeEntity employee) async {
    try {
      final model = EmployeeModel.fromEntity(employee);
      final created = await remoteDataSource.createEmployee(model);
      return Result.success(created.toEntity());
    } on ServerException catch (e) {
      return Result.error(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Result.error(NetworkFailure(message: e.message));
    } catch (e) {
      return Result.error(
        ServerFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<EmployeeEntity>> updateEmployee(
    String id,
    EmployeeEntity employee,
  ) async {
    try {
      final model = EmployeeModel.fromEntity(employee);
      final updated = await remoteDataSource.updateEmployee(id, model);
      return Result.success(updated.toEntity());
    } on ServerException catch (e) {
      return Result.error(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Result.error(NetworkFailure(message: e.message));
    } catch (e) {
      return Result.error(
        ServerFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> deleteEmployee(String id) async {
    try {
      await remoteDataSource.deleteEmployee(id);
      return const Result.success(null);
    } on ServerException catch (e) {
      return Result.error(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Result.error(NetworkFailure(message: e.message));
    } catch (e) {
      return Result.error(
        ServerFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<List<CountryEntity>>> getCountries() async {
    try {
      final models = await remoteDataSource.getCountries();
      return Result.success(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Result.error(
        ServerFailure(message: e.message, statusCode: e.statusCode),
      );
    } on NetworkException catch (e) {
      return Result.error(NetworkFailure(message: e.message));
    } catch (e) {
      return Result.error(
        ServerFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }
}
