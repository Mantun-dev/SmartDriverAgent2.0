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
// ignore: missing_return
Future<Profile> fetchProfile() async {
  http.Response response =
      await http.get(Uri.parse('$ip/api/profile/${prefs.nombreUsuario}'));
  if (response.statusCode == 200) {    
    if (response.body.isNotEmpty) {
      return Profile.fromJson(json.decode(response.body));
    }
  } else {
    throw Exception('Failed to load Data');
  }
  return fetchProfile();
}

// ignore: missing_return
Future<Profile> fetchVersion() async {
  http.Response response = await http.get(Uri.parse(
      "https://play.google.com/store/apps/details?id=" +
          "com.smartdriver.devs&hl=en"));
  //print(response.body);
  if (response.statusCode == 200) {
    String data = response.body;

    String pat1 =
        'Current Version</div><span class="htlgb"><div class="IQ1z0d"><span class="htlgb">';
    String pat2 = '</span>';

    int p1 = data.indexOf(pat1) + pat1.length;
    String f = data.substring(p1, data.length);
    int p2 = f.indexOf(pat2);

    String currentVersion = f.substring(0, p2);

    //return currentVersion;
    prefs.versionNew = currentVersion;
  }
  return fetchVersion();
}

//fetch Tips
Future<TripsList> fetchTrips() async {
  http.Response response =
      await http.get(Uri.parse('$ip/api/trips/${prefs.nombreUsuario}'));

  if (response.statusCode == 200) {
    final trip = TripsList.fromJson(json.decode(response.body));
    for (var i = 0; i < trip.trips.length; i++) {
      //print(trip.trips[i].btnCancelTrip);
    }
    return trip;
  } else {
    throw Exception('Failed to load Data');
  }
}

//fetch refresh agent data
Future<DataAgent> fetchRefres() async {
  http.Response response = await http
      .get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
  if (response.statusCode == 200) {
    return DataAgent.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Data');
  }
}

//fetch Story Trip
Future<List<Story>> fetchTripsStory() async {
  http.Response response =
      await http.get(Uri.parse('$ip/api/history/${prefs.nombreUsuario}'));
  final data = json.decode(response.body);
  final paymentList = data as List;
  if (response.statusCode == 200) {
    //print(paymentList.length);
    return paymentList.map((data) => Story.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load Data');
  }
}

//fetch Ticket Story
Future<TripsList6> fetchTicketStory() async {
  http.Response response0 = await http
      .get(Uri.parse('$ip/api/refreshingAgentData/${prefs.nombreUsuario}'));
  final si = DataAgent.fromJson(json.decode(response0.body));
  http.Response response =
      await http.get(Uri.parse('$ip/api/tickets/${si.agentId}'));
  final data = TripsList6.fromJson(json.decode(response.body));
  if (response.statusCode == 200) {
    print(data.trips[0].pendant!.length);
    return TripsList6.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Data');
  }
}

//close session
Future<DataAgents> fetchDeleteSession() async {
  Map data = {"token": prefs.tokenAndroid};
  http.Response response =
      await http.post(Uri.parse('$ip/api/deleteTokenSession'), body: data);
  if (response.statusCode == 200) {
    return DataAgents.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Data');
  }
}
