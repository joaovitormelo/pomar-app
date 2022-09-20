import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomar_app/core/errors/error_messages.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_states.dart';
import 'package:pomar_app/features/employee/domain/usecases/do_delete_employee.dart';
import 'package:pomar_app/features/employee/presentation/bloc/employee_bloc.dart';

class DeleteEmployeeBloc
    extends Bloc<DeleteEmployeeEvent, DeleteEmployeeState> {
  final AuthBloc authBloc;
  final EmployeesBloc employeesBloc;
  final DoDeleteEmployee doDeleteEmployee;

  DeleteEmployeeBloc({
    required this.authBloc,
    required this.employeesBloc,
    required this.doDeleteEmployee,
  }) : super(DeleteEmployeeDefault()) {
    on<DeleteEmployeeButtonPressed>(onDeleteEmployeeButtonPressed);
  }

  onDeleteEmployeeButtonPressed(DeleteEmployeeButtonPressed event, emit) async {
    Session session = (authBloc.state as AuthorizedAdmin).session;
    employeesBloc.add(DeleteEmployeeBlocEmmitedLoading());
    try {
      await doDeleteEmployee(session.jwtToken, event.idEmployee);
      employeesBloc.add(DeleteEmployeeBlocEmmitedSuccess());
    } catch (e) {
      employeesBloc.add(DeleteEmployeeBlocEmmitedError(msg: mapErrorToMsg(e)));
    }
  }
}
