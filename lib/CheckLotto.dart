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
  final lottoUrl = 'https://www.dhlottery.co.kr/gameResult.do?method=byWin';
  var specificNumberPage = "&drwNo="; // + num 해서 위에거에 붙이면 됨
  String lastWinNumber = "";
  String selectedWinStage = "";
  var widgetWinNumber = Text("wait for Data...");
  var widgetWinPrice = Text("");
  var widgetWinStage = Text("");
  var lottoStageList = <String>[];
  var _isLoading = false;

  String _dropdownValue = '-';
  List<String> DataPolishing(List<String> inData) {
    var foundData = <String>[];
    for (int i = 0; i < inData.length; i++) {
      if (inData[i].contains(new RegExp(r'[0-9]'))) {
        var e = inData[i].replaceAll(new RegExp(r'[^0-9^+^,]'), '');
        foundData.add(e);
      }
    }
    return foundData;
  }

  void RefreshData() {
    String assembleURL = lottoUrl;
    if (selectedWinStage.isNotEmpty) {
      assembleURL = assembleURL + specificNumberPage + selectedWinStage;
    }
    final data = fetchHTML(assembleURL);
    data.then((value) {
      final splited = value.split(' ');
      final numberList = DataPolishing(splited);
      _dropdownValue = numberList[stageNum];
      if (lottoStageList.isEmpty) {
        for (int i = 1; i <= int.parse(numberList[stageNum]); i++) {
          lottoStageList.insert(0, i.toString());
        }
      }
      lastWinNumber = numberList[winnerLottoNum];
      setState(() {
        _isLoading = false;
        widgetWinStage = Text(_dropdownValue + "회차 1등 번호");
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
    return _isLoading ? Center(child:CircularProgressIndicator()) : Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        widgetWinStage,
        widgetWinNumber,
        widgetWinPrice,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              onChanged: (String newValue) {
                setState(() {
                  _dropdownValue = newValue;
                  selectedWinStage = newValue;
                });
              },
              value: _dropdownValue,
              items:
                  lottoStageList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Text("회차  "),
            FlatButton(
              child: Text("당첨번호 보기"),
              onPressed: () {
                setState((){
                   // setState 에 의해 값을 바꿔줘야만 widget 을 새로 build 한다.
                   // 값만 바꿔주면 widget 에 notify 할 수 없음
                  _isLoading = true;

                });
                RefreshData();
              },
              color: Color.fromRGBO(100, 100, 100, 200),
              splashColor: Colors.cyan,
              focusColor: Colors.indigo,
            ),
          ],
        ),
      ],
    ));
  }
}
