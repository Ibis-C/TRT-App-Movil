import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalMargin = size.width * 0.8;
    final spacingBetweenElements = size.height * 0.03;
    const backgroundColor = 0xFFFB3E03;
    const errorMessageColor = Colors.black;
    const buttonColor = 0xFFAF0C11;
    const bgImage = 'assets/fondo-tacos.png';
    const logoImage = 'assets/logo.png';

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(backgroundColor),
          image: DecorationImage(
            image: AssetImage(bgImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage(logoImage),
              ),

              // Button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(buttonColor),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Inicia con Google',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.login_rounded,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
