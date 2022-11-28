import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../authentication.dart';
import '../themes/theme_provider.dart';
import 'main_page.dart';

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
    super.initState();
    emailController.text = 'qweqwe@gmail.com';
    passwordController.text = 'qweqwe';
  }

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
                _loginButton();
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

      var firestore = FirebaseFirestore.instance;
      await firestore.collection('users').add({
        'display_name': user.email,
        'email': user.email,
        'user_id': user.uid,
      });

      // todo This should hook into a streamController to detect logged in state
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(MaterialPageRoute(
          fullscreenDialog: false, builder: (context) => const MainPage()));
      //Navigator.of(context).pop();
    }
  }
}
