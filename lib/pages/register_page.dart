import 'package:flutter/material.dart';
import 'package:getgroovy/authentication.dart';
import 'package:getgroovy/pages/login_page.dart';
import 'package:provider/provider.dart';
import '../themes/theme_provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor:
          Provider.of<ThemeProvider>(context).getCurrentTheme().navBarColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                EdgeInsets.fromLTRB(size.width * .1, 0, size.width * .1, 0),
            child: TextField(
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
                hintText: 'Email',
                labelStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.fromLTRB(size.width * .1, 0, size.width * .1, 0),
            child: TextField(
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
                hintText: 'Password',
                labelStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, size.height * .05, 0, 0),
            child: ElevatedButton(
              onPressed: () {
                _registerButton();
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(size.width * .8, size.height * .05),
                  backgroundColor: Provider.of<ThemeProvider>(context)
                      .getCurrentTheme()
                      .loginColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0))),
              child: const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }

  void _registerButton() async {
    bool success =
        await register(emailController.text, passwordController.text);

    if (success) {
      // Need to break this out somewhere
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: false, builder: (context) => const LoginPage()));
    } else {
      
    }
  }
}
