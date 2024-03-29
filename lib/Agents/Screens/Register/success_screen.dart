import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Login/login_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../Signup/signup_screen.dart';

class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Stack(
        children: [
          Lottie.asset('assets/videos/confeti.json'),
          Body(),
        ],
      )),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //variables globales para register user y code

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        SizedBox(height: 20),
        Stack(
          children: [
            Container(
              margin: EdgeInsets.only(left: 40, right: 40),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
                      pageBuilder: (_, __, ___) => SignUpScreen(),
                      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(-1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color.fromRGBO(40, 93, 169, 1),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            "assets/icons/flecha_atras_oscuro.svg",
                            color: Color.fromRGBO(40, 93, 169, 1),
                            width: 5,
                            height: 10,
                          ),
                        ),
                ),
              ),
            ),
    
            Center(child: Text("   Registro completado",style: TextStyle(color: Color.fromRGBO(40, 93, 169, 1), fontSize: 22),),),
          ],
        ),
        SizedBox(height: 20),
        Container(
          constraints: BoxConstraints(
            maxWidth: 300,
            maxHeight: 300,
          ),
          child: Lottie.asset('assets/videos/sucess.json')
        ),
        SizedBox(height: 20),
        Text(
          '¡Felicidades!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
          )
        ),
        SizedBox(height: 5),
        Text(
          'Te has registrado exitosamente',
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 21,
          )
        ),
    
        SizedBox(height: size.height*0.2,),

        OutlinedButton(
          style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: BorderSide(color: Colors.black),
          fixedSize: Size(size.width-80, 50)
          ),
          onPressed: () {
            Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 200 ), // Adjust the animation duration as needed
                      pageBuilder: (_, __, ___) => LoginScreen(),
                      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(-1.0, 0.0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        );
                      },
                    ),
                  );
          },
          child: Text(
            "Ingresar",
            style: TextStyle(
              color: Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.normal
            ),
          ),
        ),
    
      ],
    
    );
  }

}