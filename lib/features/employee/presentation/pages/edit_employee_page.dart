import 'dart:developer';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/core/presentation/routes/fluro_routes.dart';
import 'package:pomar_app/core/utils/utils.dart';
import 'package:pomar_app/features/auth/domain/entities/person.dart';
import 'package:pomar_app/features/auth/domain/entities/user.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';
import 'package:pomar_app/core/presentation/helpers/input_validation_mixin.dart';
import 'package:pomar_app/features/employee/domain/usecases/do_update_employee.dart';
import 'package:pomar_app/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:pomar_app/features/employee/presentation/widgets/employee_form.dart';

const textTitleEditEmployee = "Editar Funcionário";
const textButtonUpdateEmployee = "Editar";

class EditEmployeePage extends StatelessWidget {
  final Employee employee;

  const EditEmployeePage({Key? key, required this.employee}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateEmployeeBloc>(
      create: (context) => Globals.sl<UpdateEmployeeBloc>(),
      child: EditEmployeeBody(employee: employee),
    );
  }
}

class EditEmployeeBody extends StatefulWidget {
  final Employee employee;

  const EditEmployeeBody({Key? key, required this.employee}) : super(key: key);

  @override
  State<EditEmployeeBody> createState() => _EditEmployeeBodyState();
}

class _EditEmployeeBodyState extends State<EditEmployeeBody>
    with InputValidationMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  initState() {
    super.initState();
    fillForm(widget.employee);
  }

  fillForm(Employee employee) {
    _nameController.text = employee.person.name;
    _emailController.text = employee.person.email;
    _phoneController.text =
        UtilBrasilFields.obterTelefone(employee.person.phone);
  }

  onUpdateEmployeeButtonPressed() {
    bool isValid = _formKey.currentState?.validate() as bool;
    if (isValid) {
      final fields = _formKey.currentState?.fields;
      var phone = fields?["phone"]?.value as String;
      phone = phone.replaceAll("(", "");
      phone = phone.replaceAll(")", "");
      phone = phone.replaceAll("-", "");
      phone = phone.replaceAll(" ", "");
      BlocProvider.of<UpdateEmployeeBloc>(context).add(
        UpdateEmployeeButtonPressed(
          params: UpdateEmployeeParams(
            person: Person(
              idPerson: widget.employee.person.idPerson,
              name: fields?["name"]?.value?.trim(),
              email: fields?["email"]?.value?.trim(),
              phone: phone.trim(),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(textTitleEditEmployee),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              EmployeeForm(
                formKey: _formKey,
                isEdit: true,
                keys: null,
                controllers: EmployeeFieldsControllers(
                    nameController: _nameController,
                    emailController: _emailController,
                    phoneController: _phoneController),
              ),
              const SizedBox(
                height: 30,
              ),
              BlocConsumer<UpdateEmployeeBloc, UpdateEmployeeState>(
                listener: (context, state) {
                  if (state is UpdateEmployeeError) {
                    Utils.showSnackBar(context, state.message);
                  } else if (state is UpdateEmployeeSuccess) {
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  if (state is UpdateEmployeeLoading) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 30),
                    ),
                    onPressed: onUpdateEmployeeButtonPressed,
                    child: const Text(textButtonUpdateEmployee),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
