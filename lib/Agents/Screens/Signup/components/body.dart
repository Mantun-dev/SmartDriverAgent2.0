// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Agents/Screens/Register/register_screen.dart';
import 'package:flutter_auth/Agents/models/register.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/components/progress_indicator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:quickalert/quickalert.dart';

import '../../../../constants.dart';
import '../../Welcome/welcome_screen.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //declaración de variables globales para sign up
  final prefs = new PreferenciasUsuario();
  TextEditingController user = new TextEditingController();
  TextEditingController userEmail = new TextEditingController();
  TextEditingController userPassword = new TextEditingController();
  bool? _passwordVisible;
  TextEditingController userPasswordC = new TextEditingController();
  bool? _passwordVisibleC;
  String ip = "https://smtdriver.com";
  bool camposVaciosAlerta = false;

  //variables que necesitan incialización que son preferencias de usuarios
  @override
  void initState() {
    super.initState();
    user = new TextEditingController(text: prefs.nombreUsuario);
    userEmail = new TextEditingController(text: prefs.emailUsuario);
    _passwordVisible = true;
    _passwordVisibleC = true;
  }

  //función fetch para registrar usuarios
  Future<dynamic> fetchUserRegister(String agentUser, String agentEmail, password1) async {
    //<List<Map<String,Register>>>
    LoadingIndicatorDialog().show(context);
    Map data = {'agentUser': agentUser, 'agentEmail': agentEmail};
    //manejo de api register
    http.Response responses =
        await http.post(Uri.parse('$ip/api/code'), body: data);
    final no = Register.fromJson(json.decode(responses.body));
    //redirección y alertas

    LoadingIndicatorDialog().dismiss();
    if(mounted){
      if (responses.statusCode == 200 && no.ok == true) {
      prefs.nombreUsuario = agentUser;
      prefs.emailUsuario = agentEmail;
      prefs.passwordUsuario=password1;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder:(BuildContext context) => RegisterScreen()),
        (Route<dynamic> route) => false
      );
      QuickAlert.show(
        context: context,
        title: no.title,
        text: no.message,
        type: QuickAlertType.success,
        confirmBtnText: "Ok"
      );

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
                      pageBuilder: (_, __, ___) => WelcomeScreen(),
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
  
            Center(child: Text("Regístrate",style: TextStyle(color: Color.fromRGBO(40, 93, 169, 1), fontSize: 27),)),
          ],
        ),
        SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.all(30.0),
          child: Text(
            "Escribe tu número de empleado asignado o identidad y tu correo electrónico. Te enviaremos un código de confirmación para que puedas registrarte.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black,fontSize: 14),
          ),
        ),
        _crearUsuario(),
        SizedBox(height: 10),
        _crearEmail(),
        SizedBox(height: 10),
        _crearPassword(),
        SizedBox(height: 10),
        _crearPasswordConfirm(),
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
                          //función fetch
                          if(userPassword.text.isEmpty){

                            QuickAlert.show(
                              context: context,
                              title: "Alerta",
                              text: "Campos vacíos",
                              type: QuickAlertType.error,
                              confirmBtnText: "Ok"
                            );

                            setState(() {
                              camposVaciosAlerta = true;
                            });
                            return;
                          }

                          if(userPasswordC.text!=userPassword.text){

                             QuickAlert.show(
                              context: context,
                              title: "Alerta",
                              text: "Confirme su contraseña",
                              type: QuickAlertType.error,
                              confirmBtnText: "Ok"
                            );

                            setState(() {
                              camposVaciosAlerta = true;
                            });
                            return;
                          }
                          await fetchUserRegister(user.text, userEmail.text, userPassword.text);
                        },
                        child: Text(
                          "Enviar código",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.normal
                          ),
                        ),
                      ),
        
        SizedBox(height: 10),

        GestureDetector(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '¿Ya tienes una cuenta? ',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.normal
                ),
              ),
              Text(
                'Ingresa aquí',
                style: TextStyle(
                  fontSize: 14,
                  color: Color.fromRGBO(40, 93, 169, 1),
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

//Widgets usuario y password
  Widget _crearUsuario() {
    return Container(
      margin: EdgeInsets.only(left: 40, right: 40),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
              controller: user,
              cursorColor: Colors.black,
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
              onChanged: (value) {
                //prefs.nombreUsuario = value;
              },
            ),
          ),
          Divider(
            color: Color.fromRGBO(158, 158, 158, 1),
            thickness: 1.0,
          )
        ],
      ),
    );
  }

  Widget _crearEmail() {
    return Container(
      margin: EdgeInsets.only(left: 40, right: 40),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
              controller: userEmail,
              //onChanged: onChanged,
              cursorColor: thirdColor,
              decoration: InputDecoration(
                hintText: "Email",
                icon: SvgPicture.asset(  
                  "assets/icons/correo.svg",
                  color: Color.fromRGBO(40, 93, 169, 1),
                  width: 20,
                  height: 20,
                ),
                border: InputBorder.none,
                hintStyle: TextStyle(color: camposVaciosAlerta==true?Colors.red:Color.fromRGBO(134, 134, 134, 1), fontWeight: FontWeight.normal),
              ),
              onChanged: (value) {
                //prefs.emailUsuario = value;
              },
            ),
          ),

          Divider(
            color: Color.fromRGBO(158, 158, 158, 1),
            thickness: 1.0,
          )
        ],
      ),
    );
  }

  Widget _crearPassword() {
    return Container(
      margin: EdgeInsets.only(left: 40, right: 40),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
              //keyboardType: TextInputType.,
              controller: userPassword,
              obscureText: _passwordVisible!,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: "Contraseña",
                hintStyle: TextStyle(color: camposVaciosAlerta==true?Colors.red:Color.fromRGBO(134, 134, 134, 1), fontWeight: FontWeight.normal),
                icon: SvgPicture.asset(  
                  "assets/icons/candado.svg",
                  color: Color.fromRGBO(40, 93, 169, 1),
                  width: 25,
                  height: 25,
                ),
                suffixIcon: IconButton(
                  padding: EdgeInsets.only(left: 10),
                  tooltip: 'Ver contraseña',
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ?? false
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Color.fromRGBO(40, 93, 169, 1),
                    size: 30,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible!;
                    });
                  },
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Divider(
            color: Color.fromRGBO(158, 158, 158, 1),
            thickness: 1.0,
          )
        ],
      ),
    );
  }

  Widget _crearPasswordConfirm() {
    return Container(
      margin: EdgeInsets.only(left: 40, right: 40),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            child: TextField(
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
              //keyboardType: TextInputType.,
              controller: userPasswordC,
              obscureText: _passwordVisibleC!,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: "Confirmar contraseña",
                hintStyle: TextStyle(color: camposVaciosAlerta==true?Colors.red:Color.fromRGBO(134, 134, 134, 1), fontWeight: FontWeight.normal),
                icon: SvgPicture.asset(  
                  "assets/icons/candado.svg",
                  color: Color.fromRGBO(40, 93, 169, 1),
                  width: 25,
                  height: 25,
                ),
                suffixIcon: IconButton(
                  padding: EdgeInsets.only(left: 10),
                  tooltip: 'Ver contraseña',
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisibleC ?? false
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Color.fromRGBO(40, 93, 169, 1),
                    size: 30,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisibleC = !_passwordVisibleC!;
                    });
                  },
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Divider(
            color: Color.fromRGBO(158, 158, 158, 1),
            thickness: 1.0,
          )
        ],
      ),
    );
  }

}
