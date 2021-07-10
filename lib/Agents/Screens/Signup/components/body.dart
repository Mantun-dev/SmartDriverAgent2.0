import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Agents/Screens/Register/register_screen.dart';
import 'package:flutter_auth/Agents/Screens/Signup/components/background.dart';
import 'package:flutter_auth/Agents/models/register.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:sweetalert/sweetalert.dart';

import '../../../../constants.dart';


class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //declaración de variables globales para sign up
    final prefs = new PreferenciasUsuario();
    TextEditingController user = new TextEditingController();
    TextEditingController userEmail = new TextEditingController();
   String ip = "https://smtdriver.com";

    //variables que necesitan incialización que son preferencias de usuarios
    @override
    void initState() {
      super.initState();
      user = new TextEditingController( text: prefs.nombreUsuario );
      userEmail = new TextEditingController(text: prefs.emailUsuario);
    }

  //función fetch para registrar usuarios
  Future<dynamic>fetchUserRegister(String agentUser, String agentEmail) async {
    //<List<Map<String,Register>>>
    Map data = {
      'agentUser' : agentUser,
      'agentEmail' : agentEmail
    };
    //manejo de api register    
    http.Response responses = await http.post(Uri.encodeFull('$ip/api/code'), body: data);
    final no = Register.fromJson(json.decode(responses.body));
    //redirección y alertas
     if (responses.statusCode == 200 && no.ok == true) {   
     setState(() {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>
          RegisterScreen()), (Route<dynamic> route) => false);
      });
      SweetAlert.show(context,
        title: no.title,
        subtitle: no.message,
        style: SweetAlertStyle.success
      );
      } else if (no.ok != true) {
        SweetAlert.show(context,
          title: no.title,
          subtitle: no.message,
          style: SweetAlertStyle.error,
        );
      }
      return Register.fromJson(json.decode(responses.body));
  } 

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "REGÍSTRATE",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/signup.svg",
              height: size.height * 0.35,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Text(
                "Escribe tu usuario designado y un correo válido, se enviará un código de confirmación para que puedas registrarte",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            _crearUsuario(),
            _crearEmail(),
            RoundedButton(
              text: "SOLICITAR CÓDIGO",
              press: () {
                //función fetch
                fetchUserRegister(user.text, userEmail.text);
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

//Widgets usuario y password
  Widget _crearUsuario(){
    return TextFieldContainer(
      child: TextField(
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
        onChanged: ( value ) {
          prefs.nombreUsuario = value;
        },
    ),
    );
  }

  Widget _crearEmail(){
    return TextFieldContainer(
     child: TextField(
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
}
