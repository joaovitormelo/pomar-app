import 'package:flutter/material.dart';
import 'package:pomar_app/core/presentation/templates/auth_template.dart';

const String pathLogoAsset = 'assets/images/pomar-logo.png';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      child: Scaffold(
        body: Center(
          child: Column(
            children: const [
              SizedBox(
                width: 250,
                child: Image(image: AssetImage(pathLogoAsset)),
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
