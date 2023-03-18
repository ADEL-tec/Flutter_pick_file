import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _isImage = true;
  var _file = File("");
  var btnStyle = ButtonStyle(
      shape: MaterialStateProperty.all(
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
      ),
      textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 18)));

  void getImage() async {
    ImagePicker imagePicker = ImagePicker();

    final image = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _isImage = true;
      _file = File(image!.path);
    });
  }

  void getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'jpe', 'png', 'pdf', 'doc', 'docx'],
    );

    setState(() {
      _isImage = false;
      _file = File(result!.paths[0]!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("File Picker"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (ctx) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    getImage();
                                    Navigator.pop(ctx);
                                  },
                                  style: btnStyle,
                                  child: const Text("Take Image"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    getFile();
                                    Navigator.pop(ctx);
                                  },
                                  style: btnStyle,
                                  child: const Text("Pick File"),
                                ),
                              ],
                            ),
                          ));
                },
                borderRadius: const BorderRadius.all(Radius.circular(200)),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  // margin: EdgeInsets.symmetric(horizontal: 20),
                  height: 250,
                  width: 250,
                  decoration: const BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.all(Radius.circular(200)),
                  ),
                  child: Center(
                    child: _file.path.isEmpty
                        ? const Text(
                            "Please Select File",
                            style: TextStyle(color: Colors.white),
                          )
                        : _isImage
                            ? Image.file(
                                _file,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              )
                            : Text(
                                "file With Extension .${_file.path.split('.').last}",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _file.path,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ));
  }
}
