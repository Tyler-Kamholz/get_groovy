import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getgroovy/pages/home_page.dart';
import 'package:getgroovy/pages/main_page.dart';
import 'package:getgroovy/pages/register_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:getgroovy/pages/login_page.dart';
import 'package:getgroovy/authentication.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void initState() {
    emailController.text = 'qweqwe@gmail.com';
    passwordController.text = 'qweqwe';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          decoration: const BoxDecoration(
            color: Colors.green,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ///Login Page Screen Title: "Welcome, Let's Get Groovy"
              const Text(
                "Welcome, Let's Get Groovy",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 45,
                ),
                textAlign: TextAlign.center,
              ),

              ///QR Image (Sizing needs adjustment without causing pixel overflow)
              Column(
                children: [
                  ///Username Textfield Box: White Background with Black Outline
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 3.0, color: Colors.black),
                          left: BorderSide(width: 3.0, color: Colors.black),
                          right: BorderSide(width: 3.0, color: Colors.black),
                          bottom: BorderSide(width: 3.0, color: Colors.black),
                        ),
                        color: Colors.white,
                      ),
                      child: TextField(
                        ///Username word count limit set to 25 (Can adjust later)
                        inputFormatters: [LengthLimitingTextInputFormatter(25)],
                        ///Username Textfield decorations: text icon, text appearance, font size and color
                        controller: emailController,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          hintText: 'Email: ',
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),

                  ///Password Textfield Box: White Background with Black Outline
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 3.0, color: Colors.black),
                          left: BorderSide(width: 3.0, color: Colors.black),
                          right: BorderSide(width: 3.0, color: Colors.black),
                          bottom: BorderSide(width: 3.0, color: Colors.black),
                        ),
                        color: Colors.white,
                      ),
                      child: TextField(
                        ///Password word count limit set to 25 (Can adjust later)
                        inputFormatters: [LengthLimitingTextInputFormatter(25)],
                        ///Password Textfield decorations: text icon, text appearance, font size and color
                        controller: passwordController,
                        obscureText: true,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          hintText: 'Password: ',
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ///Login Button: Temporarily Navigates to Settings Page(Needs to be re-routed)
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          child: ElevatedButton(
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            onPressed: _loginButton,
                          ),
                        ),
                      ),

                      ///New? Button (Register Button): Navigates to Register Page
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          child: ElevatedButton(
                              child: const Text(
                                'New?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              onPressed: _registerButton),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _loginButton() async {
    bool success = await signIn(emailController.text, passwordController.text);
    if (success) {
      Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: false, builder: (context) => const MainPage()));
      //Navigator.of(context).pop();
    }
  }

  void _registerButton() {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: false, builder: (context) => const RegisterPage()));
  }
}
