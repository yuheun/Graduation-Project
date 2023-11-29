import 'package:flutter/material.dart';
import 'package:fortest/main.dart';


import 'alarmTap.dart'; // alarmTap.dart 파일
import 'categoryTap.dart'; // categoryTap.dart 파일
import 'imsi_join.dart';
import 'searchTap.dart'; // searchTap.dart 파일


void main() {
  runApp(const MaterialApp(
    home: JoinScreen(),
  ));
}


void goToAnotherPage(BuildContext context, String pageName) {
  // 버튼에 따라 그에 해당하는 파일로 이동
  switch (pageName) {
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


class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  _JoinScreenState createState() => _JoinScreenState();
}


class UserData {
  String name;
  String id;
  String password;
  String email;
  String nickname;
  UserData(
      {required this.name,
        required this.id,
        required this.password,
        required this.email,
        required this.nickname});
}


class _JoinScreenState extends State<JoinScreen> {
  UserData userData =
  UserData(name: '', id: '', password: '', email: '', nickname: '');


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
        title: const Text('회원가입'),
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
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 100),
            buildTextField("이름", "입력해주세요", userData.name),
            buildTextField("ID", "입력해주세요", userData.id, "중복확인"),
            buildPasswordField("PW", "입력해주세요", userData.password),
            buildPasswordConfirmationField("PW 확인", "입력해주세요"),
            buildTextField("이메일", "입력해주세요", userData.email),
            buildTextField("닉네임", "입력해주세요", userData.nickname, "중복확인"),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                performSignUp(userData);
              },
              child: const Text('회원가입', style: TextStyle(fontSize: 25)),
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


  Widget buildTextField(String label, String hint, String value,
      [String actionText = '']) {
    return SizedBox(
      width: 300,
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(label),
          ),
          Flexible(
            child: TextField(
                decoration: InputDecoration(hintText: hint),
                controller: TextEditingController(text: value),
                onChanged: (text) {
                  //Update in UserData
                  switch (label) {
                    case "이름":
                      userData.name = text;
                      break;
                    case "ID":
                      userData.id = text;
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
              child: Text(actionText),
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
          SizedBox(width: 70, child: Text(label)),
          Flexible(
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: hint),
              controller:
              _passwordController, // 비밀번호 필드에 _passwordController 사용
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
          SizedBox(width: 70, child: Text(label)),
          Flexible(
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: hint),
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


  void performSignUp(UserData userData) {
    List<String> emptyFields = [];


    if (userData.name.isEmpty) {
      emptyFields.add('이름');
    }
    if (userData.id.isEmpty) {
      emptyFields.add('ID');
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
      String message = '다음 필드를 입력해주세요: ${emptyFields.join(', ')}';
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('입력 오류'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    } else {
      // Proceed to the next screen if all fields are filled.
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ImsiJoinScreen(userData: userData)),
      );
    }
  }
}
