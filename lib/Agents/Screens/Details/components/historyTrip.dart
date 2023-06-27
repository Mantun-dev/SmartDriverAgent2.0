import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/loader.dart';
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
                  style: TextStyle(
                      color: Color.fromRGBO(40, 93, 169, 1),
                      fontWeight: FontWeight.normal,
                      fontSize: 20.0)),
                SizedBox(height: 10),
                Center(
                  child: Text(
                    'No hay viajes realizados',
                
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  height: 1,
                  color: Color.fromRGBO(158, 158, 158, 1),
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
                borderRadius: BorderRadius.circular(8.0), // Establece un radio de esquinas redondeadas de 8.0
                border: Border.all(color: Color.fromRGBO(196, 196, 196, 1)), // Establece el color del borde
              ),
              child: Padding(
                padding: const EdgeInsets.only(right: 2, left: 2),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.only(right: 5, left: 10),
                            title: Column(
                              children: [
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      width: 15,
                                      height: 15,
                                      child: SvgPicture.asset(
                                        "assets/icons/Numeral.svg",
                                        color: Color.fromRGBO(40, 93, 169, 1),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        'Viaje: ${abc.data![index].tripId}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Row(
                                  children: [
                                    Container(
                                      width: 18,
                                      height: 18,
                                      child: SvgPicture.asset(
                                        "assets/icons/calendar2.svg",
                                        color: Color.fromRGBO(40, 93, 169, 1),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        'Fecha: ${abc.data![index].fecha}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
  
                                  ],
                                ),
                              ],
                            ),
                  children: [
                    Container(
                      height: 1,
                      color: Color.fromRGBO(196, 196, 196, 1),
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
                              color: Color.fromRGBO(40, 93, 169, 1),
                            ),
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'Transporte para: ${abc.data![index].estado}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Color.fromRGBO(196, 196, 196, 1),
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
                              color: Color.fromRGBO(40, 93, 169, 1),
                            ),
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'Hora de encuentro: ${abc.data![index].hora}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
          
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Color.fromRGBO(196, 196, 196, 1),
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
                              color: Color.fromRGBO(40, 93, 169, 1),
                            ),
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'Dirección: ${abc.data![index].direccion}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Color.fromRGBO(196, 196, 196, 1),
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
                              "assets/icons/motorista.svg",
                              color: Color.fromRGBO(40, 93, 169, 1),
                            ),
                          ),
                          SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'Conductor: ${abc.data![index].conductor}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Color.fromRGBO(196, 196, 196, 1),
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
          return ColorLoader3();
        }
      },
    );
  }
}
