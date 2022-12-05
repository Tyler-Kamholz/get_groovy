// Flutter web plugin registrant file.
//
// Generated file. Do not edit.
//

// @dart = 2.13
// ignore_for_file: type=lint

import 'package:cloud_firestore_web/cloud_firestore_web.dart';
import 'package:firebase_auth_web/firebase_auth_web.dart';
import 'package:firebase_core_web/firebase_core_web.dart';
import 'package:spotify_sdk/spotify_sdk_web.dart';
import 'package:system_theme_web/system_theme_web.dart';
import 'package:uni_links_web/uni_links_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins([final Registrar? pluginRegistrar]) {
  final Registrar registrar = pluginRegistrar ?? webPluginRegistrar;
  FirebaseFirestoreWeb.registerWith(registrar);
  FirebaseAuthWeb.registerWith(registrar);
  FirebaseCoreWeb.registerWith(registrar);
  SpotifySdkPlugin.registerWith(registrar);
  SystemThemeWeb.registerWith(registrar);
  UniLinksPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
