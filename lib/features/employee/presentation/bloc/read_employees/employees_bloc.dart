import 'package:bloc/bloc.dart';
import 'package:pomar_app/core/errors/error_messages.dart';
import 'package:pomar_app/core/errors/errors.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';
import 'package:pomar_app/features/employee/domain/usecases/do_read_employees.dart';
import 'package:pomar_app/features/employee/presentation/bloc/employee_bloc.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final AuthBloc authBloc;
  final DoReadEmployees doReadEmployees;

  EmployeesBloc({required this.authBloc, required this.doReadEmployees})
      : super(EmployeesNoData()) {
    on<LoadEmployees>(onLoadEmployees);
    on<DeleteEmployeeBlocEmmitedLoading>(onDeleteEmployeeBlocEmmitedLoading);
    on<DeleteEmployeeBlocEmmitedSuccess>(onDeleteEmployeeBlocEmmitedSuccess);
    on<DeleteEmployeeBlocEmmitedError>(onDeleteEmployeeBlocEmmitedError);
  }

  onDeleteEmployeeBlocEmmitedLoading(
      DeleteEmployeeBlocEmmitedLoading event, emit) async {
    emit(EmployeesLoading());
  }

  onDeleteEmployeeBlocEmmitedSuccess(
      DeleteEmployeeBlocEmmitedSuccess event, emit) async {
    add(LoadEmployees());
  }

  onDeleteEmployeeBlocEmmitedError(DeleteEmployeeBlocEmmitedError event,
      Emitter<EmployeesState> emit) async {
    emit(EmployeesError(msg: event.msg));
    add(LoadEmployees());
  }

  onLoadEmployees(LoadEmployees event, Emitter<EmployeesState> emit) async {
    Session session = (authBloc.state as AuthorizedAdmin).session;
    emit(EmployeesLoading());
    try {
      List<Employee> employees = await doReadEmployees(session.jwtToken);
      emit(EmployeesHasData(employees: employees));
    } catch (e) {
      if (e is NoDataError) {
        emit(EmployeesNoData());
      } else {
        emit(EmployeesError(msg: mapErrorToMsg(e)));
      }
    }
  }
}
