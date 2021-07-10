//import 'dart:io';

//import 'package:flutter/material.dart';
//import 'package:flutter_auth/Agents/models/account.dart';
import 'package:flutter_auth/Agents/models/dataAgentMessage.dart';
import 'package:flutter_auth/Agents/models/historyTrips.dart';
import 'package:flutter_auth/Agents/models/profileAgent.dart';
import 'package:flutter_auth/Agents/models/ticketHistory.dart';
import 'package:flutter_auth/Agents/models/tripAgent.dart';
import 'package:flutter_auth/Agents/sharePrefers/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json;

import 'dataAgent.dart';

  String ip = "https://smtdriver.com";

//función fecth profile 
  final prefs = new PreferenciasUsuario();
  Future<Profile>fetchProfile() async {
    http.Response response = await http.get(Uri.encodeFull('$ip/api/profile/${prefs.nombreUsuario}'));
    if (response.statusCode == 200) {   
   
      return Profile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }


//fetch Tips
  Future<TripsList>fetchTrips() async {
    http.Response response = await http.get(Uri.encodeFull('$ip/api/trips/${prefs.nombreUsuario}'));
  
    if (response.statusCode == 200) {   
      
      return TripsList.fromJson(json.decode(response.body));

    } else {
      throw Exception('Failed to load Data');
    }
  }

//fetch refresh agent data
  Future<DataAgent>fetchRefres() async {
    http.Response response = await http.get(Uri.encodeFull('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));    
    if (response.statusCode == 200) {      
      return DataAgent.fromJson(json.decode(response.body));

    } else {
      throw Exception('Failed to load Data');
    }

  }

//fetch Story Trip
  Future <List< Story>>fetchTripsStory() async {
    http.Response response = await http.get(Uri.encodeFull('$ip/api/history/${prefs.nombreUsuario}'));
    final data = json.decode(response.body);
    final paymentList = data as List;
    if (response.statusCode == 200) {  
      print(paymentList.length);      
      return paymentList.map((data) => Story.fromJson(data)).toList();      
    } else {
      throw Exception('Failed to load Data');
    }
  }

//fetch Ticket Story
Future < TripsList6>fetchTicketStory() async {
   http.Response response0 = await http.get(Uri.encodeFull('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
   final si = DataAgent.fromJson(json.decode(response0.body));
    http.Response response = await http.get(Uri.encodeFull('$ip/api/tickets/${si.agentId}'));
    final data = TripsList6.fromJson(json.decode(response.body)); 
    if (response.statusCode == 200) {  
      print(data.trips[0].pendant.length);
      return TripsList6.fromJson(json.decode(response.body));     
    } else {
      throw Exception('Failed to load Data');
    }
}

//close session
  Future<DataAgents>fetchDeleteSession() async {
    Map data =
    {
      "token" : prefs.tokenAndroid
    };
    http.Response response = await http.post(Uri.encodeFull('$ip/api/deleteTokenSession'), body: data);
    if (response.statusCode == 200) {   
         
      return DataAgents.fromJson(json.decode(response.body));

    } else {
      throw Exception('Failed to load Data');
    }
  }

