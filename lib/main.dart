import 'dart:io';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/sharePrefers/services.dart';
import 'package:flutter_auth/components/splash_screen.dart';
import 'package:flutter_auth/Agents/Screens/Details/details_screen.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/providers/chat.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'Agents/sharePrefers/preferencias_usuario.dart';
import 'components/Tema.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

Future<void> main() async {
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
  final prefs = new PreferenciasUsuario();
  bool menuDesplegable = false;
  bool? coneccionInternet;
  bool reintentarBoton = true;

  @override
  void initState() {
    super.initState();
    checkInternetConnectivity();
    PushNotificationServices.messageStream.listen((event) {
      if (event == 'PROCESS_TRIP') {
        navigatorKey.currentState?.push(MaterialPageRoute(
            builder: (_) => DetailScreen(plantilla: plantilla[0])));
      }
    });

    eventBus.on<ThemeChangeEvent>().listen((event) {
      setState(() {
        prefs.tema = !prefs.tema;
      });
    });
  }

  void checkInternetConnectivity() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      setState(() {
        coneccionInternet = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
        reintentarBoton = true;
      });
    } on SocketException catch (_) {
      setState(() {
        coneccionInternet = false;
        reintentarBoton = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ChatProvider(),
        ),
      ],
      child: coneccionInternet == null
          ? verificandoConexion()
          : coneccionInternet == false
              ? sinConexion()
              : MaterialApp(
                  navigatorKey: navigatorKey,
                  debugShowCheckedModeBanner: false,
                  title: 'Smart Driver',
                  theme: prefs.tema != true ? appThemeDataLight : appThemeDataDark,
                  initialRoute: prefs.nombreUsuario == null || prefs.nombreUsuario == ""
                      ? 'login'
                      : 'home',
                  routes: {
                    'login': (BuildContext context) => UpgradeAlert(child: SplashView()),
                    'home': (BuildContext context) => UpgradeAlert(child: HomeScreen()),
                  },
                ),
    );
  }

  Scaffold verificandoConexion() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () async => false,
        child: SimpleDialog(
          elevation: 20,
          backgroundColor: Colors.white,
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Verificando Conexión a internet',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Scaffold sinConexion() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'No hay conexión a internet',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              Text(
                'Por favor verifique su conexión a internet',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              botonReintentar(),
            ],
          ),
        ),
      ),
    );
  }

  OutlinedButton botonReintentar() {
    return OutlinedButton(
      onPressed: reintentarBoton == false ? null : () {
        setState(() {
          reintentarBoton = false;
        });
        checkInternetConnectivity();
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: Color.fromRGBO(40, 93, 169, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          reintentarBoton == false ? 'Verificando Internet...' : 'Enviar',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}

EventBus eventBus = EventBus();

class ThemeChangeEvent {
  final bool newTheme;

  ThemeChangeEvent(this.newTheme);
}