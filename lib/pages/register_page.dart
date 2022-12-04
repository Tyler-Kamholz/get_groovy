import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getgroovy/authentication.dart';
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
      body: Stack(children: [
        Positioned(
            top: -size.height * .1,
            right: 0,
            child: RotatedBox(
              quarterTurns: 2,
              child: Image.asset(
                "app_assets/light_background_login.png",
                scale: .85,
              ),
            )),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                  EdgeInsets.fromLTRB(size.width * .1, 0, size.width * .1, 0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Provider.of<ThemeProvider>(context)
                          .getCurrentTheme()
                          .iconColor,
                    ),
                    color: Provider.of<ThemeProvider>(context)
                        .getCurrentTheme()
                        .navBarColor,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: TextField(
                  controller: emailController,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
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
            ),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(size.width * .1, 0, size.width * .1, 0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Provider.of<ThemeProvider>(context)
                          .getCurrentTheme()
                          .iconColor,
                    ),
                    color: Provider.of<ThemeProvider>(context)
                        .getCurrentTheme()
                        .navBarColor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
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
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  void _registerButton() async {
    bool success =
        await register(emailController.text, passwordController.text);
    if (success) {
      _loginButton();
    }
  }

  void _loginButton() async {
    bool success = await signIn(emailController.text, passwordController.text);
    if (success) {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((value) {
        if (!value.exists) {
          FirebaseFirestore.instance.collection('users').doc(user.uid).set(
            {
              'display_name': user.email,
              'email': user.email,
              'user_id': user.uid,
            },
          );
        }
      });
    }
  }
}
