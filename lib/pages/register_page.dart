import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        child: Padding(
          padding: const EdgeInsets.all(10.0),

          ///Green Background with Teal Outline
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.teal, width: 1.0),
              color: Colors.green,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                //Screen Title: "Register Account"
                const Text(
                  "Register Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 60,
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ///Username Textfield Box: White Background with Black Outline
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 500,
                            ),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 3.0, color: Colors.black),
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
                                ),
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
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 500,
                            ),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 3.0, color: Colors.black),
                              color: Colors.white,
                            ),
                            child: TextField(
                              ///Password word count limit set to 25 (Can adjust later)
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(25),
                              ],
                              controller: passwordController,
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
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          child: Container(
                            constraints: const BoxConstraints(
                              maxWidth: 500,
                            ),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 3.0, color: Colors.black),
                              color: Colors.white,
                            ),
                            child: TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(20),
                                prefixIcon: Icon(
                                  Icons.email,
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
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
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              'Already have an account?',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: SizedBox(
                              height: 35.0,
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
                                  }),
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
