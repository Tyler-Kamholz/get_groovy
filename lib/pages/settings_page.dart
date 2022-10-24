import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:settings_ui/settings_ui.dart';

import '../themes/themeprovider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  final TextStyle _logoutTextStyle = const TextStyle(
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Settings"),),
      body: Column(
        children: [
          Expanded(
            child: SettingsList(
              sections: [
                SettingsSection(
                  title: const Text("Personalize"),
                  tiles: [
                    SettingsTile(
                      title: const Text('Theme'),
                      leading: const Icon(Icons.style),
                      trailing: 
                        DropdownButton(
                          value: themeProvider.getThemeMode,
                          items: const [
                            DropdownMenuItem(
                              value: ThemeMode.system,
                              child: Text("System"),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.light,
                              child: Text("Light"),
                            ),
                            DropdownMenuItem(
                              value: ThemeMode.dark,
                              child: Text("Dark"),
                            ),
                          ],
                          onChanged: (value) {
                            themeProvider.setThemeMode(value!);
                          },
                      ),
                    ),
                  ],
                ),
                SettingsSection(
                  title: const Text("Account"),
                  tiles: [
                    SettingsTile(
                      title: Text('Logout', style: _logoutTextStyle,),
                      leading: const Icon(Icons.logout),
                      onPressed: (context) {},
                    ),
                  ],
                )
              ]
            ),
          ),
        ],
      ),
    );
  }

  void backToPage(BuildContext context) {
    Navigator.pop(context);
  }
}
