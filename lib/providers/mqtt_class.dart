// import 'dart:convert';
// import 'dart:math';

// import 'package:battery_plus/battery_plus.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_auth/helpers/loggers.dart';
// import 'package:flutter_auth/main.dart';
// import 'package:flutter_auth/providers/calls.dart';
// import 'package:flutter_auth/providers/providerWebRtc.dart';
// import 'package:flutter_auth/providers/provider_mqtt.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
// import 'package:mqtt_client/mqtt_client.dart';
// import 'package:mqtt_client/mqtt_server_client.dart';
// import 'package:provider/provider.dart';

// class MQTTManager {
//   MqttServerClient? client;
//   String deviceId;
//   RTCPeerConnection? _peerConnection;

//   MQTTManager(this.deviceId) {
//     client = MqttServerClient('192.168.0.13', 'Mqtt_$deviceId');
//     client?.port = 1883;
//     client?.logging(on: true);
//     client?.keepAlivePeriod = 120;
//     client?.onDisconnected = _onDisconnected;
//     client?.onConnected = _onConnected;
//     client?.onSubscribed = _onSubscribed;
    
//     final connMessage = MqttConnectMessage() 
//       .withWillTopic('willtopic')
//       .withWillMessage('willMessage')
//       .startClean()
//       .withWillQos(MqttQos.atLeastOnce).
//       withClientIdentifier('Mqtt_$deviceId');

//     client?.connectionMessage = connMessage;
//   }

//   Future<bool> connect() async {
//     try {
//       var status = await client?.connect();
//       if (status?.state != MqttConnectionState.connected) {
//         logger.e('Error al conectar: ${status?.state}', error: '${status?.state}');        
//         client?.disconnect();
//         return false;
//       } else {
//         // logger.d('Conexión establecida');       
//         return true;
//       }
//     } catch (e) {
//       logger.e('Error al conectar: $e', error: '$e'); 
//       //client?.disconnect();
//       return false;
//     }
//   }

//   void _onConnected() {
//     // logger.d('Conectado al servidor Aedes MQTT');    
//     subscribeToTopic();
//   }

//   void subscribeToTopic() {
//     client?.subscribe('notificaciones/$deviceId', MqttQos.atLeastOnce);
//     client?.subscribe('webrtc/signal', MqttQos.atLeastOnce); // Escuchar señales WebRTC
//     //logger.d('Suscrito a notificaciones/$deviceId y webrtc/signal');      
//   }

//   void _onSubscribed(String topic) {    
//     logger.d('Suscrito al tema: $topic');    
//   }
  


//   int _baseRetryInterval = 30;
//   int _maxRetryInterval = 300;
//   int _currentRetryInterval = 30;
//   int _reconnectAttempts = 0;


//   void _onDisconnected() {
//     // loggerNoStack.w('Desconectado del servidor MQTT');

//     // _reconnectAttempts++;

//     // _currentRetryInterval = min(_baseRetryInterval * pow(1.5, _reconnectAttempts).toInt(), _maxRetryInterval);

//     // final jitter = Random().nextInt(_currentRetryInterval  ~/ 4);
//     // final delayWithJitter = _currentRetryInterval + jitter;

//     // Future.delayed(Duration(seconds: delayWithJitter), () async {
//     //   // Verificar el estado de la red antes de intentar
//     //   var connectivityResult = await Connectivity().checkConnectivity();
//     //   if (connectivityResult == ConnectivityResult.none) {
//     //     loggerNoStack.i('Sin conexión a internet, posponiendo reconexión');
//     //     return;
//     //   }

//     //   loggerNoStack.i('Intentando reconectar...');
//     //   bool connected = await connect();
//     //   if (connected) {
//     //     logger.d('Reconexión exitosa');
//     //     _reconnectAttempts = 0;
//     //     _currentRetryInterval = _baseRetryInterval;
//     //   } else {
//     //     loggerNoStack.w('Fallo al reconectar, próximo intento en $_currentRetryInterval segundos');
//     //   }
//     // });
//   }

//   Future<void> createOffer(String targetDeviceId) async {
//     if (_peerConnection == null) {
//       _peerConnection = await createPeerConnection({
//         'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}]
//       });
//     }

//     RTCSessionDescription offer = await _peerConnection!.createOffer();
//     await _peerConnection!.setLocalDescription(offer);

