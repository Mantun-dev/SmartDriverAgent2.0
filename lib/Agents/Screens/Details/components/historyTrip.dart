import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/models/historyTrips.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_auth/Agents/models/network.dart';

class HistoryTripScreen extends StatefulWidget {
  //declaración de clase Story y su variable
  final Story? item;
  const HistoryTripScreen({Key? key, this.item}) : super(key: key);

  @override
  _HistoryTripScreenState createState() => _HistoryTripScreenState();
}

class _HistoryTripScreenState extends State<HistoryTripScreen> {
  //declaración de variables globales
  final prefs = new PreferenciasUsuario();
  Future<List<Story>>? item;
  final format = DateFormat("HH:mm");

  @override
  void initState() {
    super.initState();
    item = fetchTripsStory();
    //inicializador del botón de android para manejarlo manual
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    //creación del dispose para removerlo después del evento
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

//creación de función booleana para el evento del boton back android
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    //print("BACK BUTTON!"); // Do some stuff.
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
        (Route<dynamic> route) => false);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    //future builder de Story trip
    return FutureBuilder<List<Story>>(
      future: item,
      builder: (BuildContext context, abc) {
        if (abc.connectionState == ConnectionState.done) {
          //validación arreglo vacio
          if (abc.data!.length == 0) {
            return Column(
              children: [
                SizedBox(height: 5),
                 Text('Agentes',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 20, fontWeight: FontWeight.normal)),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'No hay viajes realizados',
                
                    style:  Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                  ),
                ),
                Container(
                  height: 1,
                  color: Theme.of(context).dividerColor,
                ),
              ],
            );
          } else {
            //retorno de ListView builder
            return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            //tamaño del arreglo por parte del future builder
            itemCount: abc.data!.length,
            itemBuilder: (context, index) {
              //retorno de card con datos ingresados
              return Padding(
                padding: const EdgeInsets.only(top:10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Theme.of(context).dividerColor,),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2, left: 2),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.only(right: 0, left: 0),
                      title: Column(
                        children: [
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(right: 5, left: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 15,
                                  height: 15,
                                  child: SvgPicture.asset(
                                    "assets/icons/Numeral.svg",
                                    color: Theme.of(context).primaryIconTheme.color,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                        TextSpan(
                                          text: 'Viaje: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${abc.data![index].tripId}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          Container(
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),    
                          SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(right: 5, left: 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  child: SvgPicture.asset(
                                    "assets/icons/calendar2.svg",
                                    color: Theme.of(context).primaryIconTheme.color,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                        TextSpan(
                                          text: 'Fecha: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),
                                        ),
                                        TextSpan(
                                          text: '${abc.data![index].fecha}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      children: [
                        Container(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),    
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                child: SvgPicture.asset(
                                  "assets/icons/warning-circle-svgrepo-com.svg",
                                  color: Theme.of(context).primaryIconTheme.color,
                                ),
                              ),
                              SizedBox(width: 5),
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: [
                                      TextSpan(
                                        text: 'Transporte para: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${abc.data![index].tipo}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                                                                        
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                child: SvgPicture.asset(
                                  "assets/icons/hora.svg",
                                  color: Theme.of(context).primaryIconTheme.color,
                                ),
                              ),
                              SizedBox(width: 5),
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: [
                                      TextSpan(
                                        text: 'Hora de encuentro: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text:abc.data![index].hora==null?'--':'${abc.data![index].hora}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          color: Colors.green
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),

                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                child: SvgPicture.asset(
                                  "assets/icons/warning-circle-svgrepo-com.svg",
                                  color: Theme.of(context).primaryIconTheme.color,
                                ),
                              ),
                              SizedBox(width: 5),
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: [
                                      TextSpan(
                                        text: 'Viajó: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text:abc.data![index].abordo==null?'No':'Si',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                          color: abc.data![index].abordo==null? Colors.red : Colors.green
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                                                                                    
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                child: SvgPicture.asset(
                                  "assets/icons/Casa.svg",
                                  color: Theme.of(context).primaryIconTheme.color,
                                ),
                              ),
                              SizedBox(width: 5),
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: [
                                      TextSpan(
                                        text: 'Dirección: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${abc.data![index].direccion}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),

                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 5, left: 10, bottom: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                child: SvgPicture.asset(
                                  "assets/icons/motorista.svg",
                                  color: Theme.of(context).primaryIconTheme.color,
                                ),
                              ),
                              SizedBox(width: 5),
                              Flexible(
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: [
                                      TextSpan(
                                        text: 'Conductor: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${abc.data![index].conductor}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                                                                    
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              );
            });
          }
        } else {
          return WillPopScope(
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
                                  'Cargando..', 
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 18),
                                  ),
                              )
                            ],
                          ),
                        )
                      ] ,
                    ),
                  );
        }
      },
    );
  }
}
