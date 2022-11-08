import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/constance/style.dart';
import 'package:socspl/core/view_modal/auth/auth_view_modal.dart';
import 'package:socspl/core/view_modal/home/home_view_modal.dart';

import 'firebase_options.dart';
import 'provider_setup.dart';
import 'ui/shared/navigation/navigation.dart';
import 'ui/shared/navigation/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase initialize
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Socspl Customer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: primaryColor,
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            titleTextStyle: TextStyle(
              fontSize: 16,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          tabBarTheme: const TabBarTheme(
            labelColor: Colors.black,
          ),
        ),
        initialRoute: Navigation.instance.initialRoute,
        navigatorKey: Navigation.instance.navigatorKey,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
