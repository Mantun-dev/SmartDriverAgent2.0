import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';

class SolicitudCambio extends StatelessWidget {
  final bool? profile;
  final VoidCallback? press;
  const SolicitudCambio({
    Key? key,
    this.profile = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0),
      margin: EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                profile != null ? '¿Es su informacion incorrecta?' : "",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  color: GradiantV_1,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: press,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Text(
                profile != null ? "\tSolicita cambio aquí." : "",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  color: GradiantV_1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
