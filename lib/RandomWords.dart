import 'package:english_words/english_words.dart' as prefix0;
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:io';


class RandomWords extends StatefulWidget {
  List<WordPair> saved = <WordPair>[];
  List<WordPair> randomList = <WordPair>[];

  RandomWords({Key key, this.saved, this.randomList}) : super();
  @override
  RandomWordsState createState() => RandomWordsState();
 
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
            } else {
             widget.saved.add(pair);
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

  /*
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggetions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
  */
  @override
  Widget build(BuildContext context) {
    return _buildSuggestions();
  }
/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
     //   actions: <Widget>[
     //     IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
     //   ],
      ),
      body: _buildSuggestions(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomSelectedIndex,
      items: buildBottomNavBarItems(),
      ),
    );
  }*/
}