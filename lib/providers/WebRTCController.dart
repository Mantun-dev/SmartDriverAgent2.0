// WebRTCController.dart

import 'package:flutter_auth/providers/MqttSignalingService.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

typedef OnRemoteStream = void Function(MediaStream stream);
typedef OnControllerReady = void Function(String selfId);

class WebRTCController {
  final String selfId;
  final String targetId;
  final MqttSignalingService signalingService;
  final OnRemoteStream onRemoteStream;
  final OnControllerReady onControllerReady;
  final bool isCaller;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  final RTCVideoRenderer localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer remoteRenderer = RTCVideoRenderer();
  bool isCameraEnabled = false; // New: Flag to control video emission

  WebRTCController({
    required this.selfId,
    required this.targetId,
    required this.signalingService,
    required this.onRemoteStream,
    required this.onControllerReady,
    required this.isCaller
  });

  Future<void> initRenderers() async {
    await localRenderer.initialize();
    await remoteRenderer.initialize();
  }

  Future<void> initialize({bool isCaller = false}) async {
    print('**************************************');
    print(selfId);
    print(targetId);
    print(signalingService);
    print(onRemoteStream);
    // This line is back! It overwrites the initial callback from WebRTCCallPage
    // to ensure the WebRTCController's handling logic is used.
    signalingService.onSignalReceived = _handleIncomingSignal; // <--- Renamed for clarity

    await initRenderers();

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': true,
    });

    localRenderer.srcObject = _localStream;

    _peerConnection = await _createPeerConnection();

    // Add these important state printings for debugging ICE and Signaling states
    _peerConnection?.onIceConnectionState = (state) {
      print('*********** WebRTCController: ICE Connection State: $state');
    };
    _peerConnection?.onSignalingState = (state) {
      print('*********** WebRTCController: Signaling State: $state');
    };


    _localStream?.getTracks().forEach((track) {
      print('*********** WebRTCController: Adding local track to peer connection. Type: ${track.kind}, ID: ${track.id}');
      _peerConnection?.addTrack(track, _localStream!);
    });

    _peerConnection?.onTrack = (RTCTrackEvent event) {
      print('*********** WebRTCController: onTrack event received!');
      if (event.streams.isNotEmpty) {
        if (event.track.kind == 'video') {
           remoteRenderer.srcObject = event.streams.first;
           print('*********** WebRTCController: Remote video stream received and assigned.');
           onRemoteStream(event.streams.first);
        } else if (event.track.kind == 'audio') {
           print('*********** WebRTCController: Remote audio stream received.');
        }
      }
    };

    _peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      print('*********** WebRTCController: ICE Candidate generated: ${candidate.candidate}');
      if (candidate != null) {
        // Send candidate to targetId
        signalingService.sendSignal(targetId, {
          'type': 'iceCandidate', // Changed from 'candidate' to 'iceCandidate' for consistency
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
          'from': selfId,
          'to': targetId,
        });
      }
    };
    onControllerReady(selfId);
    if (isCaller) {
      print('*********** WebRTCController: Creating and sending OFFER (as Caller)');
      await _createAndSendOffer();
    } else {
      print('*********** WebRTCController: Waiting for OFFER (as Receiver)'); // Added this log for clarity
    }
  }

    // NEW: Method to toggle video
  Future<void> toggleCamera() async {
    if (_peerConnection == null || _localStream == null) {
      print('Warning: PeerConnection or LocalStream is null. Cannot toggle camera.');
      return;
    }

    isCameraEnabled = !isCameraEnabled;
    print('Toggling camera. New state: $isCameraEnabled');

    // Get current video track sender from peer connection
    RTCRtpSender? videoSender;
    // --- CORRECTED LINE HERE ---
    final List<RTCRtpSender> senders = await _peerConnection!.getSenders(); // AWAIT the Future
    for (var sender in senders) { // Now iterate over the list
      if (sender.track?.kind == 'video') {
        videoSender = sender;
        break;
      }
    }
    // --- END CORRECTED LINE ---

    if (isCameraEnabled) {
      // If camera is being enabled
      if (videoSender != null && videoSender.track != null) {
        // If we already have a video track, just enable it
        videoSender.track!.enabled = true;
        print('Enabled existing video track.');
      } else {
        // If no video track exists, get a new one and add/replace
        print('Getting new video track to enable camera.');
        try {
          MediaStream newVideoMediaStream = await navigator.mediaDevices.getUserMedia({'video': true});
          MediaStreamTrack newVideoTrack = newVideoMediaStream.getVideoTracks().first;

          if (_localStream != null) {
            // Remove any old video tracks from the local stream
            _localStream!.getVideoTracks().forEach((track) {
              _localStream!.removeTrack(track);
              track.stop(); // Stop old track to release camera
            });
            // Add the new video track to the local stream
            _localStream!.addTrack(newVideoTrack);
            localRenderer.srcObject = _localStream; // Update renderer to show new stream
          }


          if (videoSender != null) {
            // If sender exists, replace its track
            await videoSender.replaceTrack(newVideoTrack);
            print('Replaced existing video sender track with new one.');
          } else {
            // If no video sender, add a new track to the peer connection
            // Note: Adding a new track after the initial setup might require
            // a new offer/answer exchange ( renegotiation).
            // This is handled automatically by WebRTC if both sides support it,
            // but it's good to be aware.
            await _peerConnection!.addTrack(newVideoTrack, _localStream!);
            print('Added new video track to peer connection.');
          }
        } catch (e) {
          print("Error enabling camera/getting video track: $e");
          isCameraEnabled = false; // Revert state if error
        }
      }
    } else {
      // If camera is being disabled
      if (videoSender != null && videoSender.track != null) {
        videoSender.track!.enabled = false;
        print('Disabled existing video track.');

        // Optionally, remove the video track from the local stream and peer connection
        // for full camera release, but disabling `track.enabled` is usually sufficient
        // and less disruptive to the SDP.
        // For full release:
        // _localStream!.getVideoTracks().forEach((track) {
        //   _localStream!.removeTrack(track);
        //   track.stop();
        // });
        // if (videoSender != null) {
        //   await _peerConnection!.removeTrack(videoSender);
        // }
        // localRenderer.srcObject = _localStream; // Update renderer to reflect no video
      }
    }
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    final config = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };
    final offerSdpConstraints = { // Add these constraints for better control
      "mandatory": {
        "OfferToReceiveAudio": true,
        "OfferToReceiveVideo": true,
      },
      "optional": [],
    };
    return await createPeerConnection(config, offerSdpConstraints); // Pass constraints
  }

  // This is the single, unified handler for all incoming signals
  void _handleIncomingSignal(Map<String, dynamic> message) { // Renamed from _onSignalReceived
    print('kheeeeeeeee*************************'); // Your print here!
    print(message);

    // Critical check: only process signals intended for this device
    if (message['to'] != selfId) {
      print('❗ WebRTCController: Ignorando señal no destinada a este dispositivo: ${message['to']} (selfId: $selfId)');
      return;
    }

    final type = message['type'];
    // Use the fallback from your demo's _onSignalReceived
    final data = message['data'] ?? message;

    print('📡 WebRTCController: Señal recibida para $selfId. Tipo: $type, Desde: ${message['from']}');

    switch (type) {
      case 'ready': // NEW CASE for 'ready' signal
        if (selfId == targetId) { // Ignore if "ready" signal is from self for self-test
          print('Ignoring self-sent "ready" signal.');
          return;
        }
        if (isCaller) { // Only the caller acts on 'ready' signals
          print('✅ WebRTCController: Received "ready" signal from ${data['from']}. Sending OFFER...');
          _createAndSendOffer(); // Now the caller sends the offer!
        }
        break;
      case 'offer':
        _handleOffer(data);
        break;
      case 'answer':
        _handleAnswer(data);
        break;
      case 'iceCandidate': // Consistent with the type sent
        _handleIceCandidate(data);
        break;
      case 'candidate': // Keep for backward compatibility if old signals might use this
        print('Using old "candidate" type for ICE message.');
        _handleIceCandidate(data);
        break;
      default:
        print('❓ WebRTCController: Tipo de señal desconocido: $type');
    }
  }

  Future<void> _createAndSendOffer() async {
    final offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    signalingService.sendSignal(targetId, {
      'type': 'offer',
      'sdp': offer.sdp,
      'from': selfId,
      'to': targetId,
    });
    print('*********** WebRTCController: OFFER sent to ${targetId}');
  }

  Future<void> _handleOffer(Map<String, dynamic> data) async {
    // Ensure peerConnection is not null before using it
    if (_peerConnection == null) {
      print('❗ WebRTCController: PeerConnection es null al manejar oferta. Esto no debería ocurrir.');
      return;
    }

    final description = RTCSessionDescription(data['sdp'], 'offer');
    await _peerConnection?.setRemoteDescription(description);
    print('*********** WebRTCController: OFFER received and remote description set.');


    final answer = await _peerConnection!.createAnswer();
    await _peerConnection!.setLocalDescription(answer);

    signalingService.sendSignal(data['from'], { // Send answer back to the sender of the offer
      'type': 'answer',
      'sdp': answer.sdp,
      'from': selfId,
      'to': data['from'], // Explicitly set 'to' for clarity
    });

    print('*********** WebRTCController: ANSWER sent to ${data['from']}');
  }

  Future<void> _handleAnswer(Map<String, dynamic> data) async {
    // Ensure peerConnection is not null before using it
    if (_peerConnection == null) {
      print('❗ WebRTCController: PeerConnection es null al manejar answer. Esto no debería ocurrir.');
      return;
    }

    final description = RTCSessionDescription(data['sdp'], 'answer');
    await _peerConnection!.setRemoteDescription(description);
    print('*********** WebRTCController: ANSWER received and applied.');
  }

  Future<void> _handleIceCandidate(Map<String, dynamic> data) async {
    // Ensure peerConnection is not null before using it
    if (_peerConnection == null) {
      print('❗ WebRTCController: PeerConnection es null al manejar ICE Candidate. Esto no debería ocurrir.');
      return;
    }

    final candidate = RTCIceCandidate(
      data['candidate'],
      data['sdpMid'],
      data['sdpMLineIndex'],
    );
    await _peerConnection?.addCandidate(candidate);
    print('*********** WebRTCController: ICE Candidate agregado');
  }

  void dispose() {
    print('----------- WebRTCController: Disposing resources -----------');
    _peerConnection?.close();
    _peerConnection = null;
    _localStream?.getTracks().forEach((track) => track.stop());
    _localStream?.dispose();
    _localStream = null;
    localRenderer.dispose();
    remoteRenderer.dispose();
  }
}