import 'package:english_words/english_words.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'DataProvider.dart';
import 'dart:convert'; // string to List<String>

class RandomWords extends StatefulWidget {
  List<WordPair> saved = <WordPair>[];
  List<WordPair> randomList = <WordPair>[];

  RandomWords({Key key, this.saved, this.randomList}) : super();
  @override
  RandomWordsState createState() => RandomWordsState();

  void dataSave(){
    //String savedString = saved.toString();
    var savedString = <String>[];
    for (WordPair e in saved)
    {
      savedString.add(e.first + '+' + e.second);
    }
    // savedString.toString() 으로 넣으면 a, b, c로 들어가는데
    // 이를 저장했다가 load 하면서 string to List<String> 하기 위해 
    // json.decode 를 사용하게 되면 에러가 난다. decode 는 "a", "b" 형태를
    // 기반으로 decode 하기 때문
    // 그래서 저장할 때에도 규칙에 맞게 encode 로 넣어준다.
    writeData(json.encode(savedString));
  }
}

class RandomWordsState extends State<RandomWords> {
  
  final _biggerFont = const TextStyle(fontSize: 18.0);
  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = widget.saved.contains(pair);
    return ListTile(
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),
        onTap: () {
          setState(() {
            if (alreadySaved) {
              widget.saved.remove(pair);
              widget.dataSave();
            } else {
             widget.saved.add(pair);
             widget.dataSave();
            }
          });
        });
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();
          final index = i ~/ 2;
          if (index >= widget.randomList.length) {
            widget.randomList.addAll(prefix0.generateWordPairs().take(10));
          }
          return _buildRow(widget.randomList[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }
}
