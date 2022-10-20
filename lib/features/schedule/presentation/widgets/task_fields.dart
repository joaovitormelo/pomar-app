import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pomar_app/core/presentation/helpers/input_validation_mixin.dart';
import 'package:pomar_app/core/presentation/widgets/custom_box.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';

class TaskFieldsVariables {
  final bool isTask;
  final bool isCollective;
  final List<Employee> employeeList;
  final List<Employee> assignedEmployees;

  TaskFieldsVariables({
    required this.isTask,
    required this.isCollective,
    required this.employeeList,
    required this.assignedEmployees,
  });
}

class TaskFieldsSetters {
  final setIsTask;
  final setIsCollective;
  final setEmployeeList;
  final setAssignedEmployees;

  TaskFieldsSetters({
    required this.setIsTask,
    required this.setIsCollective,
    required this.setEmployeeList,
    required this.setAssignedEmployees,
  });
}

class TaskFields extends StatefulWidget {
  final TaskFieldsVariables variables;
  final TaskFieldsSetters setters;

  const TaskFields({
    Key? key,
    required this.variables,
    required this.setters,
  }) : super(key: key);

  @override
  State<TaskFields> createState() => _TaskFieldsState();
}

class _TaskFieldsState extends State<TaskFields> with InputValidationMixin {
  TextEditingController assignmentController = TextEditingController();

  _onIsTaskChanged(value) {
    widget.setters.setIsTask(value);
  }

  _onIsCollectiveChanged(value) {
    widget.setters.setIsCollective(value);
  }

  _onEmployeeAdded(Employee employee, setModalState, modalContext) {
    TaskFieldsVariables variables = widget.variables;
    TaskFieldsSetters setters = widget.setters;

    List<Employee> assignedEmployees = variables.assignedEmployees;
    assignedEmployees.add(employee);
    setters.setAssignedEmployees(assignedEmployees);
    List<Employee> employeeList = variables.employeeList;
    employeeList.remove(employee);
    setModalState(() {
      setters.setEmployeeList(employeeList);
    });
    if (employeeList.isEmpty) {
      Navigator.pop(modalContext);
    }
    assignmentController.text = " ";
  }

  _onEmployeeRemoved(Employee employee) {
    TaskFieldsVariables variables = widget.variables;
    TaskFieldsSetters setters = widget.setters;

    List<Employee> assignedEmployees = variables.assignedEmployees;
    assignedEmployees.remove(employee);
    setters.setAssignedEmployees(assignedEmployees);
    if (assignedEmployees.isEmpty) {
      assignmentController.text = "";
    }

    List<Employee> employeeList = variables.employeeList;
    employeeList.add(employee);
    setters.setEmployeeList(employeeList);
  }

  @override
  Widget build(BuildContext context) {
    TaskFieldsVariables variables = widget.variables;
    TaskFieldsSetters setters = widget.setters;

    List<Widget> children = [
      Row(
        children: [
          const Icon(
            FontAwesomeIcons.listCheck,
            color: Colors.grey,
            size: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 2,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 30,
      ),
      FormBuilderSwitch(
        name: "is_task",
        title: const Text(
          "É tarefa?",
          style: TextStyle(fontSize: 15),
        ),
        initialValue: variables.isTask,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          prefixIcon: Icon(Icons.check_circle_outline),
        ),
        onChanged: _onIsTaskChanged,
      ),
    ];
    if (variables.isTask) {
      children.addAll([
        const SizedBox(
          height: 30,
        ),
        FormBuilderSwitch(
          name: "is_collective",
          title: const Text(
            "É coletiva?",
            style: TextStyle(fontSize: 15),
          ),
          initialValue: variables.isCollective,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            prefixIcon: Icon(FontAwesomeIcons.userGroup),
          ),
          onChanged: _onIsCollectiveChanged,
        ),
        const SizedBox(
          height: 30,
        ),
        Column(
          children: [
            FormBuilderTextField(
              name: "employee",
              controller: assignmentController,
              readOnly: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (_) {
                if (variables.assignedEmployees.isEmpty) {
                  return "Adicione ao menos um funcionário";
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Atribuições",
                prefixIcon: Icon(FontAwesomeIcons.user),
                suffixIcon: Icon(Icons.add),
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (modalContext) => SizedBox(
                    height: MediaQuery.of(context).size.height / 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StatefulBuilder(
                        builder: (context, setModalState) {
                          List<Employee> employeeList = variables.employeeList;
                          if (employeeList.isNotEmpty) {
                            return ListView.separated(
                              separatorBuilder: (_, i) => const Divider(),
                              itemCount: employeeList.length,
                              itemBuilder: (_, i) => ListTile(
                                title: Text(employeeList[i].person.name),
                                trailing: IconButton(
                                  onPressed: () => _onEmployeeAdded(
                                    employeeList[i],
                                    setModalState,
                                    modalContext,
                                  ),
                                  icon: const Icon(Icons.add),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: Text(
                                "Sem funcionários",
                                textAlign: TextAlign.center,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            CustomBox(
              child: Builder(builder: (context) {
                if (variables.assignedEmployees.isNotEmpty) {
                  return ListView.builder(
                    itemCount: variables.assignedEmployees.length,
                    itemBuilder: (_, i) => ListTile(
                      title: Text(variables.assignedEmployees[i].person.name),
                      trailing: IconButton(
                        onPressed: () =>
                            _onEmployeeRemoved(variables.assignedEmployees[i]),
                        icon: const Icon(
                          FontAwesomeIcons.minus,
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      "Sem funcionários adicionados",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  );
                }
              }),
            ),
          ],
        )
      ]);
    }

    return Column(
      children: children,
    );
  }
}
