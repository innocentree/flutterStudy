import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class FavoriteWords extends StatefulWidget {
  List<WordPair> saved = <WordPair>[];
  FavoriteWords({Key key, this.saved}) : super();

  @override
  FavoriteWordsState createState() => FavoriteWordsState();
}

class FavoriteWordsState extends State<FavoriteWords> {
  final _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    final Iterable<ListTile> tiles = widget.saved.map(
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
    return ListView(children: divided);
  }
}