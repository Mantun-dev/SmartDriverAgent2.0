import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';

class AudioContainer extends StatefulWidget {
  final String base64Audio;
  final Color colorIcono;

  const AudioContainer({required this.base64Audio, required this.colorIcono});

  @override
  _AudioContainerState createState() =>
      _AudioContainerState(base64Audio: base64Audio, colorIcono: colorIcono);
}

class _AudioContainerState extends State<AudioContainer> {
  final String base64Audio;
  final Color colorIcono;
  late AudioPlayer _audioPlayer;
  bool audioPlaying = false;
  late File tempFile;

  _AudioContainerState({required this.base64Audio, required this.colorIcono});

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: IconButton(
        onPressed: () {
          setState(() {
            if (!audioPlaying) {
              playAudio();
            } else {
              stopAudio();
            }
          });
        },
        icon: !audioPlaying
            ? Icon(Icons.play_arrow, color: colorIcono)
            : Icon(Icons.stop, color: Colors.red),
      ),
    );
  }

  void playAudio() async {
    try {
      List<int> audioBytes = base64.decode(base64Audio);
      tempFile = await _writeTempFile(audioBytes);
      if (tempFile.existsSync()) {
        Source urlSource = UrlSource(tempFile.path);
        await _audioPlayer.play(urlSource);
        setState(() {
            audioPlaying = true;
          });
      } else {
        print('Error al crear el archivo temporal');
      }
    } catch (e) {
      print('Error al reproducir el audio: $e');
    }
  }

  void stopAudio() async {
    await _audioPlayer.stop();

    setState(() {
      audioPlaying = false;
    });
  }

  Future<File> _writeTempFile(List<int> audioBytes) async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/temp_audio.wav';
    return File(tempPath).writeAsBytes(audioBytes);
  }
}