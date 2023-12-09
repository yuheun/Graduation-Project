import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'login/login.dart';

void main() {
  runApp(const MaterialApp(
    home: FindPasswordScreen(),
  ));
}

void goToAnotherPage(BuildContext context, String pageName){
  // 버튼에 따라 그에 해당하는 파일로 이동
  switch(pageName){

    case "HomeScreen":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      break;

  }
}


class FindPasswordScreen extends StatefulWidget{
  const FindPasswordScreen({super.key});

  @override
  _FindPasswordScreenState createState() => _FindPasswordScreenState();
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

class _FindPasswordScreenState extends State<FindPasswordScreen>{
  UserData? registeredUser; // Store the registered user data

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    TextEditingController idController = TextEditingController();
    TextEditingController passwordController = TextEditingController();


    return Scaffold(
      appBar: AppBar(
        title: const Text('비밀번호 찾기',
            style: TextStyle(fontSize: 25,
              fontFamily: 'HakgyoansimDoldam',
              fontWeight: FontWeight.w700,)
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


      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: SizedBox(
                width:300,
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: '이메일 주소',
                      labelStyle: TextStyle(fontSize: 20,
                        fontFamily: 'HakgyoansimDoldam',
                        fontWeight: FontWeight.w700,)
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16.0),

            ElevatedButton(
              onPressed: () {
                _findPassword();
              },
              child: const Text('비밀번호 찾기',
                  style: TextStyle(fontSize: 20,
                    fontFamily: 'HakgyoansimDoldam',
                    fontWeight: FontWeight.w700,)
              ),
            ),
          ],
        ),
      ),


    );
  }


  void _findPassword() {
    _showPasswordRecoveryMessage();
  }

  void _showPasswordRecoveryMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('이메일 전송 완료',
                    style: TextStyle(fontSize: 30,
                      fontWeight: FontWeight.w500,)
          ),
          content: const Text('비밀번호 찾기 이메일이 전송되었습니다.',
                      style: TextStyle(fontSize: 15,
                        fontWeight: FontWeight.w300,)
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
                );
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }


}
