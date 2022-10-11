import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';

//aquí está la clase para después traer la api
class Plantilla {
  final String image, imageMain, title, name;
  final int id;
  final Color color;
  final description;
  Plantilla({
    required this.id,
    required this.image,
    required this.imageMain,
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
      description: 'Confirmar los viajes\npendientes a realizar.',
      image: "assets/images/destination.png",
      imageMain: "assets/icons/Plantilla2_1.svg",
      color: backgroundColor),
  Plantilla(
      id: 2,
      title: "Historial de viajes",
      name: '',
      //size: 20,
      description: 'Corroborar sus viajes\nrealizados.',
      image: "assets/images/checklist.png",
      imageMain: "assets/icons/Plantilla2_2.svg",
      color: backgroundColor),
  Plantilla(
      id: 3,
      title: "Generar código QR",
      name: '',
      //size: 20,
      description: 'Observar su código QR\npara sus viajes.',
      image: "assets/images/QR.png",
      imageMain: "assets/icons/Plantilla2_3.svg",
      color: backgroundColor),
  Plantilla(
      id: 4,
      title: "Solicitud de cambios",
      name: '',
      // size: 20,
      description:
          'Envio de tickets para\nsolicitud de cambios y\nrevisión de historial\nde los tickets.',
      image: "assets/images/ticket.png",
      imageMain: "assets/icons/Plantilla2_4.svg",
      color: backgroundColor),
  // Plantilla(
  //     id: 5,
  //     title: "Chatea con tu\nconductor",
  //     name: '',
  //     //size: 20,
  //     description: 'Pendiente Pendiente\nPendiente Pendiente.',
  //     image: "assets/images/ticket.png",
  //     color: backgroundColor),
];
