import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/details_screen.dart';
//import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/Screens/Profile/profile_screen.dart';
import 'package:flutter_auth/Agents/Screens/Welcome/welcome_screen.dart';

import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/Agents/models/profileAgent.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:sweetalert/sweetalert.dart';

//import 'package:flutter_auth/Drivers/Screens/HomeDriver/homeScreen_Driver.dart';


class MenuLateral extends StatefulWidget {
  final Profile item;
  const MenuLateral({Key key, this.item}) : super(key: key);

  @override
  _MenuLateralState createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {

  Future<Profile> item;
  final prefs = new PreferenciasUsuario();

  TextEditingController nameUser = new TextEditingController();
  

  @override  
  void initState() {  
    super.initState();  
    item = fetchProfile();
    nameUser = new TextEditingController( text: prefs.nombreUsuario );  
  } 

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName:Text('${prefs.nombreUsuarioFull}'),
            accountEmail: Text('${prefs.emailUsuario}'),                    
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('assets/images/fondos.jpg'),
                    fit: BoxFit.cover)),
          ),
          ListTile(
            title: Text('Mi perfil'),
            leading: Icon(Icons.account_circle),
            onTap: () {              
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ProfilePage();
              }));
              fetchProfile();
            },
           
          ),
          Divider(),
          ListTile(
            title: Text('Mis proximos viajes'),
            leading: Icon(Icons.airport_shuttle),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetailScreen(plantilla: plantilla[0]);
              }));
            },
          ),
          Divider(),
          ListTile(
            title: Text('Historial de viajes'),
            leading: Icon(Icons.history),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetailScreen(plantilla: plantilla[1]);
              }));
            },
          ),
          Divider(),
          ListTile(
            title: Text('Solicitud de cambios'),
            leading: Icon(Icons.outbox),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetailScreen(plantilla: plantilla[3]);
              }));
              
            },
          ),
          Divider(),
          ListTile(
            title: Text('Generar codigo qr'),
            leading: Icon(Icons.qr_code),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DetailScreen(plantilla: plantilla[2]);
              }));
            },
          ),
          Divider(),
          ListTile(
            title: Text('Cerrar sesión'),
            leading: Icon(Icons.logout),
            onTap: () {  
              SweetAlert.show(context,
                subtitle: "Está seguro que desea salir?",
                style: SweetAlertStyle.confirm,
                showCancelButton: true, onPress: (bool isConfirm) {
                if(isConfirm){                
                  fetchDeleteSession();  
                  prefs.remove();                   
                  SweetAlert.show(context,subtitle: "¡Gracias por usar Smart Driver!", style: SweetAlertStyle.success);
                  new Future.delayed(new Duration(seconds: 2),(){
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context)=>
                  WelcomeScreen()), (Route<dynamic> route) => false);
                  });
                  
                }else{
                  SweetAlert.show(context,subtitle: "¡Canceledo!", style: SweetAlertStyle.success);
                }
                // return false to keep dialog
                return false;
               });  
              
              //Navigator.push( context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
            },
          ),
          Divider(),
        ],
      ),
    );
  }

}
