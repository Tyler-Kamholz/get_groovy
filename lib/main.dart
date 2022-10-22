import 'package:flutter/material.dart';
import 'package:getgroovy/themes/mythemes.dart';
import 'package:getgroovy/themes/themeprovider.dart';
import 'package:provider/provider.dart';
import 'pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, child) {
        var themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          title: 'Get Groovy',
          home: const MainPage(),
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          themeMode: themeProvider.getThemeMode,
        );
      }
    );
  }
}
