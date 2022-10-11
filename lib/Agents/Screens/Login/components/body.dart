// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/Screens/Login/components/background.dart';
import 'package:flutter_auth/Agents/Screens/Restore/restore_screen.dart';
import 'package:flutter_auth/Agents/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/dataAgentMessage.dart';
import 'package:flutter_auth/Agents/models/tokenCloseSession.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/Agents/sharePrefers/services.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/forgot_password.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:lottie/lottie.dart';
import 'package:sweetalert/sweetalert.dart';
import '../../../../constants.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' show json;

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //Declaración de variables globales
  TextEditingController userPassword = new TextEditingController();
  TextEditingController userName = new TextEditingController();
  String? userN;
  String? userP;
  String? agentId = '';
  String? countId = '';
  final prefs = new PreferenciasUsuario();
  String ip = "https://smtdriver.com";
  bool? _passwordVisible;

  //función fetch para logueo de usuario agente
  Future<dynamic> fetchUser(String agentUser, String agentPassword) async {
    Map data = {'agentUser': agentUser, 'agentPassword': agentPassword};
    String device = "mobile";
    if (agentUser == "" && agentPassword == "") {
      SweetAlert.show(
        context,
        title: "Alerta",
        subtitle: "Campos vacios",
        style: SweetAlertStyle.error,
      );
    } else {
      //Api post refresca la informacion enviada desde el backend hacia el login
      http.Response responses = await http
          .get(Uri.parse('$ip/api/refreshingAgentData/${data['agentUser']}'));
      final si = DataAgent.fromJson(json.decode(responses.body));
      //enviamos el id del agente para obtener el id de la cuenta
      print(PushNotificationServices.token);
      Map data2 = {
        'agentId': '${si.agentId}',
        'device': device,
        'deviceId': PushNotificationServices.token.toString()
      };
      http.Response response =
          await http.post(Uri.parse('$ip/api/login'), body: data);
      final no = DataAgents.fromJson(json.decode(response.body));

      //muestra alert y redirección a pantalla de inicio
      if (response.statusCode == 200 &&
          no.ok == true &&
          responses.statusCode == 200) {
        http.Response responseToken = await http.post(
            Uri.parse('$ip/api/registerTokenIdCellPhoneAgent'),
            body: data2);
        final claro = DataToken.fromJson(json.decode(responseToken.body));
        prefs.nombreUsuarioFull = si.agentFullname!;
        prefs.emailUsuario = si.agentEmail!;
        prefs.companyId = si.companyId.toString();
        prefs.passwordUsuario = agentPassword;
        prefs.nombreUsuario = agentUser;
        prefs.tokenAndroid = claro.data[0].token;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false);
        SweetAlert.show(context,
            title: "\nBienvenido(a)",
            subtitle: si.agentFullname,
            style: SweetAlertStyle.success);
      } else if (no.ok != true) {
        SweetAlert.show(
          context,
          title: "\nError",
          subtitle: no.message,
          style: SweetAlertStyle.error,
        );
      }
      return DataAgents.fromJson(json.decode(response.body));
    }
  }

  //funciones y variables que necesitan inicialización
  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.03),
            Text(
              "INGRESA",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 30, color: firstColor),
            ),
            Lottie.asset('assets/videos/Ingresa.json'),
            _crearUsuario(),
            SizedBox(height: 10),
            _crearPassword(),
            RoundedButton(
                color: thirdColor,
                text: "INGRESA ",
                press: () {
                  //Llamada de función fetch login
                  fetchUser(userName.text, userPassword.text);
                }),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
            SizedBox(height: size.height * 0.01),
            ForgotPassword(
              press: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return RestoreScreen();
                }));
              },
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

//Widgets de field usuario y contraseña
  Widget _crearUsuario() {
    return Container(
      margin: EdgeInsets.only(left: 35, right: 35),
      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 50),
      decoration: BoxDecoration(
          border: const GradientBoxBorder(
            gradient: LinearGradient(colors: [Gradiant1, Gradiant2]),
            width: 4,
          ),
          borderRadius: BorderRadius.circular(50)),
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: userName,
        cursorColor: firstColor,
        decoration: InputDecoration(
          icon: Icon(
            Icons.person,
            color: thirdColor,
            size: 30,
          ),
          hintText: "Usuario",
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _crearPassword() {
    return Container(
      margin: EdgeInsets.only(left: 35, right: 35),
      padding: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
      decoration: BoxDecoration(
          border: const GradientBoxBorder(
            gradient: LinearGradient(colors: [Gradiant1, Gradiant2]),
            width: 4,
          ),
          borderRadius: BorderRadius.circular(50)),
      child: TextField(
        style: TextStyle(color: Colors.white),
        //keyboardType: TextInputType.,
        controller: userPassword,
        obscureText: _passwordVisible!,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: "Contraseña",
          hintStyle: TextStyle(color: Colors.white),
          icon: Icon(
            Icons.lock,
            color: thirdColor,
            size: 30,
          ),
          suffixIcon: IconButton(
            padding: EdgeInsets.only(left: 10),
            tooltip: 'Ver contraseña',
            icon: Icon(
              // Based on passwordVisible state choose the icon
              _passwordVisible ?? false
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: thirdColor,
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
    );
  }
}
