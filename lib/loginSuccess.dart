import 'package:flutter/material.dart';
import 'login.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fortest/main.dart';

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

  String password;
  String email;
  String nickname;
  String? profileImgUrl;

  UserData(
      {required this.name,
        required this.password,
        required this.email,
        required this.nickname,
        required this.profileImgUrl,
      });
}


class _LoginSuccessScreenState extends State<LoginSuccessScreen> {
  UserData userData =
  UserData(name: '',
      password: '',
      email: '',
      nickname: '',
      profileImgUrl: '');

  final picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        userData.profileImgUrl = File(pickedFile.path) as String?;
      }
    });
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
            // 프로필 사진 위젯
            userData.profileImgUrl != null
                ? CircleAvatar(
              radius: 50,
              backgroundImage: FileImage(userData.profileImgUrl! as File),
            )
                : Container(), // 프로필 사진이 없으면 빈 컨테이너
            SizedBox(height: 20.0),
            // 갤러리에서 사진 고르기 버튼
            ElevatedButton(
              onPressed: _pickImageFromGallery,
              child: Text('갤러리에서 사진 고르기'),
            ),

            SizedBox(height: 20.0),

            // OOO님 환영합니다~~
            Text(
              '${userData.name}(${userData.nickname}) 님 환영합니다!',
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