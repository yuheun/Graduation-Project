import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../addGoods/seeMyGul/GulDetailScreen.dart';
import '../firebase/gulItem.dart';
import '../navigationBar/alarmTap.dart'; // alarmTap.dart 파일
import '../navigationBar/categoryTap.dart'; // categoryTap.dart 파일
import '../navigationBar/searchTap.dart'; // searchTap.dart 파일

void main() {
  runApp(MaterialApp(
    home: GoodsListScreen(),
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

  @override
  _GoodsListScreenState createState() => _GoodsListScreenState();

}

class _GoodsListScreenState extends State<GoodsListScreen>{

  List<GulItem> postItems = [];
  List<GulItem> filteredItems = []; // 선택된 location
  Map<String, GulItem> mappingData = {};
  TextEditingController searchController = TextEditingController();

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
      print("fetchItems started");
      print("widget.markerText: $selectedDistrict"); // selectedDistrict 출력

      if (selectedDistrict != null) {
        final postItemsQuerySnapshot = await FirebaseFirestore.instance
            .collection('PostItems')
            .where('location', isEqualTo: selectedDistrict)
            .get();

        print("items fetched: ${postItemsQuerySnapshot.docs}");

        List<GulItem> newFetchedPostItems = [];

        // 'PostItems'의 각 항목에 대하여
        for (var doc in postItemsQuerySnapshot.docs) {
          print("PostItem: ${doc.data()}"); // PostItem 데이터 로깅

          var postItemData = doc.data() as Map<String, dynamic>;

          // 'Mapping' 컬렉션에서 추가 데이터 가져오기
          var mappingDocSnapshot = await FirebaseFirestore.instance
              .collection('Mapping')
              .where('label_id', isEqualTo: postItemData['label_id'])
              .get();

          // 만약 매핑 데이터가 있으면 'GulItem' 객체 생성
          if (mappingDocSnapshot.docs.isNotEmpty) {
            // 문서가 존재하면 첫 번째 문서의 데이터를 사용
            var mappingDoc = mappingDocSnapshot.docs.first;
            print("Mapping data for label_id ${postItemData['label_id']}: ${mappingDoc.data()}");
            var mappingData = mappingDoc.data() as Map<String, dynamic>;

            var gulItem = GulItem(
              label_id: postItemData['label_id'],
              image_url: postItemData['image_url'],
              description: postItemData['description'],
              location: postItemData['location'],
              category: mappingData['category'] ?? 'Unknown', // 기본값 설정
              subcategory: mappingData['subcategory'] ?? 'Unknown',
              type: mappingData['type'] ?? 'Unknown',
              yolo_label: mappingData['yolo_label'] ?? 'Unknown',
            );
            newFetchedPostItems.add(gulItem);
          } else {
            print("No mapping data found for label_id ${postItemData['label_id']}");
          }
        }

        // 상태 업데이트
        setState(() {
          postItems = newFetchedPostItems;
          filteredItems = List.from(newFetchedPostItems);
        });
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
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return _buildGulItem(filteredItems[index]);
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
                  '특징: ${_truncateString(gulItem.yolo_label, 10)}!',
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


