import 'package:flutter/material.dart';
import 'CheckLotto.dart';

class LottoHome extends StatefulWidget {
  @override
  LottoHomeState createState() => LottoHomeState();
}

class LottoHomeState extends State<LottoHome> {
  int bottomSelectedIndex = 0;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
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
  void initState() {
    super.initState();
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(Icons.home), title: new Text('Lotto')),
      BottomNavigationBarItem(
        icon: new Icon(Icons.favorite),
        title: new Text('null'),
      ),
    ];
  }
  
  Widget buildPageView(){
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
       CheckLotto(),
        Text('hello world2'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LottoHome"),
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