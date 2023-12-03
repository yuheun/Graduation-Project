import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fortest/main.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'alarmTap.dart'; // alarmTap.dart
import 'categoryTap.dart'; // categoryTap.dart 파일
import 'join.dart';
import 'searchTap.dart';




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

class LoginSuccessScreen extends StatefulWidget {
  const LoginSuccessScreen({super.key});

  @override
  _LoginSuccessScreenState createState() => _LoginSuccessScreenState();
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


class _LoginSuccessScreenState extends State<LoginSuccessScreen> {
  UserData userData =
  UserData(name: '',
      email: '',
      nickname: '',
      profileImgUrl: '');

  final picker = ImagePicker();

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
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);


      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);

        // Firebase Storage에 업로드
        try {
          // 사용자 ID 가져오기
          String userId = FirebaseAuth.instance.currentUser!.uid;
          firebase_storage.Reference ref = firebase_storage.FirebaseStorage
              .instance
              .ref('userProfileImages/$userId');

          // 파일 업로드
          firebase_storage.UploadTask uploadTask = ref.putFile(imageFile);

          // 업로드 완료 대기
          await uploadTask.whenComplete(() async {
            // 업로드된 이미지의 URL 가져오기
            String downloadURL = await ref.getDownloadURL();

            // Firestore에 이미지 URL 업데이트
            await FirebaseFirestore.instance.collection('users')
                .doc(userId)
                .update({
              'profileImgUrl': downloadURL,
            });

            // 상태 업데이트
            // 앱 상태 업데이트
            setState(() {
              userData.profileImgUrl = downloadURL;
            });
          });
        } catch (e) {
          // 오류 처리
          print(e);
        }
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인 성공'),
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          CircleAvatar(
          radius: 50,
          backgroundImage: (userData.profileImgUrl != null && userData.profileImgUrl!.isNotEmpty)
              ? NetworkImage(userData.profileImgUrl!)
              : AssetImage('assets/image/default_image.png') as ImageProvider<Object>,
          ),
            SizedBox(height: 20.0),
            // 갤러리에서 사진 고르기 버튼
            ElevatedButton(
              onPressed: _pickImageFromGallery,
              child: Text('갤러리에서 사진 고르기'),
            ),

            SizedBox(height: 20.0),

            Text(
              '${userData.nickname ?? "사용자"} 님 환영합니다!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('홈으로'),
            ),
          ],
        ),
      ),


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
}