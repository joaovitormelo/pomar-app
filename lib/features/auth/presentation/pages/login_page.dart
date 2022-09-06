import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';
import 'package:pomar_app/features/auth/presentation/widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
  }

  void onSubmit() {
    bool isValid = _formKey.currentState?.validate() as bool;
    if (isValid) {
      final fields = _formKey.currentState?.fields;
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          email: fields?['email']?.value,
          password: fields?['password']?.value,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 250,
                    child: const Image(
                        image: AssetImage('assets/images/pomar-logo.png')),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  FormLogin(formKey: _formKey, onSubmit: onSubmit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginHandler {}
