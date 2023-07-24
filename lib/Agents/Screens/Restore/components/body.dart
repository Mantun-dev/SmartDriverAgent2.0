// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Agents/Screens/Restore/components/background.dart';
import 'package:flutter_auth/Agents/models/register.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/components/progress_indicator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'dart:convert' show json;
import 'package:quickalert/quickalert.dart';
import '../../../../constants.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //variables globales para restablecer contraseña
  final prefs = new PreferenciasUsuario();
  TextEditingController user = new TextEditingController();
  String ip = "https://smtdriver.com";
  bool camposVaciosAlerta = false;

  @override
  void initState() {
    super.initState();
    user = new TextEditingController(text: prefs.nombreUsuario);
  }

//función fetch para restore pass
  Future<dynamic> fetchUserResetPass(String agentUser) async {
    LoadingIndicatorDialog().show(context);
    //<List<Map<String,Register>>>
    Map data = {'agentUser': agentUser};

    //api restore
    http.Response responses =
        await http.post(Uri.parse('$ip/api/reset'), body: data);
    final no = Register.fromJson(json.decode(responses.body));
    //alertas y redirecciones
    //print(responses.body);

    LoadingIndicatorDialog().dismiss();
    if(mounted){
      if (responses.statusCode == 200 && no.ok == true) {
        setState(() {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
              (Route<dynamic> route) => false);
        });
        QuickAlert.show(
          context: context,
            title: no.title,
            text: no.message,
            type: QuickAlertType.success,
            confirmBtnText: "Ok");
      } else if (no.ok != true) {
        QuickAlert.show(
          context: context,
            title: no.title,
            text: no.message,
            type: QuickAlertType.error,
            confirmBtnText: "Ok");
      }
    }
    return Register.fromJson(json.decode(responses.body));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Container(
        height: size.height,
        child: Column(

        children: [
          SizedBox(height: 20),
          Container(
            width: size.width,
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 40, right: 40),
                  child: GestureDetector(
                    onTap: () {
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
  
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Reestablecer",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 27, color: Color.fromRGBO(40, 93, 169, 1)),
                      ),
                      Text(
                        "Contraseña",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 27, color: Color.fromRGBO(40, 93, 169, 1)),
                      ),

                      SizedBox(height: 20),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: 180,
                          maxHeight: 180,
                        ),
                        child: Lottie.asset('assets/videos/contraR.json')
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 40, right: 40),
            child: Column(
                children: [
                  SizedBox(height: 30),
                  Text(
                    'Escribe tu número de empleado asignado o identidad, te enviaremos un enlace al correo para que puedas restablecer tu contraseña.',
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: (14.0),
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: _crearUsuario(),
                  ),
                  SizedBox(height: size.height * 0.04),
                  OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: const Color.fromRGBO(40, 93, 169, 1)),
                                fixedSize: Size(size.width-80, 50),
                                backgroundColor: const Color.fromRGBO(40, 93, 169, 1)
                              ),
                              onPressed: () {
                                if(user.text.isEmpty){
                                  QuickAlert.show(
                                  context: context,
                                  title: "Alerta",
                                  text: "Campos Vacios",
                                  type: QuickAlertType.error,
                                  confirmBtnText: "Ok"
                                );

                                setState(() {
                                  camposVaciosAlerta = true;
                                });
                            return;
                                }
                                fetchUserResetPass(user.text);
                              },
                              child: Text(
                                "Enviar",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal
                                ),
                              ),
                            ),
                ],
              ),
          ),

        ],
      ),
      ),
    );
  }

//Widgets fields
  Widget _crearUsuario() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: TextField(
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
            controller: user,
            //onChanged: onChanged,
            cursorColor: thirdColor,
            decoration: InputDecoration(
              icon: SvgPicture.asset(  
                  "assets/icons/usuario.svg",
                  color: Color.fromRGBO(40, 93, 169, 1),
                  width: 20,
                  height: 20,
                ),
              hintText: "Número de empleado o identidad",
              hintStyle: TextStyle(color: camposVaciosAlerta==true?Colors.red:Color.fromRGBO(134, 134, 134, 1), fontWeight: FontWeight.normal),
              border: InputBorder.none,
            ),
          ),
        ),
        Divider(
          color: Color.fromRGBO(158, 158, 158, 1),
          thickness: 1.0,
        )
      ],
    );
  }
}
