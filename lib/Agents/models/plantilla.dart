import 'package:flutter/material.dart';

//aquí está la clase para después traer la api
class Plantilla {
  final String image, title, name;
  final int id;
  final Color color;
  final description;
  Plantilla({
    required this.id,
    required this.image,
    required this.title,
    required this.name,
    required this.description,
    required this.color,
  });
}

//aquí la lista que llamamos para mostrar el texto de las imagenes y las imagenes
List<Plantilla> plantilla = [
  Plantilla(
      id: 1,
      title: "Próximos viajes",
      name: '',
      //size: 100,
      description: 'Confirma o cancela mi próximo viaje',
      image: "assets/icons/proximo_viaje.svg",
      color: Colors.white),
  Plantilla(
      id: 2,
      title: "Historial de viajes",
      name: '',
      //size: 20,
      description: 'Revisar mis viajes programados',
      image: "assets/icons/historial_de_viaje.svg",
      color: Colors.white),
  Plantilla(
      id: 3,
      title: "Generar código QR",
      name: '',
      //size: 20,
      description: 'Presenta tu código QR antes de abordar',
      image: "assets/icons/QR.svg",
      color: Colors.white),
  Plantilla(
      id: 4,
      title: "Solicitud de cambios",
      name: '',
      // size: 20,
      description: 'Enviar una solicitud de cambio',
      image: "assets/icons/solicitud_de_cambio.svg",
      color: Colors.white),
  // Plantilla(
  //     id: 5,
  //     title: "Chatea con tu\nconductor",
  //     name: '',
  //     //size: 20,
  //     description: 'Pendiente Pendiente\nPendiente Pendiente.',
  //     image: "assets/images/ticket.png",
  //     color: backgroundColor),
];
