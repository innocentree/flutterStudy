//import 'package:flutter/foundation.dart';
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
  final eachWinnerPrice = 5;
  final year = 6, month = 7, day = 8;
  final lottoUrl = 'https://www.dhlottery.co.kr/gameResult.do?method=byWin';
  var specificNumberPage = "&drwNo="; // + num 해서 위에거에 붙이면 됨
  String lastWinNumber = "";
  String selectedWinStage = "";
  var lottoStageList = <String>[];
  var fetchingDataList = <String>[];
  var _isLoading1 = false, _isLoading2 = false;
  var accumulatedPrize = "";
  var accumulatedPriod = "";

  String _dropdownValue = '-';
  List<String> dataPolishing(List<String> inData) {
    var foundData = <String>[];
    for (int i = 0; i < inData.length; i++) {
      if (inData[i].contains(new RegExp(r'[0-9]'))) {
        var e = inData[i].replaceAll(new RegExp(r'([^0-9^,^+])?([,]$)?'), '');
        foundData.add(e);
      }
    }
    return foundData;
  }

  void refreshDataLotto() {
    String assembleURL = lottoUrl;
    if (selectedWinStage.isNotEmpty) {
      assembleURL = assembleURL + specificNumberPage + selectedWinStage;
    }
    final data = fetchHTML(assembleURL);
    data.then((value) {
      final splited = value.split(' ');
      fetchingDataList = dataPolishing(splited);
      _dropdownValue = fetchingDataList[stageNum];
      if (lottoStageList.isEmpty) {
        for (int i = 1; i <= int.parse(fetchingDataList[stageNum]); i++) {
          lottoStageList.insert(0, i.toString());
        }
      }
      lastWinNumber = fetchingDataList[winnerLottoNum];
      setState(() {
        _isLoading1 = false;
      });
    });
  }

  void refreshDataNextPrize() {
    /*
          <div class="next_time">
					<h3>다음회차</h3>
					<span class="date">2019-09-22 23:55 현재</span>
					<ul>
						<li><strong>예상당첨금</strong><span>459,530,805<span class="accessibility">원</span></span></li>
						<li><strong>누적판매금</strong><span>1,910,675,000<span class="accessibility">원</span></span></li>
					</ul>
*/
    final data =
        fetchEstimatePrize("https://www.dhlottery.co.kr/common.do?method=main");
    data.then((onValue) {
      if (onValue.isNotEmpty) {
        setState(() {
          accumulatedPriod = onValue[0].replaceAll(new RegExp(r'([^0-9^:^\-^\s])'), '');
          accumulatedPrize = onValue[1].replaceAll(new RegExp(r'([^0-9^,^+])?([,]$)?'), '');
          _isLoading2 = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    refreshDataLotto();
    refreshDataNextPrize();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading1 || _isLoading1
        ? Center(child: CircularProgressIndicator())
        : Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              fetchingDataList.isEmpty
                  ? Text("wait for Data...")
                  : Text(_dropdownValue + "회차 1등 번호"),
              Text("당첨번호 : " +
                  (fetchingDataList.isNotEmpty
                      ? fetchingDataList[winnerLottoNum]
                      : "")),
              fetchingDataList.isEmpty
                  ? ""
                  : Text("당첨일 : " +
                      fetchingDataList[year] +
                      "년 " +
                      fetchingDataList[month] +
                      "월 " +
                      fetchingDataList[day] +
                      "일"),
              fetchingDataList.isEmpty
                  ? Text("")
                  : Text("당첨자 : " + fetchingDataList[winnerCount] + "명"),
              Text("1인당 당첨금액 : " +
                  (fetchingDataList.isNotEmpty
                      ? fetchingDataList[eachWinnerPrice]
                      : "") +
                  "원"),
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
                    items: lottoStageList
                        .map<DropdownMenuItem<String>>((String value) {
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
                      setState(() {
                        // setState 에 의해 값을 바꿔줘야만 widget 을 새로 build 한다.
                        // 값만 바꿔주면 widget 에 notify 할 수 없음
                        _isLoading1 = true;
                      });
                      refreshDataLotto();
                    },
                    color: Color.fromRGBO(100, 100, 100, 200),
                    splashColor: Colors.cyan,
                    focusColor: Colors.indigo,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("이번 주 예상 당첨 금액 : " + accumulatedPrize + "원"),
                  FlatButton(
                    child: Text("데이터 갱신"),
                    onPressed: () {
                      setState(() {
                        _isLoading2 = false;
                      });
                      refreshDataNextPrize();
                    },
                    color: Color.fromRGBO(100, 100, 100, 200),
                    splashColor: Colors.cyan,
                    focusColor: Colors.indigo,
                  )
                ],
              ),
              Text("(" + accumulatedPriod + "현재)"),
            ],
          ));
  }
}
