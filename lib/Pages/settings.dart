import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController _controller = TextEditingController();
  late String _filePath;

  @override
  void initState() {
    super.initState();
    _initializeFile();
  }

  Future<void> _initializeFile() async {
    final directory = await getApplicationDocumentsDirectory();
    _filePath = '${directory.path}/url.txt';

    final file = File(_filePath);
    if (!await file.exists()) {
      //if the file doesn't exist thencopy it from assets
      final data = await rootBundle.loadString('assets/url.txt');
      await file.writeAsString(data);
    }
    //read the content and update it in the TextField
    String fileContents = await file.readAsString();
    setState(() {
      _controller.text = fileContents;
    });
  }
  Future<void> _writeToFile(String text) async {
    final file = File(_filePath);
    await file.writeAsString(text);
   
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 245, 252, 255),
        title: Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: screenWidth * 0.7,
                  height: screenHeight * 0.4,
                  child: Image.asset(
                    'assets/2598572 (1).jpg',
                  ),
                ),
               
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: "Enter the URL here",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () async {
                    await _writeToFile(_controller.text);  //save the new URL to the text file
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('URL updated successfully!'))
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 245, 252, 255),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      'Submit',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
               SizedBox(height: 300,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
