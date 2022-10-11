import 'package:flutter/material.dart';
import 'package:flutter_auth/constants.dart';

class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool? login;
  final VoidCallback? press;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ?? false
              ? "¿No tienes ninguna cuenta? "
              : "¿Ya tienes alguna cuenta? ",
          style: TextStyle(color: secondColor),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login != null ? "Regístrate aquí" : "Ingresa aquí",
            style: TextStyle(
              color: secondColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
