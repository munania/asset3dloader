import 'package:asset3dloader/avatar_scene.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String? selectedFilePath;

  Future<void> pickGLBFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          selectedFilePath = result.files.first.path;
          debugPrint('Selected file path: $selectedFilePath');
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('3D Model Viewer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display 3D model if file is selected
            if (selectedFilePath != null)
              Expanded(
                child: ModelViewer(
                  src: 'file://$selectedFilePath',
                  alt: "A 3D model",
                  autoRotate: true,
                  cameraControls: true,
                ),
              ),

            // Button to pick GLB file
            ElevatedButton.icon(
              onPressed: pickGLBFile,
              icon: const Icon(Icons.file_upload),
              label: const Text('Load GLB File'),
            ),

            const SizedBox(height: 16),

            // Button to navigate to another page
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AvatarScene()),
                );
              },
              icon: const Icon(Icons.arrow_forward),
              label: const Text('Avatars in a Scene'),
            ),
          ],
        ),
      ),
    );
  }
}
