import 'package:flutter/foundation.dart';
import 'package:flutter_auth/Agents/models/message_chat.dart';

class ChatProvider extends ChangeNotifier {
  List<Message> mensaje2 = [];
  List<Message> get mensaje => mensaje2;
  
  addNewMessage(Message mensaje) {    
    //print(mensaje.user);    
    mensaje2.add(mensaje);
    notifyListeners();
  }
}
