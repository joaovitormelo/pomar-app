import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/core/presentation/routes/fluro_routes.dart';
import 'package:pomar_app/core/utils/Utils.dart';
import 'package:pomar_app/features/employee/presentation/bloc/bloc.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmployeesBloc>(
      create: (_) => Globals.sl<EmployeesBloc>(),
      child: const EmployeesBody(),
    );
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

  onAddEmployeeButtonPressed() {
    print('Here');
    Navigator.pushReplacementNamed(context, FluroRoutes.addEmployeeRoute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Funcionários"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: onAddEmployeeButtonPressed,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocConsumer<EmployeesBloc, EmployeesState>(
          listenWhen: (_, state) => state is EmployeesError,
          listener: (context, state) {
            Utils.showSnackBar(context, (state as EmployeesError).msg);
          },
          builder: (context, state) {
            print(state);
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
                      itemBuilder: (context) {
                        return ['Editar']
                            .map((String option) => PopupMenuItem(
                                value: option, child: Text(option)))
                            .toList();
                      },
                    ),
                  ),
                ),
              );
            } else if (state is EmployeesLoading) {
              return Container(
                height: double.infinity,
                child: const Center(child: CircularProgressIndicator()),
              );
            } else if (state is EmployeesNoData) {
              return Container(
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
              return Container(
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
