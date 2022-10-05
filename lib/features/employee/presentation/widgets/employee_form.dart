import 'package:easy_mask/easy_mask.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pomar_app/core/presentation/helpers/input_validation_mixin.dart';
import 'package:pomar_app/core/presentation/routes/fluro_routes.dart';
import 'package:pomar_app/core/utils/Utils.dart';
import 'package:pomar_app/features/employee/presentation/bloc/employee_bloc.dart';

class EmployeeFieldsKeys {
  final GlobalKey<FormBuilderFieldState> passwordKey;

  EmployeeFieldsKeys({
    required this.passwordKey,
  });
}

class EmployeeFieldsControllers {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  EmployeeFieldsControllers({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
  });
}

class EmployeeForm extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final bool isEdit;
  final EmployeeFieldsKeys? keys;
  final EmployeeFieldsControllers? controllers;

  const EmployeeForm({
    Key? key,
    required this.formKey,
    required this.isEdit,
    required this.keys,
    required this.controllers,
  }) : super(key: key);

  @override
  State<EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> with InputValidationMixin {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  passwordsMustMatch(String password) {
    if (widget.keys?.passwordKey.currentState?.value == password) {
      return null;
    } else {
      return "As senhas devem corresponder";
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> fields = [
      FormBuilderTextField(
        name: 'name',
        controller: widget.controllers?.nameController,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.person),
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
        controller: widget.controllers?.emailController,
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
        controller: widget.controllers?.phoneController,
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
              '(99) 99999-9999',
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
    ];
    if (!widget.isEdit) {
      fields.addAll([
        FormBuilderTextField(
          name: 'password',
          key: widget.keys?.passwordKey,
          obscureText: _obscurePassword,
          enableSuggestions: false,
          autocorrect: false,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.vpn_key),
            suffixIcon: IconButton(
              icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off),
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
              validatePassword(password, extraValidation: passwordsMustMatch),
        ),
        const SizedBox(
          height: 30,
        ),
      ]);
    }

    return FormBuilder(
      key: widget.formKey,
      child: Column(
        children: fields,
      ),
    );
  }
}
