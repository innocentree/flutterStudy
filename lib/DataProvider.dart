
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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