import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> logFoodToFirestore(Map<String, dynamic> foodItem) async {
  final CollectionReference logsCollection =
  FirebaseFirestore.instance.collection('food_logs');

  await logsCollection.add({
    'food_name': foodItem['name'],
    'calories': foodItem['nutrition']['calories'],
    'protein': foodItem['nutrition']['protein'],
    'carbs': foodItem['nutrition']['carbs'],
    'fat': foodItem['nutrition']['fat'],
    'timestamp': Timestamp.now(),
  });
}

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  File? image;
  late ImagePicker imagePicker;
  String resultText = "No analysis yet.";
  bool canLog = false;

  List<dynamic> lastAnalyzedFoodItems = [];

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
        canLog = false;
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
        canLog = false;
      });
      await analyzeFoodFile(image!);
    }
  }

  Future<void> analyzeFoodFile(File imageFile) async {
    final url = Uri.parse('http://10.0.2.2:8000/analyze-file');

    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          lastAnalyzedFoodItems = data['results'];

          var firstItem = data['results'][0];
          StringBuffer buffer = StringBuffer();
          buffer.writeln('✅ ${firstItem['name']} (${firstItem['probability']})');
          if (firstItem['nutrition'] != null) {
            buffer.writeln('  🔥 Calories: ${firstItem['nutrition']['calories']} kcal');
            buffer.writeln('  🥩 Protein: ${firstItem['nutrition']['protein']} g');
            buffer.writeln('  🍚 Carbs: ${firstItem['nutrition']['carbs']} g');
            buffer.writeln('  🛢️ Fat: ${firstItem['nutrition']['fat']} g');
          }

          setState(() {
            resultText = buffer.toString();
            canLog = true;
          });
        } else {
          setState(() {
            resultText = '❌ Analysis failed: ${data['message']}';
            canLog = false;
          });
        }
      } else {
        setState(() {
          resultText = '❌ Server error: ${response.statusCode}';
          canLog = false;
        });
      }
    } catch (e) {
      setState(() {
        resultText = '❌ Error: $e';
        canLog = false;
      });
    }
  }

  Future<void> logFirstToFirestore(List<dynamic> foodItems) async {
    if (foodItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ No food items to log')),
      );
      return;
    }

    var firstItem = foodItems[0];
    try {
      await logFoodToFirestore(firstItem);
      print('✅ Log saved for ${firstItem['name']}');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Logged ${firstItem['name']} to Firestore')),
      );
    } catch (error) {
      print('❌ Failed to save log for ${firstItem['name']}: $error');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Failed to log ${firstItem['name']}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 42, 68, 1),
      appBar: AppBar(
        title: const Text("Food Analyzer"),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.pushNamed(context, '/logs');
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              image == null
                  ? const Icon(Icons.image_outlined, size: 100, color: Colors.white)
                  : Image.file(image!),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  chooseImage();
                },
                onLongPress: () {
                  captureImage();
                },
                child: const Text("Choose (tap) / Capture (long press)"),
              ),
              const SizedBox(height: 20),
              Text(
                resultText,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: canLog ? () => logFirstToFirestore(lastAnalyzedFoodItems) : null,
                icon: const Icon(Icons.save),
                label: const Text("Log Result"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
