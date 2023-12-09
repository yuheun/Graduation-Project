import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import '../firebase/gulItem.dart';
import 'seeMyGul/seeMyGul.dart';

class ImsiGulScreen extends StatefulWidget {

  @override
  _ImsiGulScreenState createState() => _ImsiGulScreenState();
}

class _ImsiGulScreenState extends State<ImsiGulScreen> {
  List<GulItem> userPosts = [];
  List<GulItem> filteredPosts = [];

  @override
  void initState() {
    super.initState();
    fetchUserPosts();
  }

  Future<void> fetchUserPosts() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    print("fetchItems started");

    if (currentUser != null) {
      print('email ${currentUser.email}');
      // 사용자 email이랑 post 테이블 email 같은 경우
      var postItemsSnapshot = await FirebaseFirestore.instance
          .collection('PostItems')
          .where('email', isEqualTo: currentUser.email)
          .get();

      print("items fetched: ${postItemsSnapshot.docs}");

      List<GulItem> fetchedUserPosts = [];

      for (var doc in postItemsSnapshot.docs) {
        print("PostItem: ${doc.data()}");

        var postItemData = doc.data();

        // 'Mapping' 컬렉션에서 추가 데이터 가져오기
        var mappingDocSnapshot = await FirebaseFirestore.instance
            .collection('Mapping')
            .where('label_id', isEqualTo: postItemData['label_id'])
            .get();

        if (mappingDocSnapshot.docs.isNotEmpty) {
          var mappingDoc = mappingDocSnapshot.docs.first;
          print("Mapping data for label_id ${postItemData['label_id']}: ${mappingDoc.data()}");
          var mappingData = mappingDoc.data();

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
          fetchedUserPosts.add(gulItem);
        } else {
          print("No mapping data found for label_id ${postItemData['label_id']}");
        }
      }

      setState(() {
        userPosts = fetchedUserPosts;
        filteredPosts = List.from(fetchedUserPosts);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('작성한 글 확인',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w600,)
        ),
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

      body: filteredPosts.isEmpty
          ? Center(child: Text('게시글이 없습니다.'))
          : ListView.builder(
        itemCount: filteredPosts.length,
        itemBuilder: (context, index) {
          GulItem post = filteredPosts[index];
          return Card(
            child: Column(
              children: [
                Image.network(
                  post.image_url,
                  width: 400,
                  height: 400,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
                Text('종류: ${post.type}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    )
                ),
                Text('대분류: ${post.category}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    )
                ),
                Text('특징: ${post.yolo_label}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    )
                ),
                ElevatedButton(
                  onPressed: () {
                    // 현재 로그인한 사용자의 이메일 주소를 가져오기
                    String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SeeMyGulScreen(user_email: userEmail,
                              // Pass the data to SeeMyGulScreen

                            ),
                      ),
                    );
                  },
                  child: Text('내 게시글 보기'),
                ),

              ],
            ),
          );
        },
      ),


    );
  }
}