
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
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sweetalert/sweetalert.dart';
import '../../../../constants.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' show json;




class Body extends StatefulWidget {
  const Body({
    Key key,
  }) : super(key: key);


  @override
  _BodyState createState() => _BodyState();

}

class _BodyState extends State<Body> {

  //Declaración de variables globales 
  TextEditingController userPassword = new TextEditingController();
  TextEditingController userName = new TextEditingController();
  String agentId = ''; 
  String countId = '';
  final prefs = new PreferenciasUsuario();
  String ip = "https://smtdriver.com";
  bool _passwordVisible;



  //función fetch para logueo de usuario agente
  Future<dynamic>fetchUser(String agentUser, String agentPassword) async {
    Map data = {
      'agentUser' : agentUser,
      'agentPassword' : agentPassword
    };
    String device = "mobile";
    if (agentUser == ""&& agentPassword == "") {
        SweetAlert.show(context,
          title: "Alerta",
          subtitle: "Campos vacios",
          style: SweetAlertStyle.error,
        );
      }else{
        //Api post refresh data and login    
        http.Response responses = await http.get(Uri.encodeFull('$ip/api/refreshingAgentData/${data['agentUser']}'));
        final si = DataAgent.fromJson(json.decode(responses.body));
        prefs.nombreUsuarioFull = si.agentFullname; 
        prefs.emailUsuario = si.agentEmail;
        prefs.companyId = si.companyId.toString();
        print(PushNotificationServices.token);
        Map data2 = {
          'agentId' : '${si.agentId}',
          'device' : device,
          'deviceId': PushNotificationServices.token.toString()
        };
        http.Response response = await http.post(Uri.encodeFull('$ip/api/login'), body: data);
        final no = DataAgents.fromJson(json.decode(response.body));

        //muestra alert y redirección a HomeScreen 
        if (response.statusCode == 200 && no.ok == true && responses.statusCode == 200) {          
          http.Response responseToken = await http.post(Uri.encodeFull('$ip/api/registerTokenIdCellPhoneAgent'), body: data2);
          final claro = DataToken.fromJson(json.decode(responseToken.body));           
          prefs.tokenAndroid = claro.data[0].token;
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>
          HomeScreen()), (Route<dynamic> route) => false);
          SweetAlert.show(context,
            title: "Bienvenido(a)",
            subtitle: si.agentFullname,
            style: SweetAlertStyle.success
          );
          } else if (no.ok != true) {
            SweetAlert.show(context,
              title: "Alerta",
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
    userName = new TextEditingController( text: prefs.nombreUsuario );
    userPassword = new TextEditingController(text: prefs.passwordUsuario);
    _passwordVisible = false;
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
          child: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "INGRESA",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/login.svg",
                height: size.height * 0.48,
              ),
              SizedBox(height: size.height * 0.01),
              _crearUsuario(),
              _crearPassword(),
              RoundedButton(
                text: "INGRESA ",
                press:() {   
                  //Llamada de función fetch login                                              
                  fetchUser(userName.text, userPassword.text);  
                }
              ),
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
              )
            ],
          ),
        ),
      ),
    );
  }


//Widgets de field usuario y contraseña
  Widget _crearUsuario(){
    return TextFieldContainer(
      child: TextField(
        controller: userName,
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

  Widget _crearPassword(){
    return TextFieldContainer(
     child: TextField(
      controller: userPassword,
      obscureText: !_passwordVisible,
      onChanged: (value){
        prefs.passwordUsuario = value;
      },
      cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Contraseña",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
              icon: Icon(
                // Based on passwordVisible state choose the icon
                _passwordVisible
                ? Icons.visibility
                : Icons.visibility_off,
                color: kPrimaryColor,
                ),
              onPressed: () {
                // Update the state i.e. toogle the state of passwordVisible variable
                setState(() {
                    _passwordVisible = !_passwordVisible;
                });
              },
              ),
          border: InputBorder.none,
        ),
      ),
    
    );
    
  }

}
