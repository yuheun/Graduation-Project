import 'package:flutter/material.dart';
import 'package:fortest/main.dart';


import 'alarmTap.dart'; // alarmTap.dart 파일
import 'categoryTap.dart'; // categoryTap.dart 파일
import 'login.dart'; // login.dart 파일
import 'searchTap.dart'; // searchTap.dart 파일


void main() {
  runApp(const MaterialApp(
    home: PersonalInfoScreen(),
  ));
}


void goToAnotherPage(BuildContext context, String pageName) {
  // 버튼에 따라 그에 해당하는 파일로 이동
  switch (pageName) {
    case "LoginScreen":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      break;


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


class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('개인정보'),
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

      body: Column(
        children: [
          InkWell(
            onTap: () {
              goToAnotherPage(context, "LoginScreen");
            },
            child: Container(
              width: double.infinity,
              height: 400,
              color: const Color.fromARGB(255, 121, 203, 250),
              child: const Center(
                child: Text(
                  '로그인 해주세요 :)',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),


          const SizedBox(height: 30),


          InkWell(
            onTap: () {
              // '내 게시글 보기' 버튼을 누를 때 실행할 작업
              // 예: goToAnotherPage(context, "MyPosts");
            },
            child: const Row(
              children: [
                SizedBox(width:10),
                Icon(Icons.note, size: 40),
                SizedBox(width: 20),
                Text("내 게시글 보기", style: TextStyle(fontSize: 30)),
              ],
            ),
          ),


          const SizedBox(height: 20),


          InkWell(
            onTap: () {
              // '프로필 수정' 버튼을 누를 때 실행할 작업
              // 예: goToAnotherPage(context, "EditProfile");
            },
            child: const Row(
              children: [
                SizedBox(width:10),
                Icon(Icons.person, size: 40),
                SizedBox(width: 20),
                Text("프로필 수정", style: TextStyle(fontSize: 30)),
              ],
            ),
          ),


          const SizedBox(height: 20),


          InkWell(
            onTap: () {
              // '비밀번호 변경' 버튼을 누를 때 실행할 작업
              // 예: goToAnotherPage(context, "ChangePassword");
            },
            child: const Row(
              children: [
                SizedBox(width:10),
                Icon(Icons.lock, size: 40),
                SizedBox(width: 20),
                Text("비밀번호 변경", style: TextStyle(fontSize: 30)),
              ],
            ),
          ),


          const SizedBox(height: 20),


          InkWell(
            onTap: () {
              // '회원 탈퇴' 버튼을 누를 때 실행할 작업
              // 예: goToAnotherPage(context, "Withdrawal");
            },
            child: const Row(
              children: [
                SizedBox(width:10),
                Icon(Icons.account_circle, size: 40),
                SizedBox(width: 20),
                Text("회원 탈퇴", style: TextStyle(fontSize: 30)),
              ],
            ),
          ),
        ],
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
