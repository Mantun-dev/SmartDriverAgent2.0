import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/network.dart';
//import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/profileAgent.dart';
//import 'package:flutter_auth/Agents/models/profileAgent.dart';
//import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/components/AppBarSuperior.dart';
import 'package:flutter_auth/components/backgroundB.dart';
import '../../../components/AppBarPosterior.dart';

void main() {
  runApp(NotificationPage());
}

class NotificationPage extends StatefulWidget {
  //instancias de plantilla y perfil con sus variabless

  @override
  _NotificationPage createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationPage> {
  //variables
  Future<Profile>? item;
  Future<DataAgent>? itemx;

  @override
  void initState() {
    super.initState();
    itemx = fetchRefres();
    //indexar variable a fetch
    item = fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundBody(
      child: Scaffold(
        backgroundColor: Colors.transparent,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(56),
                  child: AppBarSuperior(item: 8)
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: body(),
                    ),
                    AppBarPosterior(item:2),
                  ],
                ),
              ),
    );
  }

  Widget body(){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all( 
            color: Color.fromRGBO(238, 238, 238, 1),
            width: 2
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),

        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hoy',
                  style: TextStyle(
                    color: Color.fromRGBO(40, 93, 169, 1),
                    fontSize: 15
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),

                Text(
                  'Tiene 1 viaje(s) donde confirmó y no salió a tomar el transporte. Si esto ocurre por tercera vez, el sistema le dará de baja y no será agendado para el servicio de transporte. Deberá comunicarse con su supervisor.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 5),

                Text(
                  '11:02 AM',
                  style: TextStyle(
                    color: Color.fromRGBO(158, 158, 158, 1),
                    fontSize: 12
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20),

                //---------------------------------------------
                Text(
                  'Ayer',
                  style: TextStyle(
                    color: Color.fromRGBO(40, 93, 169, 1),
                    fontSize: 15
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),

                Text(
                  'Has agregado un nuevo viaje.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 5),

                Text(
                  '17:30 PM',
                  style: TextStyle(
                    color: Color.fromRGBO(158, 158, 158, 1),
                    fontSize: 12
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 20),
                
              ],
            ),
          ),
        ),
        
      ),
    );
  }
}
