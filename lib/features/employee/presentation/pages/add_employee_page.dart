import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/core/utils/Utils.dart';
import 'package:pomar_app/features/employee/domain/usecases/do_create_employee.dart';
import 'package:pomar_app/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:pomar_app/core/presentation/helpers/input_validation_mixin.dart';
import 'package:pomar_app/features/employee/presentation/widgets/employee_form.dart';

const textTitleAddEmployee = "Criar Funcionário";
const textButtonCreateEmployee = "Criar";

class AddEmployeePage extends StatelessWidget {
  const AddEmployeePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateEmployeeBloc>(
      create: (context) => Globals.sl<CreateEmployeeBloc>(),
      child: const AddEmployeeBody(),
    );
  }
}

class AddEmployeeBody extends StatefulWidget {
  const AddEmployeeBody({Key? key}) : super(key: key);

  @override
  State<AddEmployeeBody> createState() => _AddEmployeeBodyState();
}

class _AddEmployeeBodyState extends State<AddEmployeeBody>
    with InputValidationMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  final _passwordKey = GlobalKey<FormBuilderFieldState>();

  onCreateEmployeeButtonPressed() {
    bool isValid = _formKey.currentState?.validate() as bool;
    if (isValid) {
      final fields = _formKey.currentState?.fields;
      var phone = fields?["phone"]?.value as String;
      phone = phone.replaceAll("(", "");
      phone = phone.replaceAll(")", "");
      phone = phone.replaceAll("-", "");
      phone = phone.replaceAll(" ", "");
      BlocProvider.of<CreateEmployeeBloc>(context).add(
        CreateEmployeeButtonPressed(
          createEmployeeParams: CreateEmployeeParams(
            name: fields?["name"]?.value?.trim(),
            email: fields?["email"]?.value?.trim(),
            phone: phone.trim(),
            password: fields?["password"]?.value?.trim(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(textTitleAddEmployee),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              EmployeeForm(
                formKey: _formKey,
                isEdit: false,
                keys: EmployeeFieldsKeys(passwordKey: _passwordKey),
                controllers: null,
              ),
              const SizedBox(
                height: 30,
              ),
              BlocConsumer<CreateEmployeeBloc, CreateEmployeeState>(
                listener: (context, state) {
                  if (state is CreateEmployeeError) {
                    Utils.showSnackBar(context, state.message);
                  } else if (state is CreateEmployeeSuccess) {
                    Navigator.pop(context);
                  }
                },
                builder: (context, state) {
                  if (state is CreateEmployeeLoading) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 30),
                    ),
                    onPressed: onCreateEmployeeButtonPressed,
                    child: const Text(textButtonCreateEmployee),
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
