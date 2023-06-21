import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/Agents/Screens/Details/components/loader.dart';

import 'package:flutter_auth/Agents/models/network.dart';
import 'package:flutter_auth/Agents/models/plantilla.dart';
import 'package:flutter_auth/Agents/models/ticketHistory.dart';
import 'package:flutter_auth/components/AppBarSuperior.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../components/AppBarPosterior.dart';
import '../../../../components/backgroundB.dart';

void main() {
  runApp(HistoryTicketScreen());
}

class HistoryTicketScreen extends StatefulWidget {
  //declaración instancia de plantilla y TripsList6 con sus variables
  final Plantilla? plantilla;
  final TripsList6? item;
  const HistoryTicketScreen({Key? key, this.plantilla, this.item})
      : super(key: key);
  @override
  _DataTableExample createState() => _DataTableExample();
}

class _DataTableExample extends State<HistoryTicketScreen> {
  // variable con instancia
  Future<TripsList6>? item;
  TripsList6? itemFiltro;
  bool ticketsP=true;
  int totalPendientes = 0;
  int totalProcesados = 0;

  @override
  void initState() {
    super.initState();
    //asignación de variable al fetch desde ticket story en network
    item = fetchTicketStory();
    getLista(item!);
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundBody(
      child: Scaffold(
        backgroundColor: Colors.transparent,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(56),
                  child: AppBarSuperior(item: 7)
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: cuerpo(),
                    ),
                    AppBarPosterior(item:-1),
                  ],
                ),
              ),
    );
  }

  void getLista(Future<TripsList6> _item)async{
    
    itemFiltro = await _item;

    setState(() { });
  }

  Widget cuerpo() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(

        decoration: BoxDecoration(
          border: Border.all( 
            color: Colors.white,
            width: 2
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(241, 239, 239, 1),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ticketsP ? Color.fromRGBO(40, 93, 169, 1) : Colors.transparent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  ticketsP = true;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Pendientes',
                                      style: TextStyle(
                                        color: ticketsP ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: ticketsP ? Colors.white : Color.fromRGBO(40, 93, 169, 1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        totalPendientes.toString(),
                                        style: TextStyle(
                                          color: !ticketsP ? Colors.white : Color.fromRGBO(40, 93, 169, 1),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        
                            SizedBox(width: 10),
          
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ticketsP ? Colors.transparent : Color.fromRGBO(40, 93, 169, 1),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  ticketsP = false;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      'Procesados',
                                      style: TextStyle(
                                        color: !ticketsP ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: !ticketsP ? Colors.white : Color.fromRGBO(40, 93, 169, 1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        totalProcesados.toString(),
                                        style: TextStyle(
                                          color: ticketsP ? Colors.white : Color.fromRGBO(40, 93, 169, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                    ),
                  ),  
                
                  Padding(
                    padding: const EdgeInsets.only(top: 22, bottom: 22),
                    child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(241, 239, 239, 1),
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: const Color.fromRGBO(241, 239, 239, 1),)
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                onChanged:(value) async {
                                 itemFiltro = await fetchTicketStory();

                                 if(ticketsP==true)
                                    if (value.isEmpty) {
                                      print('vacio');
                                      itemFiltro = await fetchTicketStory();
                                    } else {
                                      itemFiltro?.trips[0].pendant = itemFiltro?.trips[0].pendant?.where((ticket) =>
                                        ticket.ticketDatetime.contains(value) ||
                                        ticket.ticketId.toString().contains(value) ||
                                        ticket.ticketIssue.contains(value)
                                      ).toList();
                                    }
                                  else
                                  if (value.isEmpty) {
                                      print('vacio');
                                      itemFiltro = await fetchTicketStory();
                                    } else {
                                      itemFiltro?.trips[1].closed = itemFiltro?.trips[1].closed?.where((ticket) =>
                                        ticket.ticketDatetime!.contains(value) ||
                                        ticket.ticketId!.toString().contains(value) ||
                                        ticket.ticketIssue!.contains(value)
                                      ).toList();
                                    }
                                    setState(() {
                                      
                                    });
                                },
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search, color: Color.fromRGBO(40, 93, 169, 1),),
                                  hintText: 'Buscar',
                                  hintStyle: TextStyle(color: Color.fromRGBO(158, 158, 158, 1)),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        )
                      ),
                  ), 
                  
                  if(ticketsP==true)
                    _ticketPendant(),
                
                  if(ticketsP==false)
                    _ticketProcess(),
                  SizedBox(height: 50)
                ]),
          ),
        ),
      ),
    );
  }

  Widget _ticketPendant() {
    //construcción de future builder para mostrar data
    return FutureBuilder<TripsList6>(
      future: itemFiltro==null ? item : Future.value(itemFiltro),
      builder: (BuildContext context, abc) {
        if (abc.connectionState == ConnectionState.done) {
          //validación de arreglo vacio
          if (abc.data!.trips[0].pendant!.length == 0) {
            return Column(
            children: [
              SizedBox(height: 15),
              Center(
                child: Text(
                  'No hay tickets pendientes',
              
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
            return FutureBuilder<TripsList6>(
              future: itemFiltro==null ? item : Future.value(itemFiltro),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: abc.data!.trips[0].pendant!.length,
                    itemBuilder: (context, index) {
                      //retorno de container y card con la data respectiva
                      return Card(
                        elevation: 0,
                        color: const Color.fromRGBO(241, 239, 239, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(right: 40, left: 40, top: 15, bottom: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 18,
                                              height: 18,
                                              child: SvgPicture.asset(
                                                "assets/icons/advertencia.svg",
                                                color: Color.fromRGBO(40, 93, 169, 1),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Flexible(
                                              child: Text(
                                                'Fecha: ${abc.data!.trips[0].pendant![index].ticketDatetime}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              
                                      SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          '# Ticket: ${abc.data!.trips[0].pendant![index].ticketId}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Color.fromRGBO(40, 93, 169, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(right: 40, left: 40),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          "assets/icons/calendar-note-svgrepo-com.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          'Asunto: ${abc.data!.trips[0].pendant![index].ticketIssue}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRect(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        widthFactor: 0.5,
                                        child: Container(
                                          width: 60,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                              
                                    Expanded(child: DottedLine(dashLength:12, dashGapLength:10)),
                                              
                                    ClipRect(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: 0.5,
                                        child: Container(
                                          width: 60,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(right: 40, left: 40, bottom: 15),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          "assets/icons/advertencia.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          'Mensaje: ${abc.data!.trips[0].pendant![index].ticketMessage}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                      );
                    });
              },
            );
          }
        } else {
          return ColorLoader3();
        }
      },
    );
  }

  Widget _ticketProcess() {
    //Future builder para la data
    return FutureBuilder<TripsList6>(
      future: itemFiltro==null ? item : Future.value(itemFiltro),
      builder: (BuildContext context, abc) {
        if (abc.connectionState == ConnectionState.done) {
          //validación de arreglo vacio
          if (abc.data!.trips[1].closed?.length == 0) {
            return Column(
            children: [
              SizedBox(height: 15),
              Center(
                child: Text(
                  'No hay tickets en proceso',
              
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
            return FutureBuilder<TripsList6>(
              future: itemFiltro==null ? item : Future.value(itemFiltro),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                //retorna el ListView builder para la data dinámica
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: abc.data!.trips[1].closed?.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0,
                        color: const Color.fromRGBO(241, 239, 239, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [

                              Padding(
                                padding: const EdgeInsets.only(right: 40, left: 40, top: 15, bottom: 5),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 18,
                                              height: 18,
                                              child: SvgPicture.asset(
                                                "assets/icons/advertencia.svg",
                                                color: Color.fromRGBO(40, 93, 169, 1),
                                              ),
                                            ),
                                            SizedBox(width: 5),
                                            Flexible(
                                              child: Text(
                                                'Fecha: ${abc.data!.trips[1].closed![index].ticketDatetime}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.normal,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              
                                      SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          '# Ticket: ${abc.data!.trips[1].closed![index].ticketId}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Color.fromRGBO(40, 93, 169, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(right: 40, left: 40),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          "assets/icons/calendar-note-svgrepo-com.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          'Asunto: ${abc.data!.trips[1].closed![index].ticketIssue}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRect(
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        widthFactor: 0.5,
                                        child: Container(
                                          width: 60,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                              
                                    Expanded(child: DottedLine(dashLength:12, dashGapLength:10)),
                                              
                                    ClipRect(
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: 0.5,
                                        child: Container(
                                          width: 60,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(right: 40, left: 40),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          "assets/icons/advertencia.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          'Mensaje: ${abc.data!.trips[1].closed![index].ticketMessage}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 10),

                              Padding(
                                padding: const EdgeInsets.only(right: 40, left: 40, bottom: 15),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        child: SvgPicture.asset(
                                          "assets/icons/advertencia.svg",
                                          color: Color.fromRGBO(40, 93, 169, 1),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Flexible(
                                        child: Text(
                                          'Respuesta de ${abc.data!.trips[1].closed![index].userName}: ${abc.data!.trips[1].closed![index].replyMessage}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 12.0,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                      );
                    });
              },
            );
          }
        } else {
          return ColorLoader3();
        }
      },
    );
  }
}