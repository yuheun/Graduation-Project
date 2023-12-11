import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../addGoods/seeMyGul/GulDetailScreen.dart';
import '../firebase/gulItem.dart';

void main() {
  runApp(MaterialApp(
    home: GoodsListScreen(),
  ));
}

class GoodsListScreen extends StatefulWidget {

  @override
  _GoodsListScreenState createState() => _GoodsListScreenState();

}

class _GoodsListScreenState extends State<GoodsListScreen>{

  TextEditingController searchController = TextEditingController();
  List<GulItem> userPostItems = [];
  // 지역구 값
  String? selectedDistrict;

  @override
  void initState() {
    super.initState();
    // Call loadData with the selected district
    loadData();
  }

  Future<void> loadData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // 현재 사용자의 위치 정보를 파이어베이스 Users collection에서 찾음
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(
          currentUser.uid).get();
      var userLocation = userDoc['mylocation'];
      print("user's location: ${userLocation}");

      if (userLocation != null) {
        // PostItems 컬렉션에서 사용자의 위치와 일치하는 문서
        var postItemsQuerySnapshot = await FirebaseFirestore.instance
            .collection('PostItems')
            .where('location', isEqualTo: userLocation)
            .get();


        print("items fetched: ${postItemsQuerySnapshot.docs}");

        var fetchedUserPostItems = <GulItem>[];

        // 'PostItems'의 각 항목에 대하여
        for (var doc in postItemsQuerySnapshot.docs) {
          print("PostItem: ${doc.data()}"); // PostItem 데이터 로깅

          var postItemData = doc.data();

          // 'Mapping' 컬렉션에서 추가 데이터 가져오기
          var mappingSnapshot = await FirebaseFirestore.instance
              .collection('Mapping')
              .where('label_id', isEqualTo: postItemData['label_id'])
              .get();

          // 만약 매핑 데이터가 있으면 'GulItem' 객체 생성
          if (mappingSnapshot.docs.isNotEmpty) {
            // 문서가 존재하면 첫 번째 문서의 데이터를 사용
            var mappingDoc = mappingSnapshot.docs.first;
            print(
                "Mapping data for label_id ${postItemData['label_id']}: ${mappingDoc
                    .data()}");
            var mappingData = mappingDoc.data() as Map<String, dynamic>;

            var gulItem = GulItem(
              label_id: postItemData['label_id'],
              image_url: postItemData['image_url'],
              description: postItemData['description'],
              location: postItemData['location'],
              category: mappingData['category'] ?? 'Unknown',
              // 기본값 설정
              subcategory: mappingData['subcategory'] ?? 'Unknown',
              type: mappingData['type'] ?? 'Unknown',
              yolo_label: mappingData['yolo_label'] ?? 'Unknown',
            );
            fetchedUserPostItems.add(gulItem);
          } else {
            print(
                "No mapping data found for label_id ${postItemData['label_id']}");
          }
        }

        // 상태 업데이트
        setState(() {
          userPostItems = fetchedUserPostItems;
        });
      } else {
        print('No district selected.');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('우리 동네 분실물 목록',
            style: TextStyle(fontSize: 20,
              fontWeight: FontWeight.w700,)
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: (){
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
              itemCount: userPostItems.length,
              itemBuilder: (context, index) {
                return _buildGulItem(userPostItems[index]);
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
                      '특징: ${_truncateString(gulItem.description, 8)}',
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

  String _truncateString(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength - 3) + '...';
    }
  }

}


