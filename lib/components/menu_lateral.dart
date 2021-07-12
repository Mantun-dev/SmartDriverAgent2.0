import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/details_screen.dart';
//import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/Screens/Profile/profile_screen.dart';
import 'package:flutter_auth/Agents/Screens/Welcome/welcome_screen.dart';
import 'package:flutter_auth/Agents/models/dataAgent.dart';

import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/Agents/models/profileAgent.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/constants.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:flutter_auth/Drivers/Screens/HomeDriver/homeScreen_Driver.dart';


class MenuLateral extends StatefulWidget {
  final Profile item;
  final DataAgent itemx;
  const MenuLateral({Key key, this.item, this.itemx}) : super(key: key);

  @override
  _MenuLateralState createState() => _MenuLateralState();
}

class _MenuLateralState extends State<MenuLateral> {

  Future<Profile> item;
  Future<DataAgent> itemx;
  final prefs = new PreferenciasUsuario();

  TextEditingController nameUser = new TextEditingController();
  

  @override  
  void initState() {  
    super.initState();  
    item = fetchProfile();
    itemx = fetchRefres();
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
          if (prefs.companyId == "1")... {
            Container(
              child: Column(children: [
                Divider(),
                ListTile(
                 title: Text('información'),
                 leading: Icon(Icons.inbox),
                 onTap: () {
                 _showBottomModal(context);
                 },
                )
              ],),
            )
          },                   
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

  _showBottomModal(context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return new Container(
          // height: 800,
          color: Colors.transparent,
          child: new Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                topRight: const Radius.circular(10.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 0.0, // has the effect of extending the shadow
                )
              ],
            ),
            alignment: Alignment.topLeft,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 5, left: 10),
                      child: Text(
                        "Información",
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: kCardColor2,),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5, right: 5),
                      child: TextButton(
                        style: ButtonStyle(),                      
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Cerrar",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff999999),
                          ),
                        ),
                      )
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: const Color(0xfff8f8f8),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        margin: EdgeInsets.only(left: 8),
                        child: Column(
                          children: [
                            Text("Plazos de confirmación",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: kCardColor2,)),
                            SizedBox(height: 5),
                            Text('Horario de 5:00 am a 12:00 pm hora máxima de confirmación 8:30 pm',style: TextStyle(color: kgray)),
                            SizedBox(height: 15),
                            Text('Horario de 2:00 pm a 5:00 pm hora máxima de confirmación 10:00 am',style: TextStyle(color: kgray)), 
                            SizedBox(height: 30,),
                            Text("Nota",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: kCardColor2,)),                        
                          ],
                        ),
                      ),
                      TextButton(onPressed: () => launch('tel://3317-4537'),child: Text('Si tiene algún inconveniente con su programación, puede escribir al número: 3317-4537',style: TextStyle(color: Colors.grey[700]))),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
  }
}


