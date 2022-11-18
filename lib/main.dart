import 'package:flutter/material.dart';
import 'package:getgroovy/spotify/spotify_provider.dart';
import 'package:getgroovy/themes/my_themes.dart';
import 'package:getgroovy/themes/system_brightness_listener.dart';
import 'package:getgroovy/themes/theme_provider.dart';
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
        create: (context) => SpotifyProvider(),
        builder: (context, child) => ChangeNotifierProvider(
            create: (context) => ThemeProvider(context: context),
            builder: (context, child) {
              var themeProvider = Provider.of<ThemeProvider>(context);
              return MaterialApp(
                title: 'Get Groovy',
                home: Stack(
                  children: [
                    const MainPage(),
                    Consumer<ThemeProvider>(
                        builder: (context, value, child) =>
                            SystemBrightnessListener(provider: value)),
                  ],
                ),
                theme: MyThemes.lightTheme,
                darkTheme: MyThemes.darkTheme,
                themeMode: themeProvider.getThemeMode,
              );
            }));
  }
}
