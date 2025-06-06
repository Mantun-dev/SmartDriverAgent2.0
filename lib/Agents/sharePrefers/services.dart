import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/main.dart';
import 'package:flutter_auth/providers/IncomingCallScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class PushNotificationServices {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static StreamController<String> _messageStreamController =
      StreamController.broadcast();
  static Stream<String> get messageStream => _messageStreamController.stream;
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  // Método para mostrar notificaciones
  static Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    var details = await _notificationDetails();

    // Muestra la notificación
    await _notifications.show(id, title, body, details, payload: payload);

    // Imprimir para confirmar que se ejecuta la notificación
    print("Notificación mostrada: $title - $body");
  }

  // Detalles de la notificación para Android e iOS
  static Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  // Crear el canal de notificación en Android
  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel id', // ID del canal
      'channel name', // Nombre del canal
      description: 'channel description', // Descripción del canal
      importance: Importance.max,
      // priority: Priority.high,
    );
    // Registra el canal en el sistema
    await _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  // Inicialización de la notificación y Firebase
  static Future<void> init({bool initScheduled = false}) async {
    await _createNotificationChannel(); // Crea el canal de notificación

    const android = AndroidInitializationSettings('@mipmap/launcher_icons');
    const iOS = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        if (payload != null) {
          try {
            final data = jsonDecode(payload);
            final callType = data['callType'];

            if (callType == 'Incoming') {
              final callerName = data['userName'] ?? 'Desconocido';
                navigatorKey.currentState?.push(
                  MaterialPageRoute(
                    builder: (_) => IncomingCallScreen(callerName: callerName, array: data),
                  ),
                );
              } else {
                // Otras notificaciones
                onNotifications.add(payload);
              }
          } catch (e) {
            print('Error al decodificar payload: $e');
          }
        }
      },
    );
  }

  // Solicitar permisos de notificación para iOS
  static void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("Permisos de notificación concedidos");
    } else {
      print("Permisos de notificación no concedidos");
    }
  }

  // Manejar la notificación en segundo plano
  static Future<void> _backgroundHandelr(RemoteMessage message) async {
    print('onBackground handelr ${message.messageId}');
    final data = message.data;
    final callType = data['callType'];
    print(data);
    if (callType == 'Incoming') {
      await showIncomingCallNotification(
        callerName: data['userName'],
        payload: jsonEncode(data),
      );
    } else {
      // Notificación normal
      showNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        payload: data.toString(),
      );
    }
    _messageStreamController.add(message.data['type'] ?? 'no data');
  }

  // Manejar la notificación en primer plano
  static Future<void> _onMessageHandelr(RemoteMessage message) async {
  print('onMessage handler ${message.messageId}');

  final data = message.data;
  final callType = data['callType'];
  print(data);
  if (callType == 'Incoming') {
    await showIncomingCallNotification(
      callerName: data['userName'],
      payload: jsonEncode(data),
    );
  } else {
    // Notificación normal
    showNotification(
      title: message.notification?.title,
      body: message.notification?.body,
      payload: data.toString(),
    );
  }

  _messageStreamController.add(data['type'] ?? 'no data');
}


  // Manejar la notificación al abrir la app
  static Future<void> _onMessageOpenApp(RemoteMessage message) async {
    print('onMessageOpenApp ${message.messageId}');
    _messageStreamController.add(message.data['type'] ?? 'no data');
  }

  static Future<void> showIncomingCallNotification({
    required String? callerName,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'call_channel', // Unique channel ID
      'Llamadas',
      channelDescription: 'Notificaciones de llamadas entrantes',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      visibility: NotificationVisibility.public,
      ticker: 'ticker',
      sound: RawResourceAndroidNotificationSound('call'),
      playSound: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notifications.show(
      12345, // ID único
      'Llamada entrante',
      '$callerName te está llamando',
      platformChannelSpecifics,
      payload: payload,      
    );
  }


  // Inicialización de la aplicación
  static Future<void> initializeApp() async {
    await Firebase.initializeApp();
    await init();
    token = await FirebaseMessaging.instance.getToken();
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      token = newToken;
      print("Nuevo token de registro: $token");
    });

    FirebaseMessaging.onBackgroundMessage(_backgroundHandelr);
    FirebaseMessaging.onMessage.listen(_onMessageHandelr);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    print(token);
  }

  // Método para navegar hacia una pantalla específica si es necesario
  static void navigateToScreen(Map<String, dynamic> data) {
    // Implementa navegación si es necesario
  }

  // Cerrar los streams
  static void closeStreams() {
    _messageStreamController.close();
  }
}
