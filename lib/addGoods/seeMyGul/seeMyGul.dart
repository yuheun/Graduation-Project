//
// 글 리스트 받는거 파베랑 연결시켜서 하면 될거 같은데 음음
//

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'GulDetailScreen.dart';
import '../../firebase/gulItem.dart';
import '../../navigationBar/alarmTap.dart'; // alarmTap.dart 파일
import '../../navigationBar/categoryTap.dart'; // categoryTap.dart 파일
import '../../navigationBar/searchTap.dart'; //

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
  final String user_email; // 현재 사용자의 이메일을 저장하는 변수

  const SeeMyGulScreen({
    Key? key,
    required this.user_email
  }) : super(key: key);

  @override
  _SeeMyGulScreenState createState() => _SeeMyGulScreenState();
}

class _SeeMyGulScreenState extends State<SeeMyGulScreen> {
  late List<GulItem> gulItems = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      var postItemsSnapshot = await FirebaseFirestore.instance
          .collection('PostItems')
          .where('email', isEqualTo: widget.user_email)
          .get();
      print('user_email: ${widget.user_email}');

      List<GulItem> newFetchedPostItems = [];
      for (var doc in postItemsSnapshot.docs) {
        var postItemData = doc.data();
        var mappingDocSnapshot = await FirebaseFirestore.instance
            .collection('Mapping')
            .where('label_id', isEqualTo: postItemData['label_id'])
            .get();

        // 만약 매핑 데이터가 있으면 'GulItem' 객체 생성
        if (mappingDocSnapshot.docs.isNotEmpty) {
          // 문서가 존재하면 첫 번째 문서의 데이터를 사용
          var mappingDoc = mappingDocSnapshot.docs.first;
          print("Mapping data for label_id ${postItemData['label_id']}: ${mappingDoc.data()}");
          var mappingData = mappingDoc.data();

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

      setState(() {
        gulItems = newFetchedPostItems;
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

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
              itemCount: gulItems.length,
              itemBuilder: (context, index) {
                return _buildGulItem(gulItems[index]);
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

