import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/core/initializer.dart';
import 'package:pomar_app/core/presentation/routes/fluro_routes.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pomar_app/features/whatsapp/connection/presentation/bloc/whatsapp_connection_bloc.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

void main() async {
  await Initializer().init();
  FluroRoutes.setupRouter();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => Globals.sl<AuthBloc>()),
      BlocProvider(create: (_) => Globals.sl<LoginBloc>()),
      BlocProvider(create: (_) => Globals.sl<LogoutBloc>()),
      BlocProvider(create: (_) => Globals.sl<WhatsAppConnectionBloc>()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      debugShowCheckedModeBanner: false,
      initialRoute: FluroRoutes.loadingRoute,
      onGenerateRoute: FluroRoutes.router.generator,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', "BR")],
      locale: const Locale('pt', "BR"),
      home: Container(),
    );
  }
}
