//
// 카테고리탭에서 버튼 누르면 넘어가는 화면(전자기기)
//

import 'package:flutter/material.dart';
import 'package:fortest/navigationBar/searchTap.dart';
import 'package:fortest/main.dart';
import '../alarmTap.dart';
import '../categoryTap.dart';

void goToAnotherPage(BuildContext context, String pageName){
  // 버튼에 따라 그에 해당하는 파일로 이동
  switch(pageName){
    case "CategoryTap":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CategoryTapScreen()),
      );
      break;


    case "SearchTap":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchTapScreen()),
      );
      break;


    case "AlarmTap":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AlarmTapScreen()),
      );
      break;
  }
}


class ListElectronics extends StatelessWidget{
  const ListElectronics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return const Scaffold(
        body: Center(
          child: Text('전자기기 목록 페이지'),
        )
    );
  }
}