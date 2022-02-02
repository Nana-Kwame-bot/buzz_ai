import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class SoundRecorder {
  final Record _recorder = Record();
  late String path;

  Future<bool> get isRecording async => await _recorder.isRecording();

  Future<void> init() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception("Microphone permission is not granted");
    }

    path = (await getApplicationDocumentsDirectory()).path;
  }

  Future<void> record(String fileName) async {
    await _recorder.start(path: "$path/$fileName");
  }

  Future<void> stop() async {
    await _recorder.stop();
  }

  void dispose() {
    _recorder.dispose();
  }
}
