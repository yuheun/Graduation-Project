import 'package:flutter/material.dart';
import 'package:fortest/navigationBar/searchTap.dart';
import 'package:fortest/main.dart';
import '../navigationBar/alarmTap.dart';
import '../navigationBar/categoryTap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fortest/mainScreen/gulItem.dart';

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


class seeGuDetailScreen extends StatelessWidget{

  final List<GulItem> items;
  final List<GulItem> filteredItems;
  final GulItem gulItem;

  seeGuDetailScreen({
    required this.items,
    required this.filteredItems,
    required this.gulItem,
  });

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('지역구 특정글 상세 정보'),
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
            // Display the details of the selected GulItem
            Image.network(
              gulItem.image_url,
              width: 400,
              height: 400,
              fit: BoxFit.cover,
            ),
            Text('종류: ${gulItem.subcategory}'),
            Text('대분류: ${gulItem.category}'),
            Text('특징: ${gulItem.yolo_label}'),
          ],
        ),
      ),
    );
  }
}
