import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'seeMyGul/seeMyGul.dart';

import '../navigationBar/alarmTap.dart'; // alarmTap.dart 파일
import '../navigationBar/categoryTap.dart'; // categoryTap.dart 파일
import '../navigationBar/searchTap.dart'; // searchTap.dart 파일


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


class ImsiGulScreen extends StatelessWidget {
  final String imagePath;
  final String item;
  final String selectedCategory;
  final String features;

  const ImsiGulScreen({
    required this.imagePath,
    required this.item,
    required this.selectedCategory,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('작성한 글 확인',
            style: TextStyle(fontSize: 25, fontFamily: 'HakgyoansimDoldam', fontWeight: FontWeight.w600,)
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: (){
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false,
              );
            },
          )
        ],
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.file(
            File(imagePath),
            width: 400,
            height: 400,
          ),

          SizedBox(height: 10),

          Text('종류: $item', style: TextStyle(fontSize: 20,
            fontFamily: 'HakgyoansimDoldam',
            fontWeight: FontWeight.w700,)
          ),
          Text('대분류: $selectedCategory', style: TextStyle(fontSize: 20,
            fontFamily: 'HakgyoansimDoldam',
            fontWeight: FontWeight.w700,)
          ),
          Text('특징: $features', style: TextStyle(fontSize: 20,
            fontFamily: 'HakgyoansimDoldam',
            fontWeight: FontWeight.w700,)
          ),

          SizedBox(height:10),

          ElevatedButton(
            onPressed: () {

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SeeMyGulScreen(
                    // Pass the data to SeeMyGulScreen
                    imagePath: imagePath,
                    item: item,
                    selectedCategory: selectedCategory,
                    features: features, gulItems: [],
                  ),
                ),
              );
            },
            child: Text('내 게시글 보기'),
          ),

        ],
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
}