
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:event_bus/event_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/sharePrefers/services.dart';
import 'package:flutter_auth/components/splash_screen.dart';
import 'package:flutter_auth/Agents/Screens/Details/details_screen.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';

import 'package:flutter_auth/providers/chat.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'Agents/sharePrefers/preferencias_usuario.dart';
import 'components/Tema.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

// Función top-level para manejar mensajes en segundo plano
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");

  final callType = message.data['callType'];
  if (callType == 'Incoming') {
    // Al recibir la notificación de llamada en segundo plano o cerrado,
    // disparamos la Notificación Local con fullScreenIntent: true.
    await PushNotificationServices.showIncomingCallNotification(
      callerName: message.data['userName'],
      payload: jsonEncode(message.data),  // Pasar el payload completo para re-navegación
    );
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) async {
  final payload = response.payload;
  if (payload != null) {
    try {
      final data = jsonDecode(payload);
      PushNotificationServices.handleNotificationNavigation(data);
    } catch (e) {
      print('Error al decodificar payload en background: $e');
    }
  }
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = PreferenciasUsuario();
  await prefs.initPrefs(); 
  
  await Firebase.initializeApp();
  
  // Paso 1: Inicializar flutter_local_notifications.
  await PushNotificationServices.init(
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground);

  // Registra el handler de mensajes en segundo plano de FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  // Inicializar servicios, pasando el GlobalKey
  await PushNotificationServices.initializeApp(navigatorKey); 

  // Paso 2: Obtener el mensaje inicial de FCM
  RemoteMessage? initialFCMMessage = await FirebaseMessaging.instance.getInitialMessage();
  Map<String, dynamic>? initialCallData;

  if (initialFCMMessage != null && initialFCMMessage.data['callType'] == 'Incoming') {
    initialCallData = initialFCMMessage.data;
  }
  
  // 🛑 CORRECCIÓN CLAVE: runApp directamente con MyApp (que contendrá el MaterialApp)
  runApp(
    MyApp(initialCallData: initialCallData, navigatorKey: navigatorKey), 
  );
}

class MyApp extends StatefulWidget {  
  final GlobalKey<NavigatorState> navigatorKey;
  final Map<String, dynamic>? initialCallData;

  const MyApp({
    super.key,
    required this.navigatorKey, // Ahora requiere la clave
    this.initialCallData, // Recibe la data de la llamada inicial
  }); 

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Variables globales
  final prefs = new PreferenciasUsuario();
  bool menuDesplegable=false;
  // NOTA: La variable 'plantilla' en el listener de 'PROCESS_TRIP' debe estar disponible.

  @override
  void initState() {
    super.initState();
    
    // Asignación de la clave al servicio (Aunque ya se hace en main, se mantiene por si acaso)
    PushNotificationServices.initializeApp(widget.navigatorKey); 
    
    // 💡 LÓGICA DE NAVEGACIÓN INICIAL (Cubre FCM getInitialMessage Y FSI array fallback)
    if (widget.initialCallData != null || PushNotificationServices.array != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Prioriza la data del constructor (FCM) o usa la data estática (FSI fallback)
        final dataToNavigate = widget.initialCallData ?? PushNotificationServices.array;
        
        if (dataToNavigate != null) {
          print("Intentando navegar (Inicial/Fallback) con data: $dataToNavigate");
          PushNotificationServices.handleNotificationNavigation(dataToNavigate);
          // Limpia la data estática después de usarla para evitar re-navegación
          PushNotificationServices.array = null; 
        }
      });
    }

    requestPermissions(); 
    requestIgnoreBatteryOptimizations();
    checkAudioPermission();
    
    PushNotificationServices.messageStream.listen((event) {
      if (event == 'PROCESS_TRIP') {
        // Usar la clave del widget: widget.navigatorKey
        widget.navigatorKey.currentState?.push(MaterialPageRoute(
            // Asumo que 'plantilla' es una lista global/estática que contiene datos
            // builder: (_) => DetailScreen(plantilla: plantilla[0])));
            builder: (_) => DetailScreen(plantilla: plantilla[0]))); // Reemplaza [] con tu objeto plantilla[0]
      }
    });

    eventBus.on<ThemeChangeEvent>().listen((event) {
      setState(() { 
        prefs.tema = !prefs.tema;
      });
    });
  }

  // ... (dispose) ...

  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ChatProvider(),
        ),
        // ...
      ],
      // 🛑 CORRECCIÓN CLAVE: El MaterialApp ahora está dentro del MultiProvider
      // y no está anidado.
      child: MaterialApp(
        navigatorKey: widget.navigatorKey, // Usa la clave pasada al widget
        debugShowCheckedModeBanner: false,
        title: 'Smart Driver',
        theme: prefs.tema!=true? appThemeDataLight : appThemeDataDark,
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

  requestAllPermissions() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.notification,
    Permission.microphone,
    Permission.ignoreBatteryOptimizations
  ].request();

  if (statuses[Permission.notification] == PermissionStatus.permanentlyDenied) {
    openAppSettings();
  }

  if (statuses[Permission.ignoreBatteryOptimizations] == PermissionStatus.permanentlyDenied) {
    openAppSettings();
  }
}

  requestPermissions() async {
    if (Platform.isAndroid) {
  // Para dispositivos con Android 13+
      final permissionStatus = await Permission.notification.status;
        if (permissionStatus.isGranted) {
        // Permiso concedido

      } else { 
        await Permission.notification.request();
      }
    }
  }

  requestIgnoreBatteryOptimizations() async {
    if (Platform.isAndroid ) {
      final permissionStatus = await Permission.ignoreBatteryOptimizations.status;
       if (permissionStatus.isGranted) {
        // Permiso concedido

      } else {      
        await Permission.ignoreBatteryOptimizations.request();
      }      
    }
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
