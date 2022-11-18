import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getgroovy/authentication.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override 
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
   @override
  Widget build(BuildContext context) {
    final userController = TextEditingController(); 
    final passwordController = TextEditingController(); 
    final emailController = TextEditingController(); 
    return Scaffold(
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(10.0),
        ///Green Background with Teal Outline 
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.0, color: Colors.teal),
              left: BorderSide(width: 1.0, color: Colors.teal),
              right: BorderSide(width: 1.0, color: Colors.teal),
              bottom: BorderSide(width: 1.0, color: Colors.teal),
            ),
            color: Colors.green, 
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Register Page Screen Title: "Register Account"
              const Text(
                "Register Account",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 60,
                ),
              ),
              
              Padding(padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ///Username Textfield Box: White Background with Black Outline
                  Padding(padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: 500,
                    height: 50,
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
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(25),
                        ],
                        ///Username Textfield decorations: text icon, text appearance, font size and color
                        controller: userController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                            prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black,
                          ) ,
                          hintText: 'Username: ',
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ),
                  ///Password Textfield Box: White Background with Black Outline
                  Padding(padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: 500,
                    height: 50,
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
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(25),
                        ],
                        ///Password Textfield decorations: text icon, text appearance, font size and color
                        controller: passwordController,
                        obscureText: true,
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
                  ),
                  ///Email Textfield Box: White Background with Black Outline
                  Padding(padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: 500,
                    height: 50,
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
                      ///Email Textfield decorations: text icon, text appearance, font size and color
                      child: TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.black,
                          ) ,
                          hintText: 'Email: ',
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ),
                  ///Register Button: Navigates to Login Page
                  Padding(padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: 240.0,
                    height: 50.0,
                    child: ElevatedButton(
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      onPressed: () async {
                        bool success = 
                          await register(emailController.text, passwordController.text);
                        if (success) {
                          Navigator.of(context).pop();
                        }
                      }
                    ),
                  ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ///Login Button Prompt: "Are you already signed in?"
                      const Padding(padding: EdgeInsets.all(5.0),
                      child: Text(
                        'Are you already signed in?',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      ),
                      ),
                      ///Login Button: Navigates to Login Page
                      Padding(padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                        width: 85.0,
                        height: 70.0,
                        child: ElevatedButton(
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }
                        ),
                      ),
                      ),
                    ],
                  ),
                ],
              ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}

