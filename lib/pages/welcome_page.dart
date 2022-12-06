import 'package:flutter/material.dart';
import 'package:getgroovy/pages/login_page.dart';
import 'package:getgroovy/pages/register_page.dart';
import 'package:getgroovy/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Provider.of<ThemeProvider>(context).getCurrentTheme().navBarColor,
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              bottom: -size.height * .5,
              left: -size.width * .8,
              child: Transform.rotate(
                angle: 0.2,
                child: Image.asset(
                  Provider.of<ThemeProvider>(context)
                      .getCurrentTheme()
                      .welcomeBackground,
                  width: size.width * 3,
                ),
              )),
          Positioned(
              top: 175,
              left: size.width * .25,
              child: Image.asset(
                Provider.of<ThemeProvider>(context)
                    .getCurrentTheme()
                    .welcomeLogo,
                width: size.width * .5,
              )),
          Positioned(
            top: size.height * .5,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginPage();
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(size.width * .8, size.height * .05),
                  backgroundColor: Provider.of<ThemeProvider>(context)
                      .getCurrentTheme()
                      .loginColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0))),
              child: Text(
                'Login',
                style: TextStyle(
                    color: Provider.of<ThemeProvider>(context)
                        .getCurrentTheme()
                        .textColor),
              ),
            ),
          ),
          Positioned(
            top: (size.height * .5) + 75,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const RegisterPage();
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(size.width * .8, size.height * .05),
                  backgroundColor: Provider.of<ThemeProvider>(context)
                      .getCurrentTheme()
                      .signupColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0))),
              child: Text(
                'Sign up',
                style: TextStyle(
                    color: Provider.of<ThemeProvider>(context)
                        .getCurrentTheme()
                        .textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
