import 'package:flutter/foundation.dart';
import 'package:flutter_auth/Agents/models/message_chat.dart';

class ChatProvider extends ChangeNotifier {
  final List<Message> _mensaje = [];

  List<Message> get mensaje => _mensaje;

  addNewMessage(Message mensaje) {
    _mensaje.add(mensaje);
    notifyListeners();
  }
}
