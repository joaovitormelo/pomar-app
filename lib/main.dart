import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/core/initializer.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';
import 'package:pomar_app/features/auth/presentation/pages/login_page.dart';

void main() async {
  await Initializer().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (_) => Globals.authBloc,
      child: const PomarApp(),
    );
  }
}

class PomarApp extends StatefulWidget {
  const PomarApp({Key? key}) : super(key: key);

  @override
  State<PomarApp> createState() => _PomarAppState();
}

class _PomarAppState extends State<PomarApp> {
  @override
  void initState() {
    super.initState();

    BlocProvider.of<AuthBloc>(context).add(AppInitialized());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomar App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          print(state);
          if (state is Unauthorized) {
            return BlocProvider<LoginBloc>(
              create: (_) => Globals.loginBloc,
              child: const LoginPage(),
            );
          }
          if (state is AuthorizedAdmin) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Column(
                  children: [
                    const Text("Admin Page"),
                    Text("Hello, ${state.session.user.person.name}!")
                  ],
                ),
              ),
            );
          }
          if (state is AuthorizedEmployee) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Column(
                  children: [
                    const Text("Employee Page"),
                    Text("Hello, ${state.session.user.person.name}!")
                  ],
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: Container(
                width: 250,
                child: const Image(
                    image: AssetImage('assets/images/pomar-logo.png')),
              ),
            ),
          );
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
