import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getgroovy/pages/main_page.dart';
import 'package:getgroovy/pages/register_page.dart';
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
    super.initState();
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
                            onPressed: _loginButton,
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),

                      ///New? Button (Register Button): Navigates to Register Page
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          child: ElevatedButton(
                            onPressed: _registerButton,
                            child: const Text(
                              'New?',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                          ),
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
      var user = FirebaseAuth.instance.currentUser;
      if(user == null) {
        return;
      }

      FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((value) {
        if(!value.exists) {
          FirebaseFirestore.instance.collection('users').doc(user.uid).set(
            {
              'display_name': user.email,
              'email': user.email,
              'user_id': user.uid,
            },
          );
        }
      });


/*
      var firestore = FirebaseFirestore.instance;
      await firestore.collection('users').add(
        {
          'display_name': user.email,
          'email': user.email,
          'user_id': user.uid,
        }
      );
*/
      // todo This should hook into a streamController to detect logged in state
      // ignore: use_build_context_synchronously
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
