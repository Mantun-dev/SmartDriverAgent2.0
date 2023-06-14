import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  final bool login;
  final VoidCallback? press;
  const ForgotPassword({Key? key, this.login = true, this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: press,
          child: Text(
            login
                ? "¿Has olvidado tu contraseña?"
                : "¿Quieres reestablecer contraseña? ",
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
