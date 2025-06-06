
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:flutter_auth/Agents/Screens/Chat/chatscreen.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/sharePrefers/services.dart';
import 'package:flutter_auth/components/splash_screen.dart';
import 'package:flutter_auth/Agents/Screens/Details/details_screen.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/helpers/loggers.dart';
import 'package:flutter_auth/providers/calls.dart';
import 'package:flutter_auth/providers/chat.dart';
import 'package:flutter_auth/providers/device_info.dart';
import 'package:flutter_auth/providers/mqtt_class.dart';
import 'package:flutter_auth/providers/providerWebRtc.dart';
import 'package:flutter_auth/providers/provider_mqtt.dart';
import 'package:flutter_auth/providers/webrtc_service.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'Agents/sharePrefers/preferencias_usuario.dart';
import 'components/Tema.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = PreferenciasUsuario();
  await prefs.initPrefs(); // ✅ Primero, inicializar preferencias
 
  await Firebase.initializeApp(); // ✅ Luego, inicializar Firebase
  await PushNotificationServices.initializeApp(); // ✅ Notificaciones después de Firebase

String? currentDeviceId = await getDeviceId();
print('************** device');
print(currentDeviceId);
  // const MethodChannel channel = MethodChannel('webrtc_channel');
  
  // initializeService(); // ✅ Ahora sí, inicializar el servicio
  // FlutterBackgroundService().on('webrtc_event').listen((event) {
  //   print("🔹 Evento recibido desde background: $event");
  //   final Map<String, dynamic> signal = Map<String, dynamic>.from(event!);
  //   channel.invokeMethod("new_webrtc_event", signal);
  //   handleWebRTCSignal(navigatorKey.currentContext, signal);
  // });
  
  // // Verificar si el canal está disponible
  // await checkWebRTCChannel(channel);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}


//  void handleWebRTCSignal(BuildContext? context, Map<String, dynamic>? signal)async {
//       if (signal == null || !signal.containsKey("action")) return;
//       final action = signal['action'];
//       final fromDeviceId = signal['from'];
//       String? deviceId = await getDeviceId();
//       logger.e('Aja a ver que conexion hay: $action ', error: 'Keh');   

//       if (action == 'offer') {
//         if (!signal.containsKey("sdp")) return;
//         String sdp = signal["sdp"];
//         final mqttManagerProvider = Provider.of<MQTTManagerProvider>(context!, listen: false);                                

//         if (mqttManagerProvider.mqttManager == null) {
//           await mqttManagerProvider.initializeMQTT(deviceId!);
//         }

//         bool isConnected = await mqttManagerProvider.mqttManager!.ensureConnection();
//         if (!isConnected) {
//           print("No se pudo conectar al MQTT");
//           return;
//         }
        
//         final webrtcProvider = Provider.of<WebRTCProvider>(context, listen: false);
//         final webRTCService = webrtcProvider.init(mqttManagerProvider.mqttManager!);
//         await webRTCService.initialize();
//         webRTCService.remoteSdp = sdp; 
        
//         final remoteDesc = RTCSessionDescription(sdp, 'offer');
//         await webRTCService.peerConnection!.setRemoteDescription(remoteDesc);

