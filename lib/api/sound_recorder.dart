import 'dart:developer';

import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SoundRecorder {
  FlutterSoundRecorder? _audioRecorder;
  bool _isRecorderInitialized = false;

  bool get isRecording => _audioRecorder!.isRecording;

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();

    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException(
          "Microphone permission is not granted");
    }

    await _audioRecorder!.openRecorder();
    _isRecorderInitialized = true;
  }

  void dispose() {
    _audioRecorder!.closeRecorder();
    _audioRecorder = null;
    _isRecorderInitialized = false;
  }

  Future record(String fileName) async {
    if (!_isRecorderInitialized)
      return log("Initialize the recorder before calling");

    await _audioRecorder!.startRecorder(toFile: fileName);
  }

  Future stop() async {
    if (!_isRecorderInitialized)
      return log("Initialize the recorder before calling");

    await _audioRecorder!.stopRecorder();
  }
}
