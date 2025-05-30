import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';


class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? image;
  late ImagePicker imagePicker;
  String resultText = "No analysis yet.";

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }

  chooseImage() async {
    XFile? selectedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImage != null) {
      setState(() {
        image = File(selectedImage.path);
        resultText = "Analyzing...";
      });

      await analyzeFoodFile(image!);
    }
  }

  captureImage() async {
    XFile? selectedImage = await imagePicker.pickImage(source: ImageSource.camera);
    if (selectedImage != null) {
      setState(() {
        image = File(selectedImage.path);
        resultText = "Analyzing...";
      });

      await analyzeFoodFile(image!);
    }
  }


  Future<void> analyzeFoodFile(File imageFile) async {
    final url = Uri.parse('http://10.0.2.2:8000/analyze-file'); // your backend endpoint

    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          StringBuffer buffer = StringBuffer();
          for (var item in data['results']) {
            buffer.writeln('✅ ${item['name']} (${item['probability']})');
            if (item['nutrition'] != null) {
              buffer.writeln('  🔥 Calories: ${item['nutrition']['calories']} kcal');
              buffer.writeln('  🥩 Protein: ${item['nutrition']['protein']} g');
              buffer.writeln('  🍚 Carbs: ${item['nutrition']['carbs']} g');
              buffer.writeln('  🛢️ Fat: ${item['nutrition']['fat']} g\n');
            }
          }
          setState(() {
            resultText = buffer.toString();
          });
        } else {
          setState(() {
            resultText = '❌ Analysis failed: ${data['message']}';
          });
        }
      } else {
        setState(() {
          resultText = '❌ Server error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        resultText = '❌ Error: $e';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(32, 42, 68, 1),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              image == null
                  ? Icon(Icons.image_outlined, size: 100, color: Colors.white)
                  : Image.file(image!),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  chooseImage();
                },
                onLongPress: () {
                  captureImage();
                },
                child: Text("Choose (tap) / Capture (long press)"),
              ),
              SizedBox(height: 20),
              Text(
                resultText,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
