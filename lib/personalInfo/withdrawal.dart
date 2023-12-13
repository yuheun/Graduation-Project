// 176번째 줄에 회원탈퇴 로직 만들어주면 될거같아!

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'join.dart';

void main() {
  runApp(const MaterialApp(
    home: WithdrawalScreen(),
  ));
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

class WithdrawalScreen extends StatefulWidget{
  const WithdrawalScreen({Key? key}) : super(key:key);

  @override
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {

  UserData userData =
  UserData(name: '',
      email: '',
      nickname: '',
      profileImgUrl: '',
      password: '');
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser);
    if (currentUser != null) {
      try {
        // Set a timeout for the data loading process
        const timeout = Duration(seconds: 10);
        DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get()
            .timeout(timeout);

        print("Loaded user data: ${userDataSnapshot.data()}");
        setState(() {
          userData = UserData(
            name: userDataSnapshot['username'],
            email: currentUser.email ?? '',
            nickname: userDataSnapshot['nickname'],
            profileImgUrl: userDataSnapshot['profileImgUrl'],
            password: '',
          );
          isLoading = false;
        });
      } catch (e) {
        // Handle timeout or other errors
        print("Error loading user data: $e");
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '회원 탈퇴',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),


      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0), // Adjust the padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(userData.profileImgUrl!),
            ),
            const SizedBox(height: 10),
            Text(
              "ID: ${userData.nickname}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '이메일 주소: ${userData.email}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),


            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              '탈퇴하시겠습니까?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Lost&Found Vision 계정이 삭제됩니다.\n'
                  '내 모든 콘텐츠와 개인 정보가 영구적으로 삭제되며,\n내 ID로'
                  ' ${userData.nickname}' '을(를) 더 이상 사용할 수 없게 됩니다.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            const Text(
              '탈퇴 전 유의사항',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '계정을 실수로 또는 잘못 탈퇴한 후에도 30일 내에 복구할 수 있으며,'
                  ' 탈퇴 요청을 처리하는 도중에 다시 로그인하면 탈퇴 절차가 중단됩니다.',
              style: TextStyle(
                color: Colors.grey, fontSize: 13
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () {
              // 회원탈퇴 기능 만들어야함
              // 요기!! 만들어주면 돼
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JoinScreen()),
              );
            },
              child: Container(
                //color: Colors. , // Background color for the tappable area
                padding: const EdgeInsets.all(15.0),
                child: const Text(
                  '회원 탈퇴',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Colors.red, // Text color is white
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
