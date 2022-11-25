import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomar_app/core/presentation/routes/fluro_routes.dart';
import 'package:pomar_app/core/presentation/templates/auth_template.dart';
import 'package:pomar_app/core/utils/utils.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';

const String textLogoutButton = "Sair";

class AuthorizedTemplate extends StatefulWidget {
  final Widget body;
  const AuthorizedTemplate({Key? key, required this.body}) : super(key: key);

  @override
  State<AuthorizedTemplate> createState() => _AuthorizedTemplateState();
}

class _AuthorizedTemplateState extends State<AuthorizedTemplate> {
  onLogoutButtonPressed() {
    BlocProvider.of<LogoutBloc>(context).add(LogoutButtonPressed());
  }

  onScheduleTapped() {
    Navigator.of(context).pushNamed(FluroRoutes.scheduleAdminRoute);
  }

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      child: Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          width: 200,
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: ListView(
                  children: [
                    const DrawerHeader(
                      child: Text(
                        "Menu lateral",
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    ListTile(
                      title: const Text("Agenda"),
                      leading: const Icon(Icons.schedule),
                      onTap: onScheduleTapped,
                    )
                  ],
                ),
              ),
              Align(
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
                              textLogoutButton,
                            ),
                          ],
                        ),
                        Column(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: BlocListener<LogoutBloc, LogoutState>(
          listener: (context, state) {
            if (state is LogoutError) {
              Utils.showSnackBar(context, state.message);
            }
          },
          child: widget.body,
        ),
      ),
    );
  }
}
