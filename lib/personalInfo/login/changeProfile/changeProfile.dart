import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'changePassword.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'package:fortest/mainScreen/village.dart';

void main() {
  runApp(const MaterialApp(
    home: ChangeProfileScreen(),
  ));
}


void goToAnotherPage(BuildContext context, String pageName) {
  // 버튼에 따라 그에 해당하는 파일로 이동
  switch (pageName) {

    case "ChangePasswordScreen":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
      );
      break;

    case "VillageScreen":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VillageScreen()),
      );
      break;

  }
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



class ChangeProfileScreen extends StatefulWidget{
  const ChangeProfileScreen({Key? key}) : super(key:key);

  @override
  _ChangeProfileScreenState createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {

  UserData userData =
  UserData(name: '',
      email: '',
      nickname: '',
      profileImgUrl: '',
      password: '');
  bool isLoading = true;

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
        title: const Text('프로필 수정',
            style: TextStyle(fontSize: 25,
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

      body: Column(
        children: [
          InkWell(
            onTap: () {
              goToAnotherPage(context, "LoginScreen");
            },
            child: Container(
              width: double.infinity,
              height: 450,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color.fromARGB(255, 128, 231, 255),
                    Color.fromARGB(230, 135, 246, 210),
                  ],
                ),
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Show loading indicator while data is being fetched
                  isLoading
                      ? CircularProgressIndicator()
                      : Column(
                    children: [
                      CircleAvatar(
                        radius: 150,
                        backgroundImage: (userData.profileImgUrl != null && userData.profileImgUrl!.isNotEmpty)
                            ? NetworkImage(userData.profileImgUrl!)
                            : AssetImage('assets/image/default_image.png') as ImageProvider<Object>,
                      ),
                      SizedBox(height: 20.0),
                      // 갤러리에서 사진 고르기 버튼
                      ElevatedButton(
                        onPressed: _pickImageFromGallery,
                        child: Text('사진 고르기', style: TextStyle(fontSize: 23)),
                      ),
                      const SizedBox(height: 13),


                    ],
                  ),
                ],
              ),
            ),

          ),
          const SizedBox(height: 30),

            InkWell(
              onTap: () {
                goToAnotherPage(context, "ChangePasswordScreen");
              },
              child: const Row(
                children: [
                  SizedBox(width:10),
                  Icon(Icons.lock, size: 40),
                  SizedBox(width: 20),
                  Text("비밀번호 변경", style: TextStyle(fontSize: 32,
                    fontWeight: FontWeight.w700,)
                  ),
                ],
              ),
            ),


          const SizedBox(height: 20),

            InkWell(
              onTap: () {
                goToAnotherPage(context, "VillageScreen");
              },
              child: const Row(
                children: [
                  SizedBox(width:10),
                  Icon( Icons.location_on, size: 40),
                  SizedBox(width: 20),
                  Text("지역구 설정", style: TextStyle(fontSize: 32,
                    fontWeight: FontWeight.w700,)),
                ],
              ),
            ),

          const SizedBox(height: 20),

        ],
      ),

    );
  }
}
