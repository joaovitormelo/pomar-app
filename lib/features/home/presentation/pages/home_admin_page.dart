import 'package:flutter/material.dart';
import 'package:pomar_app/core/presentation/routes/fluro_routes.dart';
import 'package:pomar_app/core/presentation/templates/authorized_template.dart';

const String textManageEmployeesButton = "Gerencie os funcionários";

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({Key? key}) : super(key: key);

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  onEmployeesButtonPressed() {
    Navigator.pushNamed(context, FluroRoutes.employeesRoute);
  }

  @override
  Widget build(BuildContext context) {
    return AuthorizedTemplate(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: onEmployeesButtonPressed,
              child: const Text(textManageEmployeesButton),
            ),
          ],
        ),
      ),
    );
  }
}
