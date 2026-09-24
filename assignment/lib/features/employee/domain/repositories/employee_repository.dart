import '../../../../core/utils/result.dart';
import '../entities/country_entity.dart';
import '../entities/employee_entity.dart';

/// Domain contract for Employee repository operations.
abstract class EmployeeRepository {
  Future<Result<List<EmployeeEntity>>> getEmployees();
  Future<Result<EmployeeEntity>> getEmployeeById(String id);
  Future<Result<EmployeeEntity>> createEmployee(EmployeeEntity employee);
  Future<Result<EmployeeEntity>> updateEmployee(
    String id,
    EmployeeEntity employee,
  );
  Future<Result<void>> deleteEmployee(String id);
  Future<Result<List<CountryEntity>>> getCountries();
}
