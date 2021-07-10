import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';


//aquí está la clase para después traer la api
class Plantilla {
  final String image, title, name;
  final int size, id;
  final Color color;
  final description;
  Plantilla({
    this.id,
    this.image,
    this.title,
    this.name,
    this.description,
    this.size,
    this.color,
  });
}


//aquí la lista que llamamos para mostrar el texto de las imagenes y las imagenes
List<Plantilla> plantilla = [
  Plantilla(
      id: 1,
      title: "Mis próximos viajes",
      name: '',
      size: 20,
      description: dummyText,
      image: "assets/images/destination.png",
      color: kCardColor1),
  Plantilla(
      id: 2,
      title: "Historial de viajes",
      name: '',
      size: 20,
      description: dummyText2,
      image: "assets/images/checklist.png",
      color: kCardColor2),
  Plantilla(
      id: 3,
      title: "Generar código QR",
      name: '',
      size: 20,
      description: dummyText4,
      image: "assets/images/QR.png",
      color: kCardColor2),
  Plantilla(
      id: 4,
      title: "Solicitud de cambios",
      name: '',
      size: 20,
      description: dummyText3,
      image: "assets/images/ticket.png",
      color: kCardColor1),
  
];

List<Plantilla> plantilla2 = [
  Plantilla(
      id: 1,
      title: "Mis próximos viajes",
      name: 'Carlos',
      size: 20,
      description: dummyText,
      image: "assets/images/destination.png",
      color: kCardColor1),
  Plantilla(
      id: 2,
      title: "Historial de viajes",
      name: '234',
      size: 20,
      description: dummyText2,
      image: "assets/images/checklist.png",
      color: kCardColor2),
  Plantilla(
      id: 4,
      title: "Generar código QR",
      name: '234',
      size: 20,
      description: dummyText4,
      image: "assets/images/QR.png",
      color: kCardColor1),
];

String dummyText = "Prueba uno we";

String dummyText2 = "Prueba 2 we";

String dummyText3 = "Prueba 3 we";

String dummyText4 = "prueba 4 we";
