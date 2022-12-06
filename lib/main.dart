import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:socspl/core/constance/style.dart';
import 'package:socspl/ui/views/home/home_view.dart';
import 'package:wakelock/wakelock.dart';

import 'firebase_options.dart';
import 'provider_setup.dart';
import 'ui/shared/navigation/navigation.dart';
import 'ui/shared/navigation/routes.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();
  print('background');
  print(message.data);
  print('*****');
  print('*****');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase initialize
  Wakelock.enable();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Soc Customer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: primaryColor,
          iconTheme: const IconThemeData(color: Colors.white),
          appBarTheme: const AppBarTheme(
            backgroundColor: primaryColor,
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarIconBrightness: Brightness.light,
              statusBarColor: primaryColor,
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            titleTextStyle: TextStyle(
              fontSize: 16,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          tabBarTheme: const TabBarTheme(
            labelColor: Colors.white,
          ),
        ),
        initialRoute: Navigation.instance.initialRoute,
        navigatorKey: Navigation.instance.navigatorKey,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
