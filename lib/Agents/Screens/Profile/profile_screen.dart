import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/loader.dart';
import 'package:flutter_auth/Agents/Screens/Details/details_screen.dart';
import 'package:flutter_auth/Agents/Screens/HomeAgents/homeScreen_Agents.dart';
import 'package:flutter_auth/Agents/Screens/Signup/components/background.dart';
import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/network.dart';
//import 'package:flutter_auth/Agents/models/dataAgent.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/Agents/models/profileAgent.dart';
//import 'package:flutter_auth/Agents/models/profileAgent.dart';
//import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:flutter_auth/components/menu_lateral.dart';
import 'package:flutter_auth/components/solictud_cambio.dart';
import '../../../constants.dart';


void main() {
  runApp(ProfilePage());
}

class ProfilePage extends StatefulWidget {
  //instancias de plantilla y perfil con sus variabless
  final Plantilla plantilla;
  final Profile item;
  final Profile itemx;
  const ProfilePage({Key key, this.plantilla, this.item, this.itemx}) : super(key: key);
  @override
  _DataTableExample createState() => _DataTableExample();
}

class _DataTableExample extends State<ProfilePage> {

  //variables
  Future<Profile> item;
  Future<DataAgent> itemx;

  @override  
  void initState() {  
    super.initState();
    itemx = fetchRefres();  
    //indexar variable a fetch
    item = fetchProfile();  
  }  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          drawer: MenuLateral(),
          appBar: AppBar(backgroundColor: kColorAppBar,elevation: 0,
            title: Center(
              child: Text('Información General'),
            ),
            iconTheme: IconThemeData(color: Colors.white),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return HomeScreen();
                  }));
                },
              ),
              SizedBox(width: kDefaultPadding / 2)
            ],                      
          ),
          body: Background(
            child: ListView(children: <Widget>[
              SizedBox(height: 20.0),
              //future builder para Profile
              FutureBuilder<Profile>(
                future: item,
                builder: (BuildContext context, abc) {
                  if (abc.connectionState == ConnectionState.done) {
                    //ingreso de data
                    return SingleChildScrollView(
                      child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),margin: EdgeInsets.all(15),elevation: 10,
                        child: Container(decoration: BoxDecoration(shape: BoxShape.rectangle,borderRadius: BorderRadius.circular(10)),margin: EdgeInsets.symmetric(horizontal: 15.0),width: 500,height: 460,
                          child: DataTable(columns: [
                            DataColumn(label: Text('Datos',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: kCardColor2,))),
                          ], rows: [
                            if (prefs.companyId == "8")... {
                              if (abc.data == null )... {
                                DataRow(cells: [
                                DataCell(Text('No. empleado: ',style: TextStyle(color: kgray))),
                              ]),                                                          
                              DataRow(cells: [
                                DataCell(Text('Usuario: ',style: TextStyle(color: kgray)))    
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Nombre: ',style: TextStyle(color: kgray)))
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Teléfono: ',style: TextStyle(color: kgray)))
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Email: ',style: TextStyle(color: kgray)))
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Dirección:',style: TextStyle(color: kgray)))
                              ]),
                              
                                DataRow(cells: [
                                DataCell(Text('Acceso autorizado: ',style: TextStyle(color: kgray)))
                              ]),
                            } else... {
                              DataRow(cells: [
                                DataCell(Text('No. empleado: ${abc.data.agentUser}',style: TextStyle(color: kgray))),
                              ]),
                              
                              DataRow(cells: [
                                DataCell(Text('Usuario: ${abc.data.agentUser}',style: TextStyle(color: kgray)))    
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Nombre: ${abc.data.agentFullname}',style: TextStyle(color: kgray)))
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Teléfono: ${abc.data.agentPhone}',style: TextStyle(color: kgray)))
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Email: ${abc.data.agentEmail}',style: TextStyle(color: kgray)))
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Dirección: ${abc.data.agentReferencePoint}, ${abc.data.neighborhoodName}, \n${abc.data.townName}',style: TextStyle(color: kgray)))
                              ]),
                              if (abc.data.neighborhoodReferencePoint == null)... {
                                
                              } else... {
                                DataRow(cells: [
                                DataCell(Text('Acceso autorizado: ${abc.data.neighborhoodReferencePoint}',style: TextStyle(color: kgray)))
                              ]),
                              }
                            },
                            } else... {
                            if (abc.data == null )... {
                                DataRow(cells: [
                                DataCell(Text('No. empleado: ',style: TextStyle(color: kgray))),
                              ]),                              
                              DataRow(cells: [
                                DataCell(Text('Cuenta: ',style: TextStyle(color: kgray)))    
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Usuario: ',style: TextStyle(color: kgray)))    
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Nombre: ',style: TextStyle(color: kgray)))
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Teléfono: ',style: TextStyle(color: kgray)))
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Email: ',style: TextStyle(color: kgray)))
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Dirección:',style: TextStyle(color: kgray)))
                              ]),
                              
                                DataRow(cells: [
                                DataCell(Text('Acceso autorizado: ',style: TextStyle(color: kgray)))
                              ]),
                            } else... {
                              DataRow(cells: [
                                DataCell(Text('No. empleado: ${abc.data.agentUser}',style: TextStyle(color: kgray))),
                              ]),
                              if (abc.data.countName == null)... {                              
                                DataRow(cells: [
                                  DataCell(Text('Cuenta: ',style: TextStyle(color: kgray)))    
                                ]),
                              }else...{
                                DataRow(cells: [
                                  DataCell(Text('Cuenta: ${abc.data.countName}',style: TextStyle(color: kgray)))    
                                ]),
                              },
                              DataRow(cells: [
                                DataCell(Text('Usuario: ${abc.data.agentUser}',style: TextStyle(color: kgray)))    
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Nombre: ${abc.data.agentFullname}',style: TextStyle(color: kgray)))
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Teléfono: ${abc.data.agentPhone}',style: TextStyle(color: kgray)))
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Email: ${abc.data.agentEmail}',style: TextStyle(color: kgray)))
                              ]),
                              DataRow(cells: [
                                DataCell(Text('Dirección: ${abc.data.agentReferencePoint}, ${abc.data.neighborhoodName}, \n${abc.data.townName}',style: TextStyle(color: kgray)))
                              ]),
                              if (abc.data.neighborhoodReferencePoint == null)... {
                                
                              } else... {
                                DataRow(cells: [
                                DataCell(Text('Acceso autorizado: ${abc.data.neighborhoodReferencePoint}',style: TextStyle(color: kgray)))
                              ]),
                              }
                            },
                            },
                          ]),
                        ),
                      ),
                    );
                  } else {
                    return ColorLoader3();
                  }
                },
              ),
              SizedBox(height: 30.0),
              Center(child: Text('Horario laboral',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: kCardColor2),)),
              //ingreso de data por el future builder horario
              FutureBuilder<Profile>(
                future: item,
                builder: (BuildContext context, abc) {
                  if (abc.connectionState == ConnectionState.done) {
                    //data
                    return SingleChildScrollView(
                      child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),margin: EdgeInsets.all(15),elevation: 10,
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.rectangle,borderRadius: BorderRadius.circular(10)),margin: EdgeInsets.symmetric(horizontal: 5.0),width: 550,height: 400,
                          child: Column(
                            children: [
                              if (prefs.companyId == "8")... {
                                DataTable(
                                columns: [
                                  DataColumn(label: Text('Día',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: kPrimaryColor))),
                                  
                                  DataColumn(label: Text('Salida',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: kPrimaryColor))),
                                ],
                                rows: [
                                  if (abc.data == null)... {
                                      DataRow(cells: [
                                    DataCell(Text('Lunes', style: TextStyle(color: kgray))),
                                    
                                  DataCell(Text('')
                                  )
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Martes', style: TextStyle(color: kgray))),
                                   
                                    DataCell(Text('')
                                    )
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Miercoles',style: TextStyle(color: kgray))),
                                    
                                    DataCell(Text('')
                                    )
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Jueves', style: TextStyle(color: kgray))),
                                    
                                    DataCell(Text('')
                                    )
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Viernes', style: TextStyle(color: kgray))),
                                    
                                    DataCell(Text('')
                                    )
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Sábado', style: TextStyle(color: kgray))),
                                    
                                    DataCell(Text('')
                                    )
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Domingo', style: TextStyle(color: kgray))),
                                    
                                    DataCell(Text('')
                                    )
                                  ]),
                                    } else... {
                                      DataRow(cells: [
                                        DataCell(Text('Lunes', style: TextStyle(color: kgray))),
                                        
                                      DataCell(
                                        FutureBuilder<Profile>(
                                          future: item,
                                          builder: (context, abc){
                                              if (abc.connectionState == ConnectionState.done) {
                                                if ('${abc.data.mondayOut}' == 'null') {
                                                return Text('Día libre'); 
                                                }else if(abc.hasData){
                                                  return Text('${abc.data.mondayOut}',style: TextStyle(color: kgray));
                                                }
                                              }
                                              else {
                                                return CircularProgressIndicator();
                                              }
                                              return CircularProgressIndicator(); 
                                          }
                                        )
                                      )
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Martes', style: TextStyle(color: kgray))),
                                      
                                        DataCell(
                                            FutureBuilder<Profile>(
                                              future: item,
                                              builder: (context, abc){
                                                  if (abc.connectionState == ConnectionState.done) {
                                                    if ('${abc.data.tuesdayOut}' == 'null') {
                                                      return Text('Día libre'); 
                                                    }else if(abc.hasData){
                                                      return Text('${abc.data.tuesdayOut}',style: TextStyle(color: kgray));
                                                    }
                                                  }
                                                  else {
                                                    return CircularProgressIndicator();
                                                  }
                                                  return CircularProgressIndicator(); 
                                              }
                                            )
                                        )
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Miercoles',style: TextStyle(color: kgray))),
                                        
                                        DataCell(
                                          FutureBuilder<Profile>(
                                            future: item,
                                            builder: (context, abc){
                                                if (abc.connectionState == ConnectionState.done) {
                                                  if ('${abc.data.wednesdayOut}' == 'null') {
                                                    return Text('Día libre'); 
                                                  }else if(abc.hasData){
                                                    return Text('${abc.data.wednesdayOut}',style: TextStyle(color: kgray));
                                                  }
                                                }
                                                else {
                                                  return CircularProgressIndicator();
                                                }

                                              return CircularProgressIndicator(); 
                                            }
                                          )
                                        )
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Jueves', style: TextStyle(color: kgray))),
                                        
                                        DataCell(
                                          FutureBuilder<Profile>(
                                            future: item,
                                            builder: (context, abc){
                                                if (abc.connectionState == ConnectionState.done) {
                                                  if ('${abc.data.thursdayOut}' == 'null') {
                                                    return Text('Día libre'); 
                                                  }else if(abc.hasData){
                                                    return Text('${abc.data.thursdayOut}',style: TextStyle(color: kgray));
                                                  }
                                                }
                                                else {
                                                  return CircularProgressIndicator();
                                                }
                                              return CircularProgressIndicator(); 
                                            }
                                          )
                                        )
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Viernes', style: TextStyle(color: kgray))),
                                        
                                        DataCell(
                                          FutureBuilder<Profile>(
                                            future: item,
                                            builder: (context, abc){
                                                if (abc.connectionState == ConnectionState.done) {
                                                  if ('${abc.data.fridayOut}' == 'null') {
                                                    return Text('Día libre'); 
                                                  }else if(abc.hasData){
                                                    return Text('${abc.data.fridayOut}',style: TextStyle(color: kgray));
                                                  }
                                                }
                                                else {
                                                  return CircularProgressIndicator();
                                                }
                                              return CircularProgressIndicator(); 
                                            }
                                          )
                                        )
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Sábado', style: TextStyle(color: kgray))),
                                        
                                        DataCell(
                                          FutureBuilder<Profile>(
                                            future: item,
                                            builder: (context, abc){
                                                if (abc.connectionState == ConnectionState.done) {
                                                  if ('${abc.data.saturdayOut}' == 'null') {
                                                    return Text('Día libre'); 
                                                  }else if(abc.hasData){
                                                    return Text('${abc.data.saturdayOut}',style: TextStyle(color: kgray));
                                                  }
                                                }
                                                else {
                                                  return CircularProgressIndicator();
                                                }
                                              return CircularProgressIndicator(); 
                                            }
                                          )
                                        )
                                      ]),
                                      DataRow(cells: [
                                        DataCell(Text('Domingo', style: TextStyle(color: kgray))),
                                        
                                        DataCell(
                                          FutureBuilder<Profile>(
                                            future: item,
                                            builder: (context, abc){
                                                if (abc.connectionState == ConnectionState.done) {
                                                  if ('${abc.data.sundayOut}' == 'null') {
                                                    return Text('Día libre'); 
                                                  }else if(abc.hasData){
                                                    return Text('${abc.data.sundayOut}',style: TextStyle(color: kgray));
                                                  }
                                                }
                                                else {
                                                  return CircularProgressIndicator();
                                                }
                                              return CircularProgressIndicator(); 
                                            }

                                          )
                                        )
                                      ]),
                                    },
                                ],
                              ),
                            
                              }else...{
                              DataTable(
                                columns: [
                                  DataColumn(label: Text('Día',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: kPrimaryColor))),
                                  DataColumn(label: Text('Entrada',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: kPrimaryColor))),
                                  DataColumn(label: Text('Salida',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: kPrimaryColor))),
                                ],
                                rows: [
                                  if (abc.data == null)... {
                                    DataRow(cells: [
                                    DataCell(Text('Lunes', style: TextStyle(color: kgray))),
                                    DataCell(Text('')
                                    ),
                                  DataCell(Text('')
                                  )
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Martes', style: TextStyle(color: kgray))),
                                    DataCell(Text('')
                                    ),
                                    DataCell(Text('')
                                    )
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Miercoles',style: TextStyle(color: kgray))),
                                    DataCell(Text('')
                                    ),
                                    DataCell(Text('')
                                    )
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Jueves', style: TextStyle(color: kgray))),
                                    DataCell(Text('')
                                    ),
                                    DataCell(Text('')
                                    )
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Viernes', style: TextStyle(color: kgray))),
                                    DataCell(Text('')
                                    ),
                                    DataCell(Text('')
                                    )
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Sábado', style: TextStyle(color: kgray))),
                                    DataCell(Text('')
                                    ),
                                    DataCell(Text('')
                                    )
                                  ]),
                                  DataRow(cells: [
                                    DataCell(Text('Domingo', style: TextStyle(color: kgray))),
                                    DataCell(Text('')
                                    ),
                                    DataCell(Text('')
                                    )
                                  ]),
                                  } else... {
                                    DataRow(cells: [
                                      DataCell(Text('Lunes', style: TextStyle(color: kgray))),
                                      DataCell(
                                          FutureBuilder<Profile>(
                                          future: item,
                                          builder: (context, abc){
                                              if (abc.connectionState == ConnectionState.done) {
                                                if ('${abc.data.mondayIn}' == 'null') {
                                                  return Text('Día libre'); 
                                                }else if(abc.hasData){
                                                  return Text('${abc.data.mondayIn}',style: TextStyle(color: kgray));
                                                }
                                              }
                                              else {
                                                return CircularProgressIndicator();
                                              }
                                              return CircularProgressIndicator(); 
                                          }
                                        )
                                      ),
                                    DataCell(
                                      FutureBuilder<Profile>(
                                        future: item,
                                        builder: (context, abc){
                                            if (abc.connectionState == ConnectionState.done) {
                                              if ('${abc.data.mondayOut}' == 'null') {
                                              return Text('Día libre'); 
                                              }else if(abc.hasData){
                                                return Text('${abc.data.mondayOut}',style: TextStyle(color: kgray));
                                              }
                                            }
                                            else {
                                              return CircularProgressIndicator();
                                            }
                                            return CircularProgressIndicator(); 
                                        }
                                      )
                                    )
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Text('Martes', style: TextStyle(color: kgray))),
                                      DataCell(
                                        FutureBuilder<Profile>(
                                          future: item,
                                          builder: (context, abc){
                                              if (abc.connectionState == ConnectionState.done) {
                                                if ('${abc.data.tuesdayIn}' == 'null') {
                                                  return Text('Día libre'); 
                                                }else if(abc.hasData){
                                                  return Text('${abc.data.tuesdayIn}',style: TextStyle(color: kgray));
                                                }
                                              }
                                              else {
                                                return CircularProgressIndicator();
                                              }
                                              return CircularProgressIndicator(); 
                                          }
                                        )
                                      ),
                                      DataCell(
                                          FutureBuilder<Profile>(
                                            future: item,
                                            builder: (context, abc){
                                                if (abc.connectionState == ConnectionState.done) {
                                                  if ('${abc.data.tuesdayOut}' == 'null') {
                                                    return Text('Día libre'); 
                                                  }else if(abc.hasData){
                                                    return Text('${abc.data.tuesdayOut}',style: TextStyle(color: kgray));
                                                  }
                                                }
                                                else {
                                                  return CircularProgressIndicator();
                                                }
                                                return CircularProgressIndicator(); 
                                            }
                                          )
                                      )
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Text('Miercoles',style: TextStyle(color: kgray))),
                                      DataCell(
                                        FutureBuilder<Profile>(
                                          future: item,
                                          builder: (context, abc){
                                              if (abc.connectionState == ConnectionState.done) {
                                                if ('${abc.data.wednesdayIn}' == 'null') {
                                                  return Text('Día libre'); 
                                                }else if(abc.hasData){
                                                  return Text('${abc.data.wednesdayIn}',style: TextStyle(color: kgray));
                                                }
                                              }
                                              else {
                                                return CircularProgressIndicator();
                                              }
                                              return CircularProgressIndicator();
                                          }
                                        )
                                      ),
                                      DataCell(
                                        FutureBuilder<Profile>(
                                          future: item,
                                          builder: (context, abc){
                                              if (abc.connectionState == ConnectionState.done) {
                                                if ('${abc.data.wednesdayOut}' == 'null') {
                                                  return Text('Día libre'); 
                                                }else if(abc.hasData){
                                                  return Text('${abc.data.wednesdayOut}',style: TextStyle(color: kgray));
                                                }
                                              }
                                              else {
                                                return CircularProgressIndicator();
                                              }

                                            return CircularProgressIndicator(); 
                                          }
                                        )
                                      )
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Text('Jueves', style: TextStyle(color: kgray))),
                                      DataCell(
                                        FutureBuilder<Profile>(
                                          future: item,
                                          builder: (context, abc){
                                              if (abc.connectionState == ConnectionState.done) {
                                                if ('${abc.data.thursdayIn}' == 'null') {
                                                  return Text('Día libre'); 
                                                }else if(abc.hasData){
                                                  return Text('${abc.data.thursdayIn}',style: TextStyle(color: kgray));
                                                }
                                              }
                                              else {
                                                return CircularProgressIndicator();
                                              }
                                            return CircularProgressIndicator(); 
                                          }
                                        )
                                      ),
                                      DataCell(
                                        FutureBuilder<Profile>(
                                          future: item,
                                          builder: (context, abc){
                                              if (abc.connectionState == ConnectionState.done) {
                                                if ('${abc.data.thursdayOut}' == 'null') {
                                                  return Text('Día libre'); 
                                                }else if(abc.hasData){
                                                  return Text('${abc.data.thursdayOut}',style: TextStyle(color: kgray));
                                                }
                                              }
                                              else {
                                                return CircularProgressIndicator();
                                              }
                                            return CircularProgressIndicator(); 
                                          }
                                        )
                                      )
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Text('Viernes', style: TextStyle(color: kgray))),
                                      DataCell(
                                        FutureBuilder<Profile>(
                                          future: item,
                                          builder: (context, abc){
                                              if (abc.connectionState == ConnectionState.done) {
                                                if ('${abc.data.fridayIn}' == 'null') {
                                                  return Text('Día libre'); 
                                                }else if(abc.hasData){
                                                  return Text('${abc.data.fridayIn}',style: TextStyle(color: kgray));
                                                }
                                              }
                                              else {
                                                return CircularProgressIndicator();
                                              }
                                            return CircularProgressIndicator(); 
                                          }
                                        )
                                      ),
                                      DataCell(
                                        FutureBuilder<Profile>(
                                          future: item,
                                          builder: (context, abc){
                                              if (abc.connectionState == ConnectionState.done) {
                                                if ('${abc.data.fridayOut}' == 'null') {
                                                  return Text('Día libre'); 
                                                }else if(abc.hasData){
                                                  return Text('${abc.data.fridayOut}',style: TextStyle(color: kgray));
                                                }
                                              }
                                              else {
                                                return CircularProgressIndicator();
                                              }
                                            return CircularProgressIndicator(); 
                                          }
                                        )
                                      )
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Text('Sábado', style: TextStyle(color: kgray))),
                                      DataCell(
                                        FutureBuilder<Profile>(
                                          future: item,
                                          builder: (context, abc){
                                              if (abc.connectionState == ConnectionState.done) {
                                                if ('${abc.data.saturdayIn}' == 'null') {
                                                  return Text('Día libre'); 
                                                }else if(abc.hasData){
                                                  return Text('${abc.data.saturdayIn}',style: TextStyle(color: kgray));
                                                }
                                              }
                                              else {
                                                return CircularProgressIndicator();
                                              }
                                            return CircularProgressIndicator(); 
                                          }
                                        )
                                      ),
                                      DataCell(
                                        FutureBuilder<Profile>(
                                          future: item,
                                          builder: (context, abc){
                                              if (abc.connectionState == ConnectionState.done) {
                                                if ('${abc.data.saturdayOut}' == 'null') {
                                                  return Text('Día libre'); 
                                                }else if(abc.hasData){
                                                  return Text('${abc.data.saturdayOut}',style: TextStyle(color: kgray));
                                                }
                                              }
                                              else {
                                                return CircularProgressIndicator();
                                              }
                                            return CircularProgressIndicator(); 
                                          }
                                        )
                                      )
                                    ]),
                                    DataRow(cells: [
                                      DataCell(Text('Domingo', style: TextStyle(color: kgray))),
                                      DataCell(
                                        FutureBuilder<Profile>(
                                          future: item,
                                          builder: (context, abc){  
                                              if (abc.connectionState == ConnectionState.done) {
                                                if ('${abc.data.sundayIn}' == 'null') {
                                                  return Text('Día libre');
                                                }else if(abc.hasData){
                                                  return Text('${abc.data.sundayIn}',style: TextStyle(color: kgray));
                                                }                
                                              }
                                              else {
                                                return CircularProgressIndicator();
                                              }                                                     
                                            return CircularProgressIndicator(); 
                                            }
                                          
                                        )
                                      ),
                                      DataCell(
                                        FutureBuilder<Profile>(
                                          future: item,
                                          builder: (context, abc){
                                              if (abc.connectionState == ConnectionState.done) {
                                                if ('${abc.data.sundayOut}' == 'null') {
                                                  return Text('Día libre'); 
                                                }else if(abc.hasData){
                                                  return Text('${abc.data.sundayOut}',style: TextStyle(color: kgray));
                                                }
                                              }
                                              else {
                                                return CircularProgressIndicator();
                                              }
                                            return CircularProgressIndicator(); 
                                          }

                                        )
                                      )
                                    ]),
                                  },
                                ],
                              ),
                            
                              },
                              
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return ColorLoader3();
                  }
                },
              ),
              FutureBuilder<DataAgent>(
                future: itemx,
                builder: (context, abc){
                    if (abc.connectionState == ConnectionState.done) {
                      if (abc.data.companyId != 7) {
                        return Padding(padding:const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                      child: SolicitudCambio(
                        press: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return DetailScreen(plantilla: plantilla[3]);
                          }));
                        },
                      ),
                    ); 
                      }else{
                        Text('');
                      }
                    }
                    else {
                      return Text("");
                    }
                  return Text(""); 
                }),            
              SizedBox(height: 50)
            ]),
          )
      ),
    );
  }
}
