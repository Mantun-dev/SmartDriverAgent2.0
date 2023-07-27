import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import '../constants.dart';

class PlantillaTitleWithImage extends StatelessWidget {
  const PlantillaTitleWithImage({
    Key? key,
    required this.plantilla,
  }) : super(key: key);

  final Plantilla plantilla;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 25.0),
                child: Text(
                  plantilla.title,
                  style: TextStyle(
                      fontSize: 18,
                      color: backgroundColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
