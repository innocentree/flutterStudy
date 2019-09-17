// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/*
 * github remote 연결하기
 * 1. github 에 repository 만든다
 * 2. vscode 터미널에서 git remode add origin 주소 입력
 * 3. vscode 좌측 하단 master 라고 적힌 오른쪽에 클라우드 마크 누름
 * 4. github 로그인창 나오면 로그인
 * 5. 로컬에 commit 된 내용들이 push 된다.
*/
import 'package:flutter/material.dart';
//import 'HomePage.dart';
import 'LottoHome.dart';

void main() => runApp(MyApp());

//////////////////////////////////////////////////////////////////
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: LottoHome(),
    );
  }
}
