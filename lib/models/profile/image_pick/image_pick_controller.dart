import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickController extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  XFile? _lostImageFile;

  Future<String> _saveFile(File? imageFile, String fileName) async {
    if (imageFile == null) return '';
    Directory _appDirectory = await getApplicationDocumentsDirectory();
    // copy the file to a new path
    final File _newImage =
        await imageFile.copy('${_appDirectory.path}/$fileName');
    return _newImage.path;
  }

  Future<void> openGallery(BuildContext context) async {
    // Pick an image
    File? _selectedImage;
    final XFile? _image = await _picker.pickImage(source: ImageSource.gallery);
    if (_image == null) {
      await retrieveLostData();
      if (_lostImageFile == null) return;
      _selectedImage = File(_lostImageFile!.path);
    } else {
      _selectedImage = File(_image.path);
    }
    final fileName = basename(_selectedImage.path);
    String _path = await _saveFile(_selectedImage, fileName);
    Navigator.of(context).pop(_path);
  }

  Future<void> openCamera(BuildContext context) async {
    // Capture a photo
    File? _selectedImage;
    final XFile? _photo = await _picker.pickImage(source: ImageSource.camera);
    if (_photo == null) {
      await retrieveLostData();
      if (_lostImageFile == null) return;
      _selectedImage = File(_lostImageFile!.path);
    } else {
      _selectedImage = File(_photo.path);
    }
    final _fileName = basename(_selectedImage.path);
    String _path = await _saveFile(_selectedImage, _fileName);
    Navigator.of(context).pop(_path);
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      _lostImageFile = response.file;
    } else {
      log(response.exception!.code);
    }
  }
}
