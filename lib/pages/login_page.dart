import 'dart:html';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class LoginPage extends Stateful Widget {
  const LoginPage({super.key});

  @override 
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

   @override
  Widget build(BuildContext context) {
    final _userController = TextEditingController();
    final _passwordController = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Padding(padding:EdgeInsets.all(10.0),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          decoration: BoxDecoration(
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
            Text(
              "Welcome, Let's Get Groovy",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 45,
              ),
            ),
            Padding(padding:EdgeInsets.all(200.0), 
            child:Column(children: [
              Padding(padding:EdgeInsets.all(10.0),
              child:SizedBox(
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
              Padding(padding:EdgeInsets.all(5.0),
              child:SizedBox(
                width: 500,
                height: 50,
                child:Container(
                  decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.teal),
                    left: BorderSide(width: 1.0, color: Colors.teal),
                    right: BorderSide(width: 1.0, color: Colors.teal),
                    bottom: BorderSide(width: 1.0, color: Colors.teal),
                  ),
                  color: Colors.white,
                  ),
                  child: TextField(
                    controller: _userController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(20),
                      labelText: 'Username: ',
                      labelStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              ),
            Padding(padding:EdgeInsets.all(5.0), 
            child: SizedBox(
              width: 500,
              height: 50,
              child:Container( 
                decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 1.0, color: Colors.teal),
                  left: BorderSide(width: 1.0, color: Colors.teal),
                  right: BorderSide(width: 1.0, color: Colors.teal),
                  bottom: BorderSide(width: 1.0, color: Colors.teal),
                ),
                color: Colors.white,
                ),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(20),
                    labelText: 'Password: ',
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
                Padding(padding:EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: 240.0,
                    height: 50.0,
                    child: ElevatedButton(
                      child: Text(
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
                Padding(padding:EdgeInsets.all(5.0),
                  child: SizedBox(
                    width: 240.0,
                    height: 50.0,
                    child: ElevatedButton(
                      child: Text(
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