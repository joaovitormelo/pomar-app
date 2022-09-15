import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/core/presentation/routes/fluro_routes.dart';
import 'package:pomar_app/core/utils/utils.dart';
import 'package:pomar_app/features/employee/domain/usecases/do_create_employee.dart';
import 'package:pomar_app/features/employee/presentation/bloc/bloc.dart';
import 'package:pomar_app/core/presentation/helpers/input_validation_mixin.dart';

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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  passwordsMustMatch(String password) {
    if (_passwordKey.currentState?.value == password) {
      return null;
    } else {
      return "As senhas devem corresponder";
    }
  }

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
        title: Text("Criar Funcionário"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: FormBuilder(
            key: _formKey,
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'name',
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    labelText: "Nome",
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (name) => validateName(name),
                ),
                const SizedBox(
                  height: 30,
                ),
                FormBuilderTextField(
                  name: 'email',
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) => validateEmail(email),
                ),
                const SizedBox(
                  height: 30,
                ),
                FormBuilderTextField(
                  name: 'phone',
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    border: OutlineInputBorder(),
                    labelText: "Telefone",
                  ),
                  inputFormatters: [
                    TextInputMask(
                      mask: [
                        '(99) 9999-9999',
                        '(99) 9 9999-9999',
                      ],
                    ),
                  ],
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (phone) => validatePhone(phone),
                ),
                const SizedBox(
                  height: 30,
                ),
                FormBuilderTextField(
                  name: 'password',
                  key: _passwordKey,
                  obscureText: _obscurePassword,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.vpn_key),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: "Senha",
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (password) => validatePassword(password),
                ),
                const SizedBox(
                  height: 30,
                ),
                FormBuilderTextField(
                  name: 'confirmPassword',
                  obscureText: _obscureConfirmPassword,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.vpn_key),
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                    labelText: "Confirme a senha",
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (password) =>
                      validatePassword(password, passwordsMustMatch),
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocConsumer<CreateEmployeeBloc, CreateEmployeeState>(
                  listener: (context, state) {
                    if (state is CreateEmployeeError) {
                      Utils.showSnackBar(context, state.message);
                    } else if (state is CreateEmployeeSuccess) {
                      Navigator.pushReplacementNamed(
                          context, FluroRoutes.employeesRoute);
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
                      child: Text("Criar"),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
