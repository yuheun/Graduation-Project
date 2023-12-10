import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login/login.dart';


void main() {
  runApp(const MaterialApp(
    home: JoinScreen(),
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

  }
}


class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  _JoinScreenState createState() => _JoinScreenState();
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


class _JoinScreenState extends State<JoinScreen> {
  UserData userData =
  UserData(name: '',
      password: '',
      email: '',
      nickname: '',
      profileImgUrl: '');


  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmationController = TextEditingController();
  bool _isMatching = false; // 초기값 false


  void checkPasswordMatch() {
    final isMatching =
        _passwordController.text == _confirmationController.text &&
            _passwordController.text.isNotEmpty;
    setState(() {
      _isMatching = isMatching; // _isMatching 값을 true 또는 false로 설정
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입',
            style: TextStyle(fontSize: 25,
              fontWeight: FontWeight.w700,)
        ),
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
    child: Center(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Image.asset(
              'assets/image/logo.png', // Update the path accordingly
              height: 200, // Set the height of the image
            ),
            const SizedBox(height: 20),
            buildTextField("이름", "입력해주세요", userData.name),
            buildPasswordField("PW", "입력해주세요", userData.password),
            buildPasswordConfirmationField("PW 확인", "입력해주세요"),
            buildTextField("이메일", "입력해주세요", userData.email),
            buildTextField("닉네임", "입력해주세요", userData.nickname, "중복확인"),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                performSignUp(userData, context);
                //로그인 화면으로 넘어가기
                goToAnotherPage(context, "LoginScreen");
              },
              child: const Text('회원가입', style: TextStyle(fontSize: 23,
                fontWeight: FontWeight.w700,)),
            ),
          ],
        ),
      ),

    ));
  }


  Widget buildTextField(String label, String hint, String value,
      [String actionText = '']) {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(label, style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.w700,)),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: TextField(
                decoration: InputDecoration(hintText: hint,
                    hintStyle: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.w700,)
                ),
                controller: TextEditingController(text: value),
                onChanged: (text) {
                  //Update in UserData
                  switch (label) {
                    case "이름":
                      userData.name = text;
                      break;
                    case "이메일":
                      userData.email = text;
                      break;
                    case "닉네임":
                      userData.nickname = text;
                  }
                }),
          ),
          if (actionText.isNotEmpty)
            TextButton(
              onPressed: () {
                // 해당 버튼을 누를 때 실행할 작업
                // 예: checkDuplication();
              },
              child: Text(actionText, style: TextStyle(fontSize: 15,
                fontWeight: FontWeight.w700,),
              ),
            ),
        ],
      ),
    );
  }


  Widget buildPasswordField(String label, String hint, String value) {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          SizedBox(width: 70, child: Text(label,
              style: TextStyle(fontSize: 18,
                fontWeight: FontWeight.w700,)
          )),
          const SizedBox(width: 10),
          Flexible(
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: hint,
                  hintStyle: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.w700,
                  )
              ),
              controller: _passwordController,
              // 비밀번호 필드에 _passwordController 사용
              onChanged: (text) {
                switch (label) {
                  case "PW":
                    userData.password = text;
                }
              },
            ),
          ),
        ],
      ),
    );
  }


  Widget buildPasswordConfirmationField(String label, String hint) {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          SizedBox(width: 70, child: Text(label,
              style: TextStyle(fontSize: 14,
                fontWeight: FontWeight.w700,)
          )
          ),
          const SizedBox(width: 10),
          Flexible(
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: hint,
                hintStyle: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              controller: _confirmationController,
              onChanged: (_) {
                checkPasswordMatch();
              },
            ),
          ),
          Builder(
            builder: (context) {
              if (_isMatching == true) {
                return const Icon(Icons.check, color: Colors.green);
              } else if (_isMatching == false) {
                return const Icon(Icons.close, color: Colors.red);
              } else {
                return const SizedBox(); // 아무것도 표시 X
              }
            },
          ),
        ],
      ),
    );
  }


  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase 사용자 등록 함수
  Future<void> registerUser(String email, String password, String username, String nickname) async {
    // Firebase Authentication을 사용하여 사용자 등록
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    // profileImgUrl이 null이면 기본 이미지로 경로 연결
    // String finalProfileImgUrl = profileImgUrl ?? '기본_이미지_URL';

    // Firestore에 사용자 정보 저장
    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'email': email,
      'username': username,
      'nickname': nickname,
      // 'profile_img': finalProfileImgUrl,
    });
  }

  void performSignUp(UserData userData, BuildContext context) async {
    List<String> emptyFields = [];

    if (userData.name.isEmpty) {
      emptyFields.add('이름');
    }
    if (userData.password.isEmpty) {
      emptyFields.add('PW');
    }
    if (userData.email.isEmpty) {
      emptyFields.add('이메일');
    }
    if (userData.nickname.isEmpty) {
      emptyFields.add('닉네임');
    }

    if (_passwordController.text != _confirmationController.text) {
      // Passwords do not match
      emptyFields.add('Password 확인 오류');
    }


    if (emptyFields.isNotEmpty) {
      // Display a pop-up or snackbar indicating the missing information.
      String message = '다음 필드를 입력해주세요:\n${emptyFields.join(', ')}';
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('입력 오류',
                style: TextStyle(fontSize: 30,
                  fontWeight: FontWeight.w700,)
            ),
            content: Text(message,
                style: TextStyle(fontSize: 20,
                  fontWeight: FontWeight.w700,)
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('확인',
                    style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.w700,)),
              ),
            ],
          );
        },
      );
    } else {
      try {
        // 모든 필드가 유효한 경우 사용자 등록
        await registerUser(
            userData.email,
            userData.password,
            userData.name,
            userData.nickname,
            // userData.profileImgUrl ?? '기본_이미지_URL'
          // 프로필 이미지 URL이 null일 경우 기본 이미지 URL 사용
        );
      } catch (e) {
        // Firebase 사용자 등록 중 오류 발생 시 처리
        print(e); // 오류 로깅
      }
    }
  }
}
