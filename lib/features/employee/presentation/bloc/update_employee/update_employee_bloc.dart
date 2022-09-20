import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomar_app/core/errors/error_messages.dart';
import 'package:pomar_app/features/auth/domain/entities/session.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';
import 'package:pomar_app/features/employee/domain/usecases/do_update_employee.dart';
import 'package:pomar_app/features/employee/presentation/bloc/employee_bloc.dart';

class UpdateEmployeeBloc
    extends Bloc<UpdateEmployeeEvent, UpdateEmployeeState> {
  final AuthBloc authBloc;
  final DoUpdateEmployee doUpdateEmployee;

  UpdateEmployeeBloc({required this.authBloc, required this.doUpdateEmployee})
      : super(UpdateEmployeeDefault()) {
    on<UpdateEmployeeButtonPressed>(onUpdateEmployeeButtonPressed);
  }

  onUpdateEmployeeButtonPressed(UpdateEmployeeButtonPressed event, emit) async {
    Session session = (authBloc.state as AuthorizedAdmin).session;
    emit(UpdateEmployeeLoading());
    try {
      await doUpdateEmployee(session.jwtToken, event.params);
      emit(UpdateEmployeeSuccess());
    } catch (e) {
      emit(UpdateEmployeeError(message: mapErrorToMsg(e)));
      emit(UpdateEmployeeDefault());
    }
  }
}
