import '../../../../core/utils/result.dart';
import '../entities/country_entity.dart';
import '../entities/employee_entity.dart';
import '../repositories/employee_repository.dart';

/// Consolidated use cases for Employee & Country operations.

/// Fetches list of all employees from repository.
class GetEmployeesUseCase {
  final EmployeeRepository repository;

  GetEmployeesUseCase(this.repository);

  Future<Result<List<EmployeeEntity>>> call() {
    return repository.getEmployees();
  }
}

/// Fetches a single employee by their unique ID.
class GetEmployeeByIdUseCase {
  final EmployeeRepository repository;

  GetEmployeeByIdUseCase(this.repository);

  Future<Result<EmployeeEntity>> call(String id) {
    return repository.getEmployeeById(id);
  }
}

/// Creates a new employee record.
class CreateEmployeeUseCase {
  final EmployeeRepository repository;

  CreateEmployeeUseCase(this.repository);

  Future<Result<EmployeeEntity>> call(EmployeeEntity employee) {
    return repository.createEmployee(employee);
  }
}

/// Updates an existing employee record by ID.
class UpdateEmployeeUseCase {
  final EmployeeRepository repository;

  UpdateEmployeeUseCase(this.repository);

  Future<Result<EmployeeEntity>> call(String id, EmployeeEntity employee) {
    return repository.updateEmployee(id, employee);
  }
}

/// Deletes an employee record by ID.
class DeleteEmployeeUseCase {
  final EmployeeRepository repository;

  DeleteEmployeeUseCase(this.repository);

  Future<Result<void>> call(String id) {
    return repository.deleteEmployee(id);
  }
}

/// Fetches list of available countries with flags.
class GetCountriesUseCase {
  final EmployeeRepository repository;

  GetCountriesUseCase(this.repository);

  Future<Result<List<CountryEntity>>> call() {
    return repository.getCountries();
  }
}
