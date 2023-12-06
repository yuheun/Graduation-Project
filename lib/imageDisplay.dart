// 글 작성하는 화면!
// 이거 파베로 넘기면 될거 같음
// 일단 코드 짜두긴 했는데 이게 이렇게 하는게 맞나..


import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'alarmTap.dart'; // alarmTap.dart 파일
import 'categoryTap.dart'; // categoryTap.dart 파일
import 'imsi_gul.dart';
import 'searchTap.dart'; // searchTap.dart 파일

void main() {
  runApp(const MaterialApp(
    home: ImageDisplayScreen(imagePath: '',),
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

class ImageDisplayScreen extends StatefulWidget {
  final String imagePath;
  const ImageDisplayScreen({required this.imagePath});

  @override
  _ImageDisplayScreenState createState() => _ImageDisplayScreenState();
}

class UserData {
  String name;
  String email;
  String nickname;
  String? profileImgUrl;

  UserData(
      {required this.name,
        required this.email,
        required this.nickname,
        required this.profileImgUrl,
      });
}


class _ImageDisplayScreenState extends State<ImageDisplayScreen> {

  UserData userData =
  UserData(name: '',
      email: '',
      nickname: '',
      profileImgUrl: '');


  String item = '';
  String selectedCategory = '전자기기'; // To store the selected category value
  // Define the available categories
  List<String> categories = ['전자기기', '악세사리', '기타'];
  String features = '';


  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser);
    if (currentUser != null) {
      DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      print("Loaded user data: ${userDataSnapshot.data()}");
      setState(() {
        userData = UserData(
          name: userDataSnapshot['username'],
          email: currentUser.email ?? '',
          nickname: userDataSnapshot['nickname'],
          profileImgUrl: userDataSnapshot['profileImgUrl'],
        );
      });
    }
  }


  void uploadDataToFirestore() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Firestore 'posts' 컬렉션에 데이터 추가
        await FirebaseFirestore.instance.collection('posts').add({
          'user_id': currentUser.uid,
          'image_url': widget.imagePath,
          'item': item,
          'category': selectedCategory,
          'features': features,
          // 기타 필요한 데이터 추가
        });
      }
    } catch (e) {
      print('Error uploading data to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('글 작성',
            style: TextStyle(fontSize: 25, fontFamily: 'HakgyoansimDoldam', fontWeight: FontWeight.w600,)
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(
              File(widget.imagePath),
              width: 400,
              height: 400,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildInputField('종류', item),
                  buildCategoryDropdown(), // Added the category dropdown
                  buildInputField('특징', features),

                  SizedBox(height: 7),

                  ElevatedButton(
                    onPressed: () {
                      uploadDataToFirestore();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImsiGulScreen(
                            imagePath: widget.imagePath,
                            item: item,
                            selectedCategory: selectedCategory,
                            features: features,
                          ),
                        ),
                      );
                    },
                    child: Text('작성'),
                  ),

                ],
              ),
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

  Widget buildCategoryDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('대분류:', style: TextStyle(fontSize: 20,
            fontFamily: 'HakgyoansimDoldam',
            fontWeight: FontWeight.w700,)),
          SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget buildInputField(String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text('$label:', style: TextStyle(fontSize: 20,
            fontFamily: 'HakgyoansimDoldam',
            fontWeight: FontWeight.w700,)),
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              style: TextStyle(fontSize: 20,
                  fontFamily: 'HakgyoansimDoldam',
                  fontWeight: FontWeight.w700,),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
              ),
              onChanged: (newValue) {
                setState(() {
                  switch (label) {
                    case '종류':
                      item = newValue;
                      break;
                    // case '대분류':
                    //   category = newValue;
                    //   break;
                    case '특징':
                      features = newValue;
                      break;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }

}


