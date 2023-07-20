import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/models/network.dart';
//import 'package:flutter_auth/Agents/models/dataAgent.dart';
//import 'package:flutter_auth/Agents/models/profileAgent.dart';
//import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/components/AppBarSuperior.dart';
import 'package:flutter_auth/components/backgroundB.dart';
import 'package:intl/intl.dart';
import '../../../components/AppBarPosterior.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

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
  var listaNotificaciones;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async{
    http.Response response2 = await http.get(Uri.parse('https://smtdriver.com/api/getAgentNotifications/${prefs.usuarioId}'));
    var resp2 = json.decode(response2.body);
    print(response2.body);
    if(resp2['ok']==true){
      setState(() {
        listaNotificaciones=resp2['agentNotifications'];
      });
    }
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
                    SafeArea(child: AppBarPosterior(item:2)),
                  ],
                ),
              ),
    );
  }

  String getFecha(String dataFecha) {
    DateTime dateTime = DateTime.parse(dataFecha);
    DateTime now = DateTime.now();
    DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

    String formattedDate;

    if (dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day) {
      formattedDate = 'Hoy';
    } else if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      formattedDate = 'Ayer';
    } else {
      formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
    }

    return formattedDate;
  }

  String getHora(String dataFecha) {
    DateTime dateTime = DateTime.parse(dataFecha);
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return formattedTime;
  }

  Widget body(){
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          border: Border.all( 
            color: Theme.of(context).disabledColor,
            width: 2
          ),
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20)
        ),

        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: listaNotificaciones != null ?
            listaNotificaciones.length <=0 
              ? Center(
                child: Column(
                  children: [
                    Text("No hay notificaciones pendientes",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 17)
                    ),
                    Container(
                      height: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                  ],
                ),
              ):
            SingleChildScrollView(
              child: ListView.builder(
                itemCount: listaNotificaciones.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getFecha(listaNotificaciones[index]['notificationCreated']),
                        style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 15),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 10),
            
                      Text(
                        '${listaNotificaciones[index]['notificationDescription']}',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 15),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 5),
            
                      Text(
                        getHora(listaNotificaciones[index]['notificationCreated']),
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 12),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 20),
                      
                    ],
                  );
                },
              ),
            ):WillPopScope(
                    onWillPop: () async => false,
                    child: SimpleDialog(
                       elevation: 20,
                      backgroundColor: Theme.of(context).cardColor,
                      children: [
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 16, top: 16, right: 16),
                                child: CircularProgressIndicator(),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'Cargando...', 
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                  ),
                              )
                            ],
                          ),
                        )
                      ] ,
                    ),
                  ),
        ),
        
      ),
    );
  }
}
