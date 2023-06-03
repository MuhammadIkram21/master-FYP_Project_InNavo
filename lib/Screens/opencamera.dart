import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  // Pick an image
  // final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  // Capture a photo

  // Pick a video
  // final XFile? image = await _picker.pickVideo(source: ImageSource.gallery);
  // Capture a video
  // final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
  // Pick multiple images
  // final List<XFile>? images = await _picker.pickMultiImage();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: Text('Navigate'),
        onPressed: () async {
          final XFile? photo =
              await _picker.pickImage(source: ImageSource.camera);
        },
      ),
    );
  }
}
