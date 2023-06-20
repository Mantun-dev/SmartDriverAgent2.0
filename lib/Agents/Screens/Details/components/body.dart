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
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          border: Border.all( 
            color: Color.fromRGBO(238, 238, 238, 1),
            width: 2
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        child: SingleChildScrollView(
          child: Expanded(
            child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Description(plantilla: widget.plantilla),
          )),
        ),
      ),
    ):Description(plantilla: widget.plantilla);
  }
}
