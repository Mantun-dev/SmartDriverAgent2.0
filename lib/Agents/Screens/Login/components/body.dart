// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/Screens/Restore/restore_screen.dart';
import 'package:flutter_auth/Agents/Screens/Signup/signup_screen.dart';
import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/dataAgentMessage.dart';
import 'package:flutter_auth/Agents/models/tokenCloseSession.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/Agents/sharePrefers/services.dart';
import 'package:flutter_auth/components/already_have_an_account_acheck.dart';
import 'package:flutter_auth/components/forgot_password.dart';
import 'package:quickalert/quickalert.dart';
import '../../../../constants.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import '../../Welcome/welcome_screen.dart';

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
    if (agentUser == "" || agentPassword == "") {
      QuickAlert.show(
        context: context,
          title: "Alerta",
          text: "Campos vacios",
          type: QuickAlertType.error);
    } else {
      //Api post refresca la informacion enviada desde el backend hacia el login
      http.Response responses = await http
          .get(Uri.parse('$ip/api/refreshingAgentData/${data['agentUser']}'));
      final si = DataAgent.fromJson(json.decode(responses.body));
      //enviamos el id del agente para obtener el id de la cuenta
      //print(PushNotificationServices.token);
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
        prefs.tokenAndroid = claro.data![0].token!;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
            (Route<dynamic> route) => false);
             QuickAlert.show(
        context: context,
          title: "\nBienvenido(a)",
          text: si.agentFullname,
          type: QuickAlertType.success);
      } else if (no.ok != true) {
        QuickAlert.show(
        context: context,
          title: "\nError",
          text: no.message,
          type: QuickAlertType.error);
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
    return Container(
      height: size.height,
      child: Stack(

        children: [

          Positioned(
            top: 20,
            child: Container(
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
                            transitionDuration: Duration(milliseconds: 500 ), // Adjust the animation duration as needed
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
                            color: Colors.white,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.white,
                          size:30
                        ),
                      ),
                    ),
                  ),
  
                  Center(child: Text("Iniciar sesión",style: TextStyle(color: Colors.white,fontSize: 22),)),
                ],
              ),
            ),
          ),


          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: size.width,
                  margin: EdgeInsets.only(left: 40, right: 40),
                  child: Stack(
                    children: [
                      Column(children: [
                      SizedBox(height: 10),
                      _crearUsuario(size),
                      SizedBox(height: 10),
                      _crearPassword(),
                      SizedBox(height: 20),
                      ]),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Column(
                          children: [
                            ForgotPassword(
                              press: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return RestoreScreen();
                                }));
                              },
                            ),
                          ],
                        ),
                      ),
                    ]
                  ),
                ),
                SizedBox(height: 15),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.white),
                  fixedSize: Size(size.width-80, 50)
                  ),
                  onPressed: () {
                    fetchUser(userName.text, userPassword.text);
                  },
                  child: Text(
                    "Ingresar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                ),
                SizedBox(height: 15),
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
            
              ],
            ),
          ),

          Positioned(
            bottom: 10,
            child: Text('')
          )
        ],
      ),
    );
  }

//Widgets de field usuario y contraseña
  Widget _crearUsuario(size) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: TextField(
            style: TextStyle(color: Colors.white),
            controller: userName,
            cursorColor: firstColor,
            decoration: InputDecoration(
              icon: Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 30,
              ),
              hintText: "Usuario",
              hintStyle: TextStyle(color: Colors.white),
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

  Widget _crearPassword() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10),
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
                Icons.lock_outline,
                color: Colors.white,
                size: 30,
              ),
              suffixIcon: IconButton(
                padding: EdgeInsets.only(left: 10),
                tooltip: 'Ver contraseña',
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible ?? false
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.white,
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
    );
  }
}
