import 'dart:convert';

import 'package:jsochurch/utils/app_constants.dart';
import 'package:jsochurch/utils/excel_to_json.dart';
import 'package:jsochurch/utils/my_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jsochurch/views/detailed_view.dart';
import 'package:jsochurch/views/home_view.dart';
import 'package:jsochurch/views/initial_splash_view.dart';
import 'package:jsochurch/views/splash_view.dart';
import 'package:jsochurch/web/view_models/web_view_model.dart';
import 'package:jsochurch/web/web_home_view.dart';
import 'package:jsochurch/web/web_login_view.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  if(!kIsWeb) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FirebaseDatabase database;
    database = FirebaseDatabase.instance;
    database.setPersistenceEnabled(true);
    database.setPersistenceCacheSizeBytes(10000000);
  }
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppConstants constants = AppConstants.instance;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light
    ));
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                backgroundColor:myWhite,
                body: Center(child: Text("Error")),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
              providers: constants.providers,
              child: MaterialApp(
                title: 'JSO Church Directory',
                theme: ThemeData(primaryColor: Colors.blue),
                home:  SelectionArea(child: const InitialSplashView()),
              ),
            );
          }
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(child: Text("Loading...")),
            ),
          );
        });
  }

}