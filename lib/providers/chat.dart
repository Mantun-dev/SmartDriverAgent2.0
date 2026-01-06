import 'package:flutter/foundation.dart';
import 'package:flutter_auth/Agents/models/message_chat.dart'; // Asegúrate de que este path es correcto
// Asegúrate de que este path es correcto
class ChatProvider extends ChangeNotifier {
 List<Message> mensaje2 = [];
 List<Message> get mensaje => mensaje2;
 
 addNewMessage(Message mensaje) {
    mensaje2.add(mensaje);
    notifyListeners();

    bool alreadyExists = mensaje2.any((m) => 
    (mensaje.tempId != null && m.tempId == mensaje.tempId) ||
    (m.mensaje == mensaje.mensaje && m.hora == mensaje.hora && m.id == mensaje.id)
  );

  if (!alreadyExists) {
    mensaje2.add(mensaje);
    notifyListeners();
  } else {
    print("⚠️ Intento de duplicado bloqueado: ${mensaje.mensaje}");
  }
  }
  
  void updateMessageStatus(dynamic tempMessageId, MessageStatus newStatus) {
    // 🛑 ¡CORRECCIÓN CLAVE AQUÍ! 🛑
    // Buscamos usando el campo tempId del objeto MessageDriver.
    final index = mensaje2.indexWhere((msg) => msg.tempId == tempMessageId); 

    if (index != -1) {
      final updatedMessage = mensaje2[index].copyWith(status: newStatus);

      mensaje2[index] = updatedMessage;

      notifyListeners(); 
      print('✅ Estado del mensaje $tempMessageId actualizado a: $newStatus');
    } else {
      // Este es el mensaje de error que estamos viendo
      print('⚠️ Mensaje con ID $tempMessageId no encontrado para actualizar su estado.');
    }
  }
}