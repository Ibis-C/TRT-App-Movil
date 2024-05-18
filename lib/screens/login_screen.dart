import 'package:flutter/material.dart';

import '../services/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthenticationService _auth = AuthenticationService();
  String? _errorMessage;

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
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                        color: errorMessageColor, fontWeight: FontWeight.w800),
                  ),
                ),

              // Email
              Container(
                width: horizontalMargin,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0)),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    labelText: 'Usuario',
                    labelStyle: TextStyle(
                      color: Color(0xFFBEBCBC),
                      fontWeight: FontWeight.w700,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                  onChanged: (value) {},
                ),
              ),

              // Spacing
              SizedBox(
                height: spacingBetweenElements,
              ),

              // Password
              Container(
                width: horizontalMargin,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0)),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    labelStyle: TextStyle(
                      color: Color(0xFFBEBCBC),
                      fontWeight: FontWeight.w700,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(12.0),
                  ),
                  onChanged: (value) {},
                ),
              ),

              // Spacing
              SizedBox(
                height: spacingBetweenElements,
              ),

              // Button
              ElevatedButton(
                onPressed: () async {
                  if (_emailController.text.isEmpty ||
                      _passwordController.text.isEmpty) {
                    setState(() => _errorMessage =
                        'TU CORREO Y CONTRASEÑA SON REQUERIDOS');
                    return;
                  } else {
                    var loginResult = await _auth.singInWithEmailAndPassword(
                        _emailController.text, _passwordController.text);
                    if (loginResult == 1 || loginResult == 2) {
                      setState(() =>
                          _errorMessage = 'ERROR EN EL USUARIO O CONTRASEÑA');
                    } else if (loginResult != null) {
                      Navigator.pushReplacementNamed(context, 'homePage');
                    } else {
                      setState(() => _errorMessage =
                          'ERROR AL INICIAR SESIÓN. INTENTALO DE NUEVO');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(buttonColor),
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
