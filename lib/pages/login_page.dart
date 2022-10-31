import 'dart:html';
import 'package:flutter/material.dart';
import 'package:getgroovy/pages/home_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:getgroovy/pages/login_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override 
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

   @override
  Widget build(BuildContext context) {
    final userController = TextEditingController();
    final passwordController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(10.0),
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
            const Text(
              "Welcome, Let's Get Groovy",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 45,
              ),
            ),
            Padding(padding: EdgeInsets.all(200.0), 
            child: Column(children: [
              Padding(padding: EdgeInsets.all(10.0),
              child: SizedBox(
                width: 75,
                height: 75,
                child: QrImage(
                  data: 'ToBeDetermined',
                  version: QrVersions.auto,
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                ),
            ),
            ),
              Padding(padding: const EdgeInsets.all(5.0),
              child:SizedBox(
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
            Padding(padding: const EdgeInsets.all(5.0), 
            child: SizedBox(
              width: 500,
              height: 50,
              child:Container( 
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
                  controller: passwordController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                      prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ) ,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ 
                Padding(padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: 240.0,
                    height: 50.0,
                    child: ElevatedButton(
                      child: const Text(
                        'Login', 
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: 240.0,
                    height: 50.0,
                    child: ElevatedButton(
                      child: const Text(
                        'New?',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
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