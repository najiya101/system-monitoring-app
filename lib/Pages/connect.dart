import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class datas {
  static Future<String> loadApiUrl() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/enter the name of url text file';//for storing url
    final file = File(filePath);

    if (await file.exists()) {
      //read the content from file
      final contents = await file.readAsString();
      return contents.trim();
    } else {
      //load default text from file
      final link = await rootBundle.loadString('enter the path of url text file');
      await file.create(recursive: true);//create new file to edit through textfield

      await file.writeAsString(link.trim());//initial link
      return link.trim();
    }
  }

  static Future<Map<String, dynamic>> fetchSystemMetrics() async {
    final url = await loadApiUrl();
    final client = HttpClient();//create http client
    final request = await client.getUrl(Uri.parse(url));//http get request
    final response = await request.close();

    if (response.statusCode == 200) {
      final responseBody = await response.transform(utf8.decoder).join();
      return json.decode(responseBody);
    } else {
      throw Exception('Failed to load system metrics');
    }
  }
}
