// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Register/fail_screen.dart';
import 'package:flutter_auth/Agents/models/register.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';

import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'dart:convert' show json;
import 'package:quickalert/quickalert.dart';

import '../../../../constants.dart';
import '../../Signup/signup_screen.dart';
import '../success_screen.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //variables globales para register user y code
  final prefs = new PreferenciasUsuario();
  TextEditingController user = new TextEditingController();
  TextEditingController userEmail = new TextEditingController();
  TextEditingController userCode = new TextEditingController();
  TextEditingController userPassword1 = new TextEditingController();
  TextEditingController userPassword2 = new TextEditingController();
  String ip = "https://smtdriver.com";

  @override
  void initState() {
    super.initState();
    user = new TextEditingController(text: prefs.nombreUsuarioDos);
    userEmail = new TextEditingController(text: prefs.emailUsuario);
  }

  //función fetch register user and code
  Future<dynamic> fetchUserRegisterCode(
      String agentUser,
      String agentEmail,
      String agentSecurityCode,
      String agentPassword,
      String agentPassword2) async {
    //<List<Map<String,Register>>>
    Map data = {
      'agentUser': agentUser,
      'agentEmail': agentEmail,
      'agentSecurityCode': agentSecurityCode,
      'agentPassword': agentPassword,
      'agentPassword2': agentPassword2
    };
    print(data);
    //api register
    http.Response responses =
        await http.post(Uri.parse('$ip/api/register'), body: data);
    final no = Register.fromJson(json.decode(responses.body));
    //redirección y alertas
    if (responses.statusCode == 200 && no.ok == true) {
      Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500 ), // Adjust the animation duration as needed
                      pageBuilder: (_, __, ___) => SuccessScreen(),
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
    } else if (no.ok != true) {
     Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500 ), // Adjust the animation duration as needed
                      pageBuilder: (_, __, ___) => FailScreen(),
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
    }
    return Register.fromJson(json.decode(responses.body));
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
                      transitionDuration: Duration(milliseconds: 500 ), // Adjust the animation duration as needed
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
  
            Center(child: Text("Ingresar código",style: TextStyle(color: Color.fromRGBO(40, 93, 169, 1), fontSize: 27),),),
          ],
        ),
        
        SizedBox(height: 30),
        Container(
              constraints: BoxConstraints(
                maxWidth: 240,
                maxHeight: 240,
              ),
              child: Lottie.asset('assets/videos/FxfwM1KqES.json')
            ),
        SizedBox(height: 40),

        Text(
          'Ingresa el código de verificación',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 21,
          )
        ),
        SizedBox(height: 15),
        Text(
          'Te enviamos un código de verificación a tu correo electrónico',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          )
        ),
          SizedBox(height: 5),
          Center(
            child: GestureDetector(
              onTap: () async{
                await fetchUserRegister(prefs.nombreUsuario, prefs.emailUsuario);
              },
              child: Text(
                'Reenviar código',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color.fromRGBO(40, 93, 169, 1)
                )
              ),
            ),
          ),

        SizedBox(height: 30),
        _crearCode(),
        SizedBox(height: 20),
  
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(color: Colors.black),
              fixedSize: Size(size.width-80, 50),
              backgroundColor: Colors.black
          ),
          onPressed: () async {
            fetchUserRegisterCode(prefs.nombreUsuario, prefs.emailUsuario,userCode.text, prefs.passwordUsuario, prefs.passwordUsuario);
          },
          child: Text(
            "Verificar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.normal
            ),
          ),
        ),
        SizedBox(height: size.height * 0.05),
      ],
    );
  }

  Future<dynamic> fetchUserRegister(String agentUser, String agentEmail) async {
    //<List<Map<String,Register>>>
    Map data = {'agentUser': agentUser, 'agentEmail': agentEmail};
    //manejo de api register
    http.Response responses =
        await http.post(Uri.parse('$ip/api/code'), body: data);
    final no = Register.fromJson(json.decode(responses.body));
    //redirección y alertas
    if (responses.statusCode == 200 && no.ok == true) {

      QuickAlert.show(
        context: context,
        title: no.title,
        text: "Se reenvio el codigo.",
        type: QuickAlertType.success
      );

    } else if (no.ok != true) {
        QuickAlert.show(
        context: context,
          title: no.title,
          text: no.message,
          type: QuickAlertType.error);
    }
    return Register.fromJson(json.decode(responses.body));
  }

//Widgets de fields
  Widget crearUsuario() {
    return TextFieldContainer(
      child: TextField(
        enabled: false,
        controller: user,
        //onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            Icons.person,
            color: kPrimaryColor,
          ),
          hintText: "Ingrese su usuario",
          border: InputBorder.none,
        ),
        onChanged: (value) {
          prefs.nombreUsuarioDos = value;
        },
      ),
    );
  }

  Widget crearEmail() {
    return TextFieldContainer(
      child: TextField(
        enabled: false,
        controller: userEmail,
        //onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Ingresa tu email",
          icon: Icon(
            Icons.email,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          prefs.emailUsuario = value;
        },
      ),
    );
  }

  Widget _crearCode() {
    int length = userCode.text.length+1;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: Stack(
              children: [
                TextField(
                  onChanged: (value) => setState(() {}),
                  maxLength: 4,
                  style: TextStyle(color: Colors.transparent, fontSize: 37),
                  obscureText: true,
                  controller: userCode,
                  cursorColor: Colors.transparent,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  buildCounter: (BuildContext context, { int? currentLength, int? maxLength, bool? isFocused }) => SizedBox.shrink(),
                ),
                Positioned.fill(
                  bottom: 20,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        length--;
                        return Column(
                          children: [
                            Column(
                              children: [
                                length>0? Text("*", style: TextStyle(color: Colors.black, fontSize: 37),):Text(''),
                                Container(
                                  width: 20,
                                  height: 2,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget crearPassw1() {
    return TextFieldContainer(
      child: TextField(
        controller: userPassword1,
        obscureText: true,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Contraseña",
          icon: Icon(
            Icons.lock_rounded,
            color: kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget crearPassw2() {
    return TextFieldContainer(
      child: TextField(
        controller: userPassword2,
        obscureText: true,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Confirmar contraseña",
          icon: Icon(
            Icons.lock_rounded,
            color: kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
