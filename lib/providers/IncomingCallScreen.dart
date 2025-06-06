import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_auth/Agents/Screens/calls/WebRTCCallPage.dart';

// ignore: must_be_immutable
class IncomingCallScreen extends StatefulWidget {
  final String callerName;
  dynamic array = {};
  IncomingCallScreen({super.key, required this.callerName, required this.array});

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _startRingtone();
  }

  void _startRingtone() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    // await _audioPlayer.play(UrlSource('android.resource://com.smartdriver.devs/raw/call'));
  }

  void _stopRingtone() {
    _audioPlayer.stop();
  }

  void _onAccept() {
    // _stopRingtone();
    // // lógica para aceptar la llamada
    // Navigator.pop(context);
    final data = widget.array;
    final roomId = data['roomId'];
    final tripId = data['tripId'];
    final callType = data['callType'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WebRTCCallPage(
          selfId: 'QP1A.190711.020',
          targetId: 'TP1A.220624.014',
          isCaller: callType=="Incoming"? false: true,
          roomId: '70',
          tripId: '$tripId',
        ),
      ),
    );

  }

  void _onReject() {
    _stopRingtone();
    // lógica para rechazar la llamada
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _stopRingtone();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.callerName,
                style: const TextStyle(color: Colors.white, fontSize: 32),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: "reject",
                    onPressed: _onReject,
                    backgroundColor: Colors.red,
                    child: const Icon(Icons.call_end),
                  ),
                  FloatingActionButton(
                    heroTag: "accept",
                    onPressed: _onAccept,
                    backgroundColor: Colors.green,
                    child: const Icon(Icons.call),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
