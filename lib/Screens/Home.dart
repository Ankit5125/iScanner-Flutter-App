import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isSelected = false;
  File? image;
  String objectDetails = "";
  final picker = ImagePicker();
  final TextEditingController controller = TextEditingController();

  Future<void> fetchData(InputImage inputImage) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final RecognizedText recognizedText = await textRecognizer.processImage(
      inputImage,
    );
    setState(() {
      objectDetails = recognizedText.text.toString();
    });
  }

  Future<void> pickImage(bool fromGalary) async {
    final pickedFile = await picker.pickImage(
      source: fromGalary ? ImageSource.gallery : ImageSource.camera,
    );
    if (pickedFile != null) {
      InputImage inputImage = InputImage.fromFilePath(pickedFile.path);
      fetchData(inputImage);
      setState(() {
        image = File(pickedFile.path);
        isSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "iScanner",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => pickImage(true),
            icon: Icon(Icons.image_search_outlined, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 400,
                  width: 500,
                  child: !isSelected
                      ? Center(
                          child: Text(
                            "Pick Image",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Image.file(image!, fit: BoxFit.fitWidth),
                ),
              ),
              isSelected
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 70,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          margin: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            objectDetails,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: objectDetails),
                            );
                          },
                          icon: Icon(Icons.copy),
                          color: Colors.white,
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => pickImage(false),
        child: Icon(
          !isSelected ? Icons.add : Icons.restart_alt,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
