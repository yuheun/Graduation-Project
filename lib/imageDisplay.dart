import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fortest/main.dart';

import 'alarmTap.dart'; // alarmTap.dart 파일
import 'categoryTap.dart'; // categoryTap.dart 파일
import 'searchTap.dart'; // searchTap.dart 파일

void main() {
  runApp(const MaterialApp(
    home: ImageDisplayScreen(imagePath: '',),
  ));
}

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


// 데이터베이스랑 연결
class DatabaseService {
  Future<String> getItemFromDatabase() async {
    // Replace this with actual database retrieval logic
    // For example, using sqflite or making an HTTP request
    await Future.delayed(Duration(seconds: 1));
    return 'Database Item'; // Replace this with the actual value from the database
  }

  Future<String> getFeaturesFromDatabase() async {
    // Replace this with actual database retrieval logic
    // For example, using sqflite or making an HTTP request
    await Future.delayed(Duration(seconds: 1));
    return 'Database Features'; // Replace this with the actual value from the database
  }
}



class ImageDisplayScreen extends StatefulWidget {
  final String imagePath;
  const ImageDisplayScreen({required this.imagePath});

  @override
  _ImageDisplayScreenState createState() => _ImageDisplayScreenState();
}

class _ImageDisplayScreenState extends State<ImageDisplayScreen> {

  String item = '';
  String selectedCategory = '전자기기'; // To store the selected category value
  // Define the available categories
  List<String> categories = ['전자기기', '악세사리', '기타'];
  String features = '';


  // Create an instance of the DatabaseService
  final DatabaseService databaseService = DatabaseService();

  @override
  void initState() {
    super.initState();
    // Load data from the database when the widget initializes
    loadDataFromDatabase();
  }

  Future<void> loadDataFromDatabase() async {
    // Retrieve item and features from the database
    String itemData = await databaseService.getItemFromDatabase();
    String featuresData = await databaseService.getFeaturesFromDatabase();

    // Update the state with the retrieved data
    setState(() {
      item = itemData;
      features = featuresData;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이미지 확인',
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


      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(
              File(widget.imagePath),
              width: 400,
              height: 400,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildInputField('종류', item),
                  buildCategoryDropdown(), // Added the category dropdown
                  buildInputField('특징', features),
                ],
              ),
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

  Widget buildCategoryDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('대분류:', style: TextStyle(fontSize: 20,
            fontFamily: 'HakgyoansimDoldam',
            fontWeight: FontWeight.w700,)),
          SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputField(String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text('$label:', style: TextStyle(fontSize: 20,
            fontFamily: 'HakgyoansimDoldam',
            fontWeight: FontWeight.w700,)),
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              style: TextStyle(fontSize: 20,
                  fontFamily: 'HakgyoansimDoldam',
                  fontWeight: FontWeight.w700,),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
              ),
              onChanged: (newValue) {
                setState(() {
                  switch (label) {
                    case '종류':
                      item = newValue;
                      break;
                    // case '대분류':
                    //   category = newValue;
                    //   break;
                    case '특징':
                      features = newValue;
                      break;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

}