//         RTCSessionDescription answer = await webRTCService.peerConnection!.createAnswer();
//         await webRTCService.peerConnection!.setLocalDescription(answer);
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => CallScreen(
//               webrtcService: webRTCService,
//               isOffer: false,
//               remoteSdp: sdp, 
//               onAnswerGenerated: (answerSdp, answerType) {
//                 final answerMessage = {
//                   'type': 'webrtc',
//                   'action': 'answer',
//                   'sdp': answerSdp,
//                   'sdpType': answerType,
//                   'from': deviceId , // mi dispositivo
//                   'to': fromDeviceId,   // quien hizo la oferta
//                 };
//                 final builder = MqttClientPayloadBuilder();
//                 builder.addString(jsonEncode(answerMessage));
//                 MQTTManager(deviceId!).client?.publishMessage(
//                   "webrtc/signal",
//                   MqttQos.atLeastOnce,
//                   builder.payload!,
//                 );

//                 print("📤 Enviando respuesta (answer) a $fromDeviceId");
//               },
//             ),
//           ),
//         );
//       } else if (action == 'answer') {
//         if (!signal.containsKey("sdp")) return;
//         String sdp = signal["sdp"];

//         // Recibir la respuesta y aplicar en la conexión del peer que hizo la oferta
//         final webRTCService = WebRTCService(MQTTManager(deviceId!));
//         await webRTCService.initialize();
//         await webRTCService.setRemoteDescription(sdp, 'answer');
//       }else if (action == 'iceCandidate') {
//         if (!signal.containsKey('candidate') || signal['candidate'] == null) return;
//         print('Recibiendo ICE Candidate remoto: ${signal['candidate']}');
//         final candidate = RTCIceCandidate(
//           signal['candidate'],
//           signal['sdpMid'],
//           signal['sdpMLineIndex'],
//         );
//         try {
//           final webRTCService = WebRTCService(MQTTManager(deviceId!));
//           await webRTCService.peerConnection!.addCandidate(candidate);
//         } catch (e) {
//           print('Error al agregar ICE Candidate remoto: $e');
//         }
//       }
//   }

  // void showCallUI(BuildContext? context, String sdp, bool isOffer, String idPropio, String idRemoto) {
  //   Navigator.push(
  //     context!,
  //     MaterialPageRoute(builder: (context) => CallScreen(sdp: sdp, isOffer: isOffer,
  //       onAnswerGenerated: (String answerSdp, String sdpType) {
  //         webrtcService.sendWebRTCSignal(jsonEncode({
  //           'type': 'webrtc',
  //           'action': 'answer',
  //           'sdp': answerSdp,
  //           'sdpType': sdpType,
  //           'from': idPropio,
  //           'to': idRemoto,
  //         }));
  //       },)),
  //   );
  // }

//   Future<void> checkWebRTCChannel(channel) async {
//     await Future.delayed(Duration(seconds: 2)); // Espera para inicializar
//     try {
//       final bool? exists = await channel.invokeMethod("ping");
//       print("✅ WebRTC channel disponible: $exists");
//     } on PlatformException catch (e) {
//       print("❌ Error de PlatformException: ${e.message}");
//     } catch (e) {
//       print("⚠️ Error desconocido al verificar WebRTC: $e");
//     }
//   }


// @pragma('vm:entry-point')
// void initializeService()async {
//   final service = FlutterBackgroundService();
//   final battery = Battery();
  
//   service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       isForegroundMode: true, // Mantiene el servicio activo
//       autoStartOnBoot: true, // Reinicia el servicio si el dispositivo se reinicia
//       autoStart: true, // Inicia automáticamente cuando se abre la app
//       notificationChannelId: 'mqtt_service', // ID del canal de notificación
//       initialNotificationTitle: 'Servicio MQTT',
//       initialNotificationContent: 'Conectando...',
//       foregroundServiceNotificationId: 1, // ID de la notificación
//     ),
//     iosConfiguration: IosConfiguration(),
//   );

//   battery.onBatteryStateChanged.listen((BatteryState state) { 
//     if(state == BatteryState.charging){
//       service.invoke('increaseSyncRate');
//     }else{
//       service.invoke('reduceSyncRate');
//     }
//   });

//   await service.startService();
// }
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   // Debug log for tracking service start 
//   logger.d('Background service starting...');
  
//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) { 
//       service.setAsForegroundService();
//     });

//     service.on('setAsBackground').listen((event) { 
//       service.setAsBackgroundService();
//     });
    
//     // Set as foreground service immediately to avoid getting stuck
//     service.setAsForegroundService();
//   }

//   // Get device ID
//   String? deviceId = await getDeviceId();
//   if (deviceId == null) {    
//     loggerNoStack.w('Failed to get device ID');
//     if (service is AndroidServiceInstance) {
//       service.setForegroundNotificationInfo(
//         title: 'Servicio Smart Driver', 
//         content: 'Error: No se pudo obtener el ID del dispositivo'
//       );
//     }
//     return;
//   }
  
//   // Create and connect MQTT manager
//   final mqttManager = MQTTManager(deviceId);
//   bool isConnected = false;
  
//   // Connect and handle connection status
//   try {
//     //isConnected = await mqttManager.connect();
//     // logger.d('MQTT connection attempt result: $isConnected');    
//   } catch (e) {
//     logger.e('MQTT connection error: $e', error: 'Error conexión');    
//     isConnected = false;
//   }
  
//   // Update notification based on connection status
//   if (service is AndroidServiceInstance) {
//     service.setForegroundNotificationInfo(
//       title: 'Servicio Smart Driver', 
//       content: isConnected ? 'Conectado al servicio de Smart Driver' : 'Intentando conectar...'
//     );
//   }

//   // Setup message listener if connected
//   if (isConnected) {
//     mqttManager.client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
//       final recMess = messages[0].payload as MqttPublishMessage;
//       final payload =
//           MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
//       final data = jsonDecode(payload);

//       if (data['type'] == 'webrtc') {
//         handleWebRTCSignal(navigatorKey.currentContext, data);
//       }
//     });

//     mqttManager.listenForMessages((jsonData) {
//       final title = jsonData['title'];
//       final body = jsonData['body'];
//       if (jsonData.containsKey("type") && jsonData["type"] == "webrtc") {  
//         try {
//           final Map<String, dynamic> webrtcEvent = Map<String, dynamic>.from(jsonData);
//           service.invoke('webrtc_event', webrtcEvent);                   
//         } catch (e) {
//           logger.e("⚠️ Error al verificar el canal WebRTC: $e");
//         }    
//       }
//       PushNotificationServices.showNotification(title: title, body: body);      
//       // logger.d('Message received: $jsonData'); 
//     });
//   }

//   // Variables para controlar la frecuencia
//   int normalSyncInterval = 5; // 5 minutos
//   int batterySavingInterval = 15; // 15 minutos
//   int currentInterval = normalSyncInterval;
//   Timer? periodicTimer;

//   // Función para realizar la verificación de conexión
//   Future<void> checkConnection() async {
//     var connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.none) {
//       // Sin conexión, no intentes reconectar aún
//       logger.d('Sin conexión a internet, esperando próxima verificación');
//       return;
//     }

//     try {
//       bool connectionStatus = await mqttManager.ensureConnection();
            
//       if (service is AndroidServiceInstance) {
//         if (await service.isForegroundService()) {
//           service.setForegroundNotificationInfo(
//             title: 'Servicio Smart Driver', 
//             content: connectionStatus 
//               ? 'Conectado al servicio de Smart Driver' 
//               : 'Reconectando...'
//           );
//         }
//       }
      
//       // Log current status for debugging
//       // logger.d('Connection status: $connectionStatus');       
//     } catch (e) {
//       logger.e('Error checking connection: $e', error: 'Error');      
//     }
//   }

//   // Función para iniciar el timer con el intervalo actual
//   void startPeriodicTimer() {
//     periodicTimer?.cancel();
//     periodicTimer = Timer.periodic(Duration(minutes: currentInterval), (timer) async {
//       await checkConnection();
//     });
//     // logger.d('Timer configurado con intervalo de $currentInterval minutos');
//   }

//   // Escuchar eventos para cambiar el intervalo
//   service.on('increaseSyncRate').listen((event) {
//     currentInterval = normalSyncInterval;
//     startPeriodicTimer();
//     // logger.d('Aumentando frecuencia de sincronización a $currentInterval minutos');
//   });

//   service.on('reduceSyncRate').listen((event) {
//     currentInterval = batterySavingInterval;
//     startPeriodicTimer();
//     // logger.d('Reduciendo frecuencia de sincronización a $currentInterval minutos');
//   });

//   // Iniciar con el intervalo normal
//   startPeriodicTimer();

//   // Verificar estado de la batería inicialmente
//   try {
//     final battery = Battery();
//     final batteryLevel = await battery.batteryLevel;
//     final batteryState = await battery.batteryState;
    
//     // Si la batería está baja, reducir la frecuencia desde el inicio
//     if (batteryLevel < 30 && batteryState == BatteryState.discharging) {
//       service.invoke('reduceSyncRate');
//     }
    
//     // Configurar listener para cambios en la batería
//     battery.onBatteryStateChanged.listen((BatteryState state) {
//       if (state == BatteryState.charging) {
//         service.invoke('increaseSyncRate');
//       } else if (state == BatteryState.discharging && batteryLevel < 30) {
//         service.invoke('reduceSyncRate');
//       }
//     });
//   } catch (e) {
//     logger.e('Error al configurar monitoreo de batería: $e');
//   }
  
//   // Realizar una verificación inicial de conexión
//   await checkConnection();

//   // Handle stop request
//   service.on('stop').listen((event) {
//     //print("Service stop requested");
//     mqttManager.disconnect();
//     periodicTimer?.cancel();
//     service.stopSelf();
//   });
// }

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
    PushNotificationServices.initializeApp();
    requestPermissions(); // ✅ Pedir permisos después de Firebase
    requestIgnoreBatteryOptimizations(); // ✅ Pedir optimización de batería
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
  void dispose() {    
    super.dispose();
 
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
        // ChangeNotifierProvider(create: (_) => MQTTManagerProvider()),
        // ChangeNotifierProvider(create: (_) => WebRTCProvider()),  
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
