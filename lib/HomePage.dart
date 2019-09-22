import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'FavoriteWords.dart';
import 'RandomWords.dart';
import 'DataProvider.dart';
import 'dart:convert'; // string to List<String>
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int bottomSelectedIndex = 0;
  List<WordPair> saved = <WordPair>[];
  List<WordPair> randomList = <WordPair>[];
  
  void dataLoad(){
    var str = readData();
    str.then((value) {
      // file io 는 async - await - Future(관계 확인하자)으로 사용하는듯
      // 1. value 는 항상 string 으로만 들어오는가
      // 2. then 과 WhenComplete 차이 확인하자

      //var strList = (json.decode(value) as List<dynamic>).cast<String>();// string to List<String>
      var strList = json.decode(value) as List<dynamic>;// string to List<String>
      // [a, b, c] => a b c
      for (String e in strList){
        if (e.contains("+")) {
          var subStr = e.split("+");
          saved.add(WordPair(subStr.first, subStr.last));
        }
      }
    });
   
  }
  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(Icons.home), title: new Text('Words')),
      BottomNavigationBarItem(
        icon: new Icon(Icons.favorite),
        title: new Text('Favorites'),
      ),
    ];
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        RandomWords(saved : this.saved, randomList : this.randomList),
        FavoriteWords(saved : this.saved),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    dataLoad();
  }

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 100), curve: Curves.ease);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
      ),
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomSelectedIndex,
        onTap: (index) {
          bottomTapped(index);
        },
        items: buildBottomNavBarItems(),
      ),
    );
  }
}

