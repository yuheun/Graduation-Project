import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fortest/personalInfo/findPassword.dart';
import 'package:fortest/main.dart';
import 'loginSuccess.dart';
import '../join.dart';

void main() {
  runApp(const MaterialApp(
    home: LoginScreen(),
  ));
}

void goToAnotherPage(BuildContext context, String pageName, {UserData? userData}){
  // 버튼에 따라 그에 해당하는 파일로 이동
  switch(pageName){
    case "JoinScreen":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const JoinScreen()),
      );
      break;

    case "FindPasswordScreen":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FindPasswordScreen()),
      );
      break;

    case "LoginSuccessScreen":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginSuccessScreen(),
        ),
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

class LoginScreen extends StatefulWidget{
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen>{
  UserData? registeredUser; // Store the registered user data

  @override
  Widget build(BuildContext context) {

    TextEditingController idController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    Future<void> login() async {
      String logId = idController.text;
      String logPassword = passwordController.text;

      try {
        // Firebase로 로그인 시도
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: logId, password: logPassword);

        // 로그인 성공
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginSuccessScreen()),
              (Route<dynamic> route) => false,
        );
      } on FirebaseAuthException catch (e) {
        // Firebase 인증 오류
        print('로그인 실패: ${e.message}');
      } catch (e) {
        // 기타 오류
        print('로그인 중 오류 발생: $e');
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인', style: TextStyle(fontSize: 25,
          fontWeight: FontWeight.w600,)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: (){
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 70),
            Image.asset(
              'assets/image/logo.png', // Update the path accordingly
              height: 200, // Set the height of the image
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 200,
              child: TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: 'ID(Email)',
                    labelStyle: TextStyle(fontSize: 25,
                      fontWeight: FontWeight.w700,)
                ),
                maxLines: 1,
              ),
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'PW',
                    labelStyle: TextStyle(fontSize: 25,
                      fontWeight: FontWeight.w700,)
                ),
                maxLines: 1,
                obscureText: true, // Hide the password
              ),
            ),


            const SizedBox(height: 40),


            ElevatedButton(
              onPressed: () {
                // 로그인 함수 호출
                login();
                // loginSuccess.dart로 넘어가기
                if (registeredUser != null) {
                  goToAnotherPage(
                    context,
                    "LoginSuccessScreen",
                    userData: registeredUser
                  );
                }
              },

              child: Container(
                width: 130, height: 50,
                alignment: Alignment.center,
                child: const Text('로그인', style: TextStyle(fontSize: 30,
                  fontWeight: FontWeight.w700,)
                ),
              ),
            ),


            const SizedBox(height: 15),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    goToAnotherPage(context, "JoinScreen");
                  },
                  child: const Text('회원가입', style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline)),
                ),


                const SizedBox(width: 10),


                TextButton(
                  onPressed: () {
                    goToAnotherPage(context, "FindPasswordScreen");
                  },
                  child: const Text('비밀번호 찾기', style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline)),
                ),

              ],
            ),
          ],
        ),
      ),

    )
    );
  }


}
