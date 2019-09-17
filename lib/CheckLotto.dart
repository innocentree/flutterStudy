import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'DataProvider.dart';

class CheckLotto extends StatefulWidget {
  @override
  CheckLottoState createState() => CheckLottoState();
}

class CheckLottoState extends State<CheckLotto> {
  final stageNum = 0;
  final winnerLottoNum = 1;
  final winnerCount = 3;
  final winnerPrice = 5;

  final lottoUrl ='https://www.dhlottery.co.kr/gameResult.do?method=byWin'; 
  String lastWinNumber = "";
  var widgetWinNumber = Text("wait for Data...");
  var widgetWinPrice = Text("");
  List<String> DataPolishing(List<String> inData){
    var foundData = <String>[];
    for (int i = 0; i < inData.length; i++) {
      //if (inData[i].split('.').first) {
        if (inData[i].contains(new RegExp(r'[0-9]'))){
          var e = inData[i].replaceAll(new RegExp(r'[^0-9^+^,]'), '');
          foundData.add(e);
      }
    }
    return foundData;
  }

  void RefreshData() {
    final data = fetchHTML(lottoUrl);
    data.then((value) {
      final splited = value.split(' ');
      final numberList = DataPolishing(splited);
      lastWinNumber = numberList[winnerLottoNum];
      setState(() {
        widgetWinNumber = Text("당첨번호 : " + numberList[winnerLottoNum]);
        widgetWinPrice = Text("당첨금 : " + numberList[winnerPrice] + "원");
      });
    });
  }

  @override
  void initState() {
    super.initState();
    RefreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:Column(
        children:<Widget>[
          widgetWinNumber,
          widgetWinPrice,
          FlatButton(
            child: Text("데이터 갱신"),
            onPressed: () => RefreshData(),
            color: Color.fromRGBO(100, 100, 100, 200),
            splashColor: Colors.cyan,
            focusColor: Colors.indigo,
          ),
        ],
        )
        );
  }
}
