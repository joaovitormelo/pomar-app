import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_states.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';

showSnackBar(context, message) {
  ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
  messenger.clearSnackBars();
  messenger.showSnackBar(SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 3),
  ));
}

class HomeEmployee extends StatefulWidget {
  const HomeEmployee({Key? key}) : super(key: key);

  @override
  State<HomeEmployee> createState() => _HomeEmployeeState();
}

class _HomeEmployeeState extends State<HomeEmployee> {
  onLogoutButtonPressed() {
    BlocProvider.of<LogoutBloc>(context).add(LogoutButtonPressed());
  }

  @override
  Widget build(BuildContext context) {
    AuthorizedEmployee authState =
        BlocProvider.of<AuthBloc>(context).state as AuthorizedEmployee;
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        width: 200,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ElevatedButton(
              style: ButtonStyle(
                  fixedSize: MaterialStateProperty.all(
                      const Size(double.infinity, 20)),
                  backgroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: onLogoutButtonPressed,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [Icon(Icons.arrow_back)],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "Sair",
                      ),
                    ],
                  ),
                  Column(),
                ],
              ),
            ),
          ),
        ),
      ),
      body: BlocListener<LogoutBloc, LogoutState>(
        listenWhen: (context, state) => state is LogoutError,
        listener: (context, state) {
          showSnackBar(context, (state as LogoutError).message);
        },
        child: Center(
          child: Column(
            children: [
              const Text("Employee Page"),
              Text("Hello, ${authState.session.user.person.name}!")
            ],
          ),
        ),
      ),
    );
  }
}
