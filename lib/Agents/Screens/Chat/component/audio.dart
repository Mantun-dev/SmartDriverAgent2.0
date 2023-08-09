import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class AudioContainer extends StatefulWidget {
  final String audioName;
  final int idSala;
  final Color colorIcono;

  const AudioContainer({required this.audioName, required this.colorIcono, required this.idSala});

  @override
  _AudioContainerState createState() =>
      _AudioContainerState(audioName: audioName, colorIcono: colorIcono, idSala: idSala);
}

class _AudioContainerState extends State<AudioContainer> {
  final String audioName;
  final Color colorIcono;
  final int idSala;
  late AudioPlayer _audioPlayer;
  bool audioPlaying = false;
  Map<String, File> tempFiles = {};
  Duration? audioDuration;
  String base64Audio = '';
  bool cargarAudio = false;

  _AudioContainerState({required this.audioName, required this.colorIcono, required this.idSala});

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    getAudio();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      cargarAudio == false? CircularProgressIndicator()
      :IconButton(
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
      if (audioDuration != null)
        Row(
          children: [
            Text(
              '${audioDuration!.inMinutes}:${(audioDuration!.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 10, color: colorIcono),
            ),
            Icon(
              Icons.done,
              size: 16,
              color: Colors.transparent,
            )
          ],
        ),
    ],
  );
}

  void getAudio() async{

    Map sendAudio = {
      "NombreAudio": audioName
    };

    String sendDataA = json.encode(sendAudio);
    var response = await http.post(Uri.parse('https://apichat.smtdriver.com/api/audios/$idSala'),body: sendDataA, headers: {"Content-Type": "application/json"});
    var resp = json.decode(response.body);
    print(response.body);
    if(resp!=null)
    base64Audio = resp['audios']['Audio'];

    setState(() {
      cargarAudio = true;
    });

  }

  void playAudio() async {
    try {

      if (!tempFiles.containsKey(base64Audio)) {
        List<int> audioBytes = base64.decode(base64Audio);
        File newTempFile = await _writeTempFile(audioBytes);
        print(newTempFile);
        if (newTempFile.existsSync()) {
          tempFiles[base64Audio] = newTempFile;
        } else {
          print('Error al crear el archivo temporal');
          return;
        }
      }

      await _audioPlayer.play(UrlSource(tempFiles[base64Audio]!.path));// Specify that the audio source is local
      final duration = await _audioPlayer.getDuration(); // Get the audio duration
      setState(() {
        audioPlaying = true;
        audioDuration = duration;
      });
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
    final tempPath = '${tempDir.path}/temp_$audioName.wav'; // Mantener la extensión como wav
    return File(tempPath).writeAsBytes(audioBytes);
  }
}

void deleteAllTempAudioFiles() async {
  try {
    final tempDir = await getTemporaryDirectory();
    final tempFiles = tempDir.listSync();

    for (final file in tempFiles) {
      if (file is File && file.path.endsWith('.wav')) { // Cambiar la extensión a wav
        await file.delete();
      }
    }
    print('Archivos temporales de audio eliminados con éxito');
  } catch (e) {
    print('Error al eliminar archivos temporales de audio: $e');
  }
}