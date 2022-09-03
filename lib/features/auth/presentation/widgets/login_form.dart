import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';
import 'package:pomar_app/features/auth/presentation/helpers/input_validation_mixin.dart';

class FormLogin extends StatelessWidget with InputValidationMixin {
  final GlobalKey<FormBuilderState> formKey;
  final dynamic onSubmit;

  FormLogin({Key? key, required this.formKey, required this.onSubmit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: formKey,
      child: Column(
        children: [
          FormBuilderTextField(
            name: 'email',
            validator: (email) => validateEmail(email as String),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
              labelText: "Email",
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          FormBuilderTextField(
            name: 'password',
            autovalidateMode: AutovalidateMode.onUserInteraction,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.vpn_key),
              border: OutlineInputBorder(),
              labelText: "Senha",
            ),
            validator: (password) => validatePassword(password as String),
          ),
          const SizedBox(
            height: 30,
          ),
          BlocConsumer<LoginBloc, LoginState>(
            builder: (context, state) {
              if (state is Logging) {
                return const CircularProgressIndicator();
              } else {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, 30)),
                  onPressed: onSubmit,
                  child: const Text("Login"),
                );
              }
            },
            listenWhen: (context, state) => state is Error,
            listener: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text((state as Error).message)));
            },
          ),
        ],
      ),
    );
  }
}
