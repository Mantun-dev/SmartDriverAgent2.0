import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/providers/chat.dart';
import 'package:flutter_svg/svg.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:provider/provider.dart';

import '../../models/message_chat.dart';
import '../Profile/profile_screen.dart';
import 'socketChat.dart';

class ChatScreen extends StatefulWidget {
  final String nombre;
  final String sala;
  final String rol;
  const ChatScreen(
      {Key? key, required this.nombre, required this.sala, required this.rol})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _socketResponse = StreamController<dynamic>();
  Stream<dynamic> get getResponse => _socketResponse.stream;
  IO.Socket? socket;
  final TextEditingController _messageInputController = TextEditingController();
  var usuario = {};

  final StreamSocket streamSocket = StreamSocket(host: '192.168.1.3:3010');
  _sendMessage() {
    // ignore: avoid_print
    print(_messageInputController.text);
    streamSocket.socket.emit('enviar-mensaje', {
      'mensaje': _messageInputController.text.trim(),
      'user': widget.nombre,
      'sala': widget.sala,
      'id': usuario['id'],
    });
    _messageInputController.clear();
  }

  @override
  void initState() {
    super.initState();
    //Important: If your server is running on localhost and you are testing your app on Android then replace http://localhost:3000 with http://10.0.2.2:3000
    streamSocket.connectAndListen();
    streamSocket.socket
        .emit('entrarChat', {'nombre': widget.nombre, 'rol': widget.rol});

    streamSocket.socket.on('flutter-datainfo', (data) {
      // ignore: avoid_print
      print('*------------------------------*');
      print(data);
      _socketResponse.add(data);
      usuario = data;
    });

    streamSocket.socket.on(
      'flutter-mensaje',
      ((data) {
        // ignore: avoid_print
        print(data);
        Provider.of<ChatProvider>(context, listen: false)
            .addNewMessage(Message.fromJson(data));
      }),
    );
    streamSocket.socket.on(
      'enviar-mensaje',
      ((data) {
        // ignore: avoid_print
        print(data);
        Provider.of<ChatProvider>(context, listen: false)
            .addNewMessage(Message.fromJson(data));
      }),
    );
  }

  @override
  void dispose() {
    _messageInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        shadowColor: Colors.black87,
        elevation: 10,
        iconTheme: IconThemeData(color: secondColor, size: 35),
        actions: <Widget>[
          //aquí está el icono de las notificaciones
          IconButton(
            icon: Icon(
              Icons.message,
              size: 35,
              color: firstColor,
            ),
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return ProfilePage();
              // }
              // )
              // );
            },
          ),
          IconButton(
            icon: SvgPicture.asset(
              "assets/icons/user.svg",
              width: 100,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProfilePage();
              }));
            },
          ),
          SizedBox(width: kDefaultPadding / 2)
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (_, provider, __) => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final message = provider.mensaje[index];
                  return Wrap(
                    alignment: message.user == widget.nombre
                        ? WrapAlignment.end
                        : WrapAlignment.start,
                    children: [
                      Card(
                        color: message.user == widget.nombre
                            ? Theme.of(context).primaryColorLight
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: message.user == widget.nombre
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            children: [
                              Text(message.mensaje),
                              // Text(
                              //   DateFormat('hh:mm a').format(message.sentAt),
                              //   style: Theme.of(context).textTheme.caption,
                              // ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
                separatorBuilder: (_, index) => const SizedBox(
                  height: 5,
                ),
                itemCount: provider.mensaje.length,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageInputController,
                      decoration: const InputDecoration(
                        hintText: 'Type your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_messageInputController.text.trim().isNotEmpty) {
                        _sendMessage();
                      }
                    },
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
