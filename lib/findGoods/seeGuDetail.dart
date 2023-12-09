import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'package:fortest/firebase/gulItem.dart';

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
              width: 350,
              height: 350,
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
