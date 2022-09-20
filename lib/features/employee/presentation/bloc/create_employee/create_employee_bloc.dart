import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomar_app/core/errors/error_messages.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_states.dart';
import 'package:pomar_app/features/employee/domain/usecases/do_create_employee.dart';
import 'package:pomar_app/features/employee/presentation/bloc/employee_bloc.dart';

class CreateEmployeeBloc
    extends Bloc<CreateEmployeeEvent, CreateEmployeeState> {
  final AuthBloc authBloc;
  final DoCreateEmployee doCreateEmployee;

  CreateEmployeeBloc({required this.authBloc, required this.doCreateEmployee})
      : super(CreateEmployeeDefault()) {
    on<CreateEmployeeButtonPressed>(onCreateEmployeeButtonPressed);
  }

  onCreateEmployeeButtonPressed(CreateEmployeeButtonPressed event, emit) async {
    Session session = (authBloc.state as AuthorizedAdmin).session;
    emit(CreateEmployeeLoading());
    try {
      await doCreateEmployee(session.jwtToken, event.createEmployeeParams);
      emit(CreateEmployeeSuccess());
    } catch (e) {
      emit(CreateEmployeeError(message: mapErrorToMsg(e)));
      emit(CreateEmployeeDefault());
    }
  }
}
