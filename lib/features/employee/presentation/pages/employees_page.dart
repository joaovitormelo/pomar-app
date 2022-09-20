import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/core/presentation/routes/fluro_routes.dart';
import 'package:pomar_app/core/utils/Utils.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';
import 'package:pomar_app/features/employee/domain/usecases/do_delete_employee.dart';
import 'package:pomar_app/features/employee/presentation/bloc/employee_bloc.dart';

const textEmployeesPageTitle = "Funcionários";
const actionEditar = "Editar";
const actionExcluir = "Excluir";
const listEmployeeActions = [actionEditar, actionExcluir];

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      EmployeesBloc employeesBloc = Globals.sl<EmployeesBloc>();
      return MultiBlocProvider(
        providers: [
          BlocProvider<EmployeesBloc>(create: (_) => employeesBloc),
          BlocProvider<DeleteEmployeeBloc>(
            create: (_) => DeleteEmployeeBloc(
              authBloc: Globals.sl<AuthBloc>(),
              employeesBloc: employeesBloc,
              doDeleteEmployee: Globals.sl<DoDeleteEmployee>(),
            ),
          ),
        ],
        child: const EmployeesBody(),
      );
    });
  }
}

class EmployeesBody extends StatefulWidget {
  const EmployeesBody({Key? key}) : super(key: key);

  @override
  State<EmployeesBody> createState() => _EmployeesBodyState();
}

class _EmployeesBodyState extends State<EmployeesBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<EmployeesBloc>(context).add(LoadEmployees());
  }

  onEmployeeActionTapped(String action, Employee employee) {
    if (action == actionEditar) {
      Navigator.pushNamed(context, FluroRoutes.editEmployeeRoute,
              arguments: employee)
          .then((value) =>
              BlocProvider.of<EmployeesBloc>(context).add(LoadEmployees()));
    } else {
      BlocProvider.of<DeleteEmployeeBloc>(context).add(
        DeleteEmployeeButtonPressed(idEmployee: employee.idEmployee),
      );
    }
  }

  onAddEmployeeButtonPressed() {
    Navigator.pushNamed(context, FluroRoutes.addEmployeeRoute).then((value) =>
        BlocProvider.of<EmployeesBloc>(context).add(LoadEmployees()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(textEmployeesPageTitle),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddEmployeeButtonPressed,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocConsumer<EmployeesBloc, EmployeesState>(
          listener: (context, state) {
            if (state is EmployeesError) {
              Utils.showSnackBar(context, state.msg);
            } else if (state is EmployeesOperationError) {
              Utils.showSnackBar(context, state.msg);
            }
          },
          builder: (context, state) {
            if (state is EmployeesHasData) {
              return ListView.builder(
                itemCount: state.employees.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(state.employees[index].person.name),
                  trailing: SizedBox(
                    width: 30,
                    child: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (String action) => onEmployeeActionTapped(
                          action, state.employees[index]),
                      itemBuilder: (context) {
                        return listEmployeeActions
                            .map((String option) => PopupMenuItem(
                                  value: option,
                                  child: Text(option),
                                ))
                            .toList();
                      },
                    ),
                  ),
                ),
              );
            } else if (state is EmployeesLoading ||
                state is EmployeesOperationError) {
              return const SizedBox(
                height: double.infinity,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state is EmployeesNoData) {
              return SizedBox(
                height: double.infinity,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Lista Vazia",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is EmployeesError) {
              return SizedBox(
                height: double.infinity,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.warning,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Erro",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
