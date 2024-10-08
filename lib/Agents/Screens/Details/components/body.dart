import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/components/description.dart';
//import 'package:flutter_auth/constants.dart';

class Body extends StatefulWidget {
  final Plantilla plantilla;
  const Body({
    Key? key,
    required this.plantilla,    
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return widget.plantilla.id!=4?Padding(
      padding: const EdgeInsets.all(12.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 700.0, // Aquí defines el ancho máximo deseado
        ),
        child: Container(
          width: size.width,
          decoration: BoxDecoration(
            border: Border.all( 
              color: Theme.of(context).disabledColor,
              width: 2
            ),
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20)
          ),
          child: SingleChildScrollView(
            child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Description(plantilla: widget.plantilla),
            ),
          ),
        ),
      ),
    ):ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 700.0, // Aquí defines el ancho máximo deseado
      ),
      child: Description(plantilla: widget.plantilla));
  }
}
