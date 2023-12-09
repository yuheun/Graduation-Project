import 'package:flutter/material.dart';
import '../../firebase/gulItem.dart';
import '../../main.dart';

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
                MaterialPageRoute(builder: (context) => const MyAppPage()),
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
            Text('종류: ${gulItem.category}'),
            Text('중분류: ${gulItem.subcategory}'),
            Text('특징: ${gulItem.yolo_label}'),
          ],
        ),
      ),
    );
  }
}
