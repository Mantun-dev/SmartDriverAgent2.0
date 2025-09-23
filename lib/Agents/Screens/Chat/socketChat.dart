import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class StreamSocket {
  final socketResponse = StreamController<dynamic>();
  Stream<dynamic> get getResponse => socketResponse.stream;

  final String host;
  late final IO.Socket socket;

  StreamSocket({required this.host}) {
    socket = IO.io(
        // 'https://$host',
        'http://$host',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setReconnectionAttempts(5)  // Intentará reconectar hasta 5 veces
            .setReconnectionDelay(2000)  // Esperará 2 segundos antes de intentar reconectar    
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build());
  }

  void connectAndListen() {
    socket.on('connect', (_) {
      // ignore: avoid_print
      //print('connected to chat');
      //socket.emit('msg', 'test');
    });

    // ignore: avoid_print
    socket.onConnectTimeout((data) => print('timeout'));
    // ignore: avoid_print
    socket.onConnectError((error) => print(error.toString()));
    // ignore: avoid_print
    socket.onError((error) => print(error.toString()));

    
    socket.on('unauthorized',(msg) => {
              // ignore: avoid_print
              //print('no doy'),
              // ignore: avoid_print
             // print(msg), // 'jwtoken not provided' || 'access denied'
            });

    socket.onDisconnect((_) => print('disconnect to chat'));
  }

  void connect() {}

  void close() {
    socketResponse.close();
    //socket.destroy();
    socket.close();
    //socket.disconnect().close();
  }
}
