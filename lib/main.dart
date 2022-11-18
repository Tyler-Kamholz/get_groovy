import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:getgroovy/themes/my_themes.dart';
import 'package:getgroovy/themes/system_brightness_listener.dart';
import 'package:getgroovy/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(context: context),
      builder: (context, child) {
        var themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          title: 'Get Groovy',
          home: Stack(
            children: [
              const MainPage(),
              Consumer<ThemeProvider>(
                builder: (context, value, child) => SystemBrightnessListener(provider: value)
              ),
            ],
          ),
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          themeMode: themeProvider.getThemeMode,
        );
      }
    );
  }
}
