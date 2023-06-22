// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/sharePrefers/services.dart';
import 'package:flutter_auth/components/splash_screen.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/Agents/Screens/Details/details_screen.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/providers/chat.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'Agents/sharePrefers/preferencias_usuario.dart';

Future<void> main() async {
  //inicialización de clases y variables necesarias para
  //que la apliación inicie sin problemas
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await PushNotificationServices.initializeApp();
  await prefs.initPrefs();
  await Firebase.initializeApp();
 runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Variables globales
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Main Navigator");
  final prefs = new PreferenciasUsuario();
  bool menuDesplegable=false;

  //función de la clase de notificaciones que necesita ser inicializada
  //para hacer las respectivas notificaciones y redirecciones
  @override

  void initState() {
    super.initState();

    PushNotificationServices.messageStream.listen((event) {
      if (event == 'PROCESS_TRIP') {
        navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (_) => DetailScreen(plantilla: plantilla[0])));
      }
      //print(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    //Aqui es donde se inicializa la aplicación
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ChatProvider(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Smart Driver',
        theme: tema(),
        //home: prefs.nombreUsuario ==null?WelcomeScreen():HomeScreen(),
        initialRoute: prefs.nombreUsuario == null || prefs.nombreUsuario == ""
            ? 'login'
            : 'home',
        routes: {
          'login': (BuildContext context) => UpgradeAlert(child: SplashView()),
          'home': (BuildContext context) => UpgradeAlert(child: HomeScreen(),),
        },
      ),
    );
  }

  ThemeData tema() {
    return ThemeData(
      primaryColor: Colors.blue,
      fontFamily: 'Roboto',
      textTheme: TextTheme(
      
        displayLarge : TextStyle(fontSize: 24.0, color: Colors.black), 
        bodyLarge : TextStyle(fontSize: 16.0, color: Colors.grey), 

      ),
    );
  }

}
