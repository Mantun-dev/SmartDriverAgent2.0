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
    return GestureDetector(
      onTap: press,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            login ?? false
                ? "¿No tienes una cuenta? "
                : "¿Ya tienes alguna cuenta?",
            style: TextStyle(color: Colors.white,fontSize: 14),
          ),
          Text(
            login != null ? "Regístrate aquí" : "Ingresa aquí",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}
