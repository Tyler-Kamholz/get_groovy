/// Name: Tyler, Matthew, Kaia
/// Date: December 14, 2022
/// Description: Entrypoint of app, sets things up and creates providers.
/// Bugs: N/A
/// Reflection: N/A

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:getgroovy/pages/main_page.dart';
import 'package:getgroovy/pages/welcome_page.dart';
import 'package:getgroovy/spotify/spotify_provider.dart';
import 'package:getgroovy/themes/my_themes.dart';
import 'package:getgroovy/themes/system_brightness_listener.dart';
import 'package:getgroovy/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Stream<User?> userStream;

  @override
  void initState() {
    super.initState();
    userStream = FirebaseAuth.instance.authStateChanges();
    FirebaseAuth.instance.authStateChanges().listen((event) {
      _navigatorKey.currentState!.pushNamedAndRemoveUntil(
          (event != null) ? 'main' : 'welcome', 
          (route) => false);
    });
  }

  final _navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(context: context),
      builder: (context, child) {
        return ChangeNotifierProvider(
            create: (context) => SpotifyProvider(),
            builder: (context, child) {
              var themeProvider = Provider.of<ThemeProvider>(context);
              return MaterialApp(
                navigatorKey: _navigatorKey,
                title: 'Get Groovy',
                home: Stack(
                  children: [
                    // Future "Loading" widget or anything else can be placed here
                    // Hacky listener required to detect system theme change
                    Consumer<ThemeProvider>(
                        builder: (context, value, child) =>
                            SystemBrightnessListener(provider: value)),
                  ],
                ),
                theme: MyThemes.lightTheme.global,
                darkTheme: MyThemes.darkTheme.global,
                themeMode: themeProvider.getThemeMode,
                routes: {
                  'welcome': (_) => const WelcomePage(),
                  'main': (_) => const MainPage(),
                },
              );
            });
      },
    );
  }
}
