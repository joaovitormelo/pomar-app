import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomar_app/core/presentation/templates/authorized_template.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';

class HomeEmployee extends StatefulWidget {
  const HomeEmployee({Key? key}) : super(key: key);

  @override
  State<HomeEmployee> createState() => _HomeEmployeesState();
}

class _HomeEmployeesState extends State<HomeEmployee> {
  onLogoutButtonPressed() {
    BlocProvider.of<LogoutBloc>(context).add(LogoutButtonPressed());
  }

  @override
  Widget build(BuildContext context) {
    AuthorizedEmployee authState =
        BlocProvider.of<AuthBloc>(context).state as AuthorizedEmployee;
    return AuthorizedTemplate(
      body: Center(
        child: Column(
          children: [
            const Text("Employee Page"),
            Text("Hello, ${authState.session.user.person.name}!")
          ],
        ),
      ),
    );
  }
}
