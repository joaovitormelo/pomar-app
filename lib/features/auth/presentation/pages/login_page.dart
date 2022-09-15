import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pomar_app/core/presentation/templates/auth_template.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';
import 'package:pomar_app/features/auth/presentation/widgets/login_form.dart';

const String pathLogoAsset = 'assets/images/pomar-logo.png';
const String textLoginButton = "Login";

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
    return AuthTemplate(
      child: Scaffold(
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
                      child: const Image(image: AssetImage(pathLogoAsset)),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    FormLogin(formKey: _formKey),
                    const SizedBox(
                      height: 30,
                    ),
                    BlocConsumer<LoginBloc, LoginState>(
                      builder: (context, state) {
                        if (state is Logging) {
                          return const CircularProgressIndicator();
                        }
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize:
                                Size(MediaQuery.of(context).size.width, 30),
                          ),
                          onPressed: onSubmit,
                          child: const Text(textLoginButton),
                        );
                      },
                      listenWhen: (context, state) => state is LoginError,
                      listener: (context, state) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text((state as LoginError).message)));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
