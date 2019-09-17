
import 'dart:collection';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
  Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}
  Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/savedFavoriteWords.txt');
}

Future<File> writeData(String data) async {
  final file = await _localFile;

  // 파일 쓰기
  return file.writeAsString(data);
}

Future<String> ReadData() async {
  try {
  final file = await _localFile;
  final len = file.lengthSync();
  if (len <= 0){
    return "";
  }
  String contents = await file.readAsString();
  return contents;
  } catch(e) {
    return "";
  }
}

Future<String> fetchHTML(String url) async {
  
  
  final response = await http.get(url); 
  //headers:{"charset":"EUC-KR","Accept-Charset":"EUC-KR"});
  if (response.statusCode == 200){
    final parsed = parser.parse(response.body);
    final data = parsed.getElementById('desc');

    final content = data.attributes['content'].toString();
    return content;

        // 숫자 6 + 1개
    final num1 = parsed.getElementsByClassName('ball_645').toList();
    //final tabledata = parsed.getElementsByClassName('tbl_data')[0].getElementsByTagName('tbody')[0].getElementsByClassName('tar').toList();

    final index1 = content.indexOf(' ');
    final index2 = content.indexOf('È'); // 회
    final stage = content.substring(index1+1, index2);
    final splited = content.split(' ');
    //final decoded = utf8.decode(content)
//    return response.body;
  }  else {
    return "";
  }
}