//     final message = {
//       'type': 'webrtc',
//       'action': 'offer',
//       'sdp': offer.sdp,
//       'sdpType': offer.type,
//       'from': deviceId,
//       'to': targetDeviceId,
//     };

//     sendWebRTCSignal(jsonEncode(message));
//   }



//   /// **Envío de señales WebRTC**
//   void sendWebRTCSignal(String message) {
//     final builder = MqttClientPayloadBuilder();
//     builder.addString(message);
//     client?.publishMessage("webrtc/signal", MqttQos.atLeastOnce, builder.payload!);
//     logger.d("Señal WebRTC enviada: $message");
//   }

//   void listenForMessages(void Function(Map<String, dynamic>) callback) {
//     client?.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
//       for (var message in messages) {
//         final payload = message.payload as MqttPublishMessage;
//         final messageBytes = payload.payload.message;

//         // Decodifica el mensaje como UTF-8
//         final messageText = utf8.decode(messageBytes);

//         // Decodifica el JSON
//         try {
//           final jsonData = jsonDecode(messageText);
//           callback(jsonData);

//           // Si es una señal WebRTC, actúa en consecuencia
//           if (jsonData.containsKey("type") && jsonData["type"] == "webrtc") {
//             handleWebRTCSignal(jsonData);
//           }

//         } catch (e) {
//           loggerNoStack.w('Error al decodificar JSON: $e');          
//         }
//       }
//     });
//   }

//   /// **Manejo de señales WebRTC**
//   void handleWebRTCSignal(Map<String, dynamic> signal)async {
//     logger.d("Señal WebRTC recibida: $signal");
//     print('Recibiendo ICE Candidate remoto: ${signal['candidate']}');
//       final candidate = RTCIceCandidate(
//         signal['candidate'],
//         signal['sdpMid'],
//         signal['sdpMLineIndex'],
//       );
//       print("➡️ Agregando ICE candidate: $candidate");
//       try {
//       final webrtcProvider = Provider.of<WebRTCProvider>(navigatorKey.currentContext!, listen: false);
//       print('Intentando agregar ICE Candidate al peerConnection del emisor...');
//         await webrtcProvider.webrtcService?.peerConnection?.addCandidate(candidate);
//         print('ICE Candidate agregado exitosamente (o eso parece).');
//       } catch (e) {
//         print('⚠️ Error al agregar ICE Candidate del receptor en el emisor: $e');
//       }
//     // if (signal.containsKey("sdp")) {
//     //   String sdp = signal["sdp"];
//     //   bool isOffer = signal["sdpType"] == "offer"; // Determina si es una oferta

//     //   if (navigatorKey.currentContext != null) {
//     //     showCallUI(navigatorKey.currentContext!, sdp, isOffer);
//     //   }
//     // } else {
//     //   loggerNoStack.w("No se encontró SDP en la señal WebRTC");
//     // }
//   }

//   void showCallUI(BuildContext context, String sdp, bool isOffer)async {
//     final mqttManagerProvider = Provider.of<MQTTManagerProvider>(context, listen: false);
                                

//                                 if (mqttManagerProvider.mqttManager == null) {
//                                   await mqttManagerProvider.initializeMQTT(deviceId);
//                                 }

//                                 bool isConnected = await mqttManagerProvider.mqttManager!.ensureConnection();
//                                 if (!isConnected) {
//                                   print("No se pudo conectar al MQTT");
//                                   return;
//                                 }

//     final webrtcProvider = Provider.of<WebRTCProvider>(context, listen: false);
//                                 final webRTCService = webrtcProvider.init(mqttManagerProvider.mqttManager!);

//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => CallScreen(
//                                       remoteSdp: webRTCService.remoteSdp!,
//                                       webrtcService: webRTCService,
//                                       isOffer: true,
//                                     ),),
//     );
//   }

//   void disconnect() {
//     client?.disconnect();
//   }

//   // Verifica si el cliente está conectado antes de realizar alguna acción
//   Future<bool> ensureConnection() async {
//     if (client?.connectionStatus?.state == MqttConnectionState.connected) {
//       //loggerNoStack.w('Cliente MQTT no está conectado. Intentando reconectar...');       
//     return true;
//     }
//     final battery = Battery();
//     final level = await battery.batteryLevel;

//     if (level < 20) {
//       loggerNoStack.w('Batería baja ($level%), retrasando reconexión');
//       return false;
//     }    
//     // loggerNoStack.w('Cliente MQTT no está conectado. Intentando reconectar...'); 
//     return await connect();
//   }

// }