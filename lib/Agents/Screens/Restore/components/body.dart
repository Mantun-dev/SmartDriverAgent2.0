import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Login/login_screen.dart';
import 'package:flutter_auth/Agents/Screens/Restore/components/background.dart';
import 'package:flutter_auth/Agents/models/register.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/components/rounded_button.dart';
import 'package:flutter_auth/components/text_field_container.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;
import 'package:sweetalert/sweetalert.dart';
import '../../../../constants.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  //variables globales para restablecer contraseña
    final prefs = new PreferenciasUsuario();
    TextEditingController user = new TextEditingController();
    String ip = "https://smtdriver.com";
    @override
    void initState() {
      super.initState();
      user = new TextEditingController( text: prefs.nombreUsuario );
    }

//función fetch para restore pass
  Future<dynamic>fetchUserResetPass(String agentUser) async {
    //<List<Map<String,Register>>>
    Map data = {
      'agentUser' : agentUser
    };
    
    //api restore
    http.Response responses = await http.post(Uri.encodeFull('$ip/api/reset'), body: data);
    final no = Register.fromJson(json.decode(responses.body));
    //alertas y redirecciones
    print(responses.body);
     if (responses.statusCode == 200 && no.ok == true) {          
        setState(() {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>
            LoginScreen()), (Route<dynamic> route) => false);
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                "REESTABLECER CONTRASEÑA",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: SvgPicture.asset(
                "assets/icons/driver.svg",
                height: size.height * 0.50,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 2.0),
              child: Center(
                child: Text(
                  'Escribe tu nombre de usuario, se enviará un enlace al correo para reestablecer tu contraseña',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: (18.0)),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: _crearUsuario(),
            ),
            RoundedButton(
                text: 'Enviar',
                press: () {
                  fetchUserResetPass(user.text);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return SecondRestoreScreen();
                  // }));
                }),
          ],
        ),
      ),
    );
  }

//Widgets fields
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

    ),
    );
  }
}
