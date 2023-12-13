import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'GulDetailScreen.dart';
import 'package:fortest/firebase/gulItem.dart';

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
              fontWeight: FontWeight.w700,)),
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
        margin: EdgeInsets.all(15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              width: 100,
              height: 100,
              child: Image.network(
                gulItem.image_url,
                fit: BoxFit.cover,
              ),
            ),
            // Text
            Expanded(
              child: Padding(
                //padding: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 3),
                    Text(
                      '종류: ${gulItem.type}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      '대분류: ${gulItem.category}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      '특징: ${_truncateString(gulItem.yolo_label, 8)}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 특징 부분 값이 너무 길면 나머지는 ... 으로 대체
  String _truncateString(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength - 3) + '...';
    }
  }


}

