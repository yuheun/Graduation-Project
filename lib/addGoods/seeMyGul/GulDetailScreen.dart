import 'package:flutter/material.dart';
import '../../mainScreen/gulItem.dart';
import '../../mainScreen/goodsList.dart';
import '../../navigationBar/alarmTap.dart'; // alarmTap.dart 파일
import '../../navigationBar/categoryTap.dart'; // categoryTap.dart 파일
import '../../main.dart';
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

class GulDetailScreen extends StatelessWidget {
  final GulItem gulItem;

  const GulDetailScreen({required this.gulItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글 상세 정보'),
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
              gulItem.imagePath,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Text('종류: ${gulItem.item}'),
            Text('대분류: ${gulItem.selectedCategory}'),
            Text('특징: ${gulItem.features}'),
          ],
        ),
      ),
    );
  }
}
