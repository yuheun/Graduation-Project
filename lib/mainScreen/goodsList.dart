import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../addGoods/seeMyGul/GulDetailScreen.dart';
import 'gulItem.dart';
import '../navigationBar/alarmTap.dart'; // alarmTap.dart 파일
import '../navigationBar/categoryTap.dart'; // categoryTap.dart 파일
import '../navigationBar/searchTap.dart'; // searchTap.dart 파일

void main() {
  runApp(const MaterialApp(
    home: GoodsListScreen(imagePath: '', item: '', selectedCategory: '', features: '', gulItems: [],),
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


class GoodsListScreen extends StatefulWidget {
  //const GoodsListScreen({Key? key}): super(key:key);

  final List<GulItem> gulItems;
  final String imagePath;
  final String item;
  final String selectedCategory;
  final String features;

  const GoodsListScreen({
    required this.imagePath,
    required this.item,
    required this.selectedCategory,
    required this.features,
    required this.gulItems,
  });

  @override
  _GoodsListScreenState createState() => _GoodsListScreenState();

}

class _GoodsListScreenState extends State<GoodsListScreen>{

  late List<GulItem> gulItems;

  // 지역구 값
  String? selectedDistrict;

  @override
  void initState() {
    super.initState();
    // Call loadData with the selected district
    loadData();
  }

  Future<void> loadData() async {
    try {
      if (selectedDistrict != null) {
        // Firebase Firestore의 'gulItems' 컬렉션에서 데이터 가져오기
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('gulItems')
            .where('district', isEqualTo: selectedDistrict) // Add this line to filter by selectedDistrict
            .get();
        //이거 그 해당하는 지역구의 목록만 불러오는 함수인데 이거 이렇게 하는게 맞는지 모르겠다..

        // QuerySnapshot에서 문서(Document)들을 추출하고 List에 저장
        gulItems = querySnapshot.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          return GulItem(
            label_id: data['item'],
            category: data['selectedCategory'],
            yolo_label: data['features'],
            image_url: data['imagePath'],
            description: data['description'],
            location: data['location'],
            subcategory: data['subcategoty'],
            type: data['type'],
          );
        }).toList();

        // setState 호출하여 위젯을 다시 빌드하도록 알림
        setState(() {});
      } else {
        print('No district selected.');
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('우리 동네 분실물 목록',
            style: TextStyle(fontSize: 25,
              fontFamily: 'HakgyoansimDoldam',
              fontWeight: FontWeight.w700,)
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
    return GestureDetector(
      onTap: () {
        // Navigate to the GulDetailScreen and pass the selected GulItem
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GulDetailScreen(gulItem: gulItem),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.all(8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.network(
              gulItem.image_url,
              width: double.infinity,
              height: 30,
              fit: BoxFit.cover,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '종류: ${gulItem.type}!',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'HakgyoansimDoldam',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '대분류: ${gulItem.category}!',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'HakgyoansimDoldam',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  '특징: ${_truncateString(gulItem.description, 10)}!',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: 'HakgyoansimDoldam',
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _truncateString(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength - 3) + '...';
    }
  }

}


