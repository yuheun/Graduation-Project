//
// 글 리스트 받는거 파베랑 연결시켜서 하면 될거 같은데 음음
//

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fortest/main.dart';

import 'alarmTap.dart'; // alarmTap.dart 파일
import 'categoryTap.dart'; // categoryTap.dart 파일
import 'searchTap.dart'; //

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

class SeeMyGulScreen extends StatefulWidget {
  final List<GulItem> gulItems;
  final String imagePath;
  final String item;
  final String selectedCategory;
  final String features;

  const SeeMyGulScreen({
    required this.imagePath,
    required this.item,
    required this.selectedCategory,
    required this.features,
    required this.gulItems,
  });

  @override
  _SeeMyGulScreenState createState() => _SeeMyGulScreenState();
}

class _SeeMyGulScreenState extends State<SeeMyGulScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 글 확인',
            style: TextStyle(fontSize: 20,
              fontFamily: 'HakgyoansimDoldam',
              fontWeight: FontWeight.w700,)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false,
              );
            },
          )
        ],
      ),


      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.gulItems.length,
              itemBuilder: (context, index) {
                return _buildGulItem(widget.gulItems[index]);
              },
            ),
          ],
        ),
      ),

      // 하단 탭바 (카테고리, 검색, 알림)
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "카테고리",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "검색",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "알림",
          ),
        ],
        onTap: (int index) {
          switch (index) {
            case 0: // 카테고리 탭
              goToAnotherPage(context, "CategoryTap");
              break;
            case 1: // 검색 탭
              goToAnotherPage(context, "SearchTap");
              break;
            case 2: // 알림 탭
              goToAnotherPage(context, "AlarmTap");
              break;
          }
        },
      ),
    );
  }

  Widget _buildGulItem(GulItem gulItem) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Image.file(
            gulItem.imagePath as File,
            width: 150,
            height: 150,
          ),
          SizedBox(height: 10),
          Text('종류: ${gulItem.item}!',
              style: TextStyle(fontSize: 15,
            fontFamily: 'HakgyoansimDoldam',
            fontWeight: FontWeight.w500,)
          ),
          Text('대분류: ${gulItem.selectedCategory}!',
              style: TextStyle(fontSize: 15,
                fontFamily: 'HakgyoansimDoldam',
                fontWeight: FontWeight.w500,)
          ),
          Text('특징: ${gulItem.features}!',
              style: TextStyle(fontSize: 15,
                fontFamily: 'HakgyoansimDoldam',
                fontWeight: FontWeight.w500,)
          ),
        ],
      ),
    );
  }
}

class GulItem {
  final String item;
  final String selectedCategory;
  final String features;
  final String imagePath;

  GulItem({
    required this.item,
    required this.selectedCategory,
    required this.features,
    required this.imagePath,
  });
}

