// ignore_for_file: unnecessary_null_comparison

import 'package:event_bus/event_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/sharePrefers/services.dart';
import 'package:flutter_auth/components/splash_screen.dart';
import 'package:flutter_auth/Agents/Screens/Details/details_screen.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/providers/chat.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'Agents/sharePrefers/preferencias_usuario.dart';
import 'components/Tema.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");
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

  final prefs = new PreferenciasUsuario();
  bool menuDesplegable=false;

  //función de la clase de notificaciones que necesita ser inicializada
  //para hacer las respectivas notificaciones y redirecciones
  @override

  void initState() {
    super.initState();
    checkAudioPermission();
    PushNotificationServices.messageStream.listen((event) {
      if (event == 'PROCESS_TRIP') {
        navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (_) => DetailScreen(plantilla: plantilla[0])));
      }
      //print(event);
    });

    eventBus.on<ThemeChangeEvent>().listen((event) {
      // Actualizar el estado o realizar acciones según el evento recibido
      setState(() { 
        prefs.tema = !prefs.tema;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
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
        theme: prefs.tema!=true? appThemeDataLight : appThemeDataDark,
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

  void checkAudioPermission() async {
    // Verificar si se tiene el permiso de grabación de audio
    var status = await Permission.microphone.status;
    
    if (status.isGranted) {
      // Permiso concedido

    } else {
      // No se ha solicitado el permiso, solicitarlo al usuario
      await Permission.microphone.request();
    }
  }

}

EventBus eventBus = EventBus();

class ThemeChangeEvent {
  final bool newTheme;

  ThemeChangeEvent(this.newTheme);
}
