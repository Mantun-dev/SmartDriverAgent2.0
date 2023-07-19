import 'package:flutter/material.dart';

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Flexible(
                child: Text(
                  profile != null ? '¿Es su informacion incorrecta?' : "",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: press,
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Flexible(
                child: Text(
                  profile != null ? "\tSolicita un cambio aquí." : "",
                  textAlign: TextAlign.left,
                  
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromRGBO(40, 93, 169, 1),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
