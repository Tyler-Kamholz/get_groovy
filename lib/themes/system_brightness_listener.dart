import 'package:flutter/cupertino.dart';
import 'package:getgroovy/themes/theme_provider.dart';

/// This is a very hacky workaround for my inability to figure out how
/// to change the system navigation bar theme, especially when the user
/// changes system theme on the fly.
class SystemBrightnessListener extends StatelessWidget
    with WidgetsBindingObserver {
  final ThemeProvider provider;

  SystemBrightnessListener({super.key, required this.provider}) {
    // Register this widget as an observer
    WidgetsBinding.instance.addObserver(this);
  }

  /// Whenever the system theme changes, ask the provider to ensure
  /// the theme is set correctly
  @override
  void didChangePlatformBrightness() {
    provider.updateSystemNavBar();
  }

  /// Return an empty container, as this is not meant to be seen
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
