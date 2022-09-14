import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomar_app/core/presentation/routes/fluro_routes.dart';

import '../../../features/auth/presentation/bloc/bloc.dart';

class AuthTemplate extends StatelessWidget {
  final Widget child;
  const AuthTemplate({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthorized) {
          Navigator.pushNamed(context, FluroRoutes.loginRoute);
        } else if (state is AuthorizedAdmin) {
          Navigator.pushNamed(context, FluroRoutes.homeAdminRoute);
        } else if (state is AuthorizedEmployee) {
          Navigator.pushNamed(context, FluroRoutes.homeEmployeeRoute);
        } else {
          Navigator.pushNamed(context, FluroRoutes.loadingRoute);
        }
      },
      child: child,
    );
  }
}
