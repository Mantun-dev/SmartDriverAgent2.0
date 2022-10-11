class Message {
  final String mensaje;
  final String user;
  // final DateTime sentAt;

  Message({
    required this.mensaje,
    required this.user,
    // required this.sentAt,
  });

  factory Message.fromJson(Map<String, dynamic> mensaje) {
    return Message(
      mensaje: mensaje['mensaje'],
      user: mensaje['user'],
      // sentAt: DateTime.fromMillisecondsSinceEpoch(mensaje['sentAt']),
    );
  }
}
