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
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Column(
              children: [
                Description(plantilla: widget.plantilla),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
