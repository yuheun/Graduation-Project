import 'package:flutter/material.dart';
import 'package:fortest/findPassword.dart';
import 'package:fortest/main.dart';
import 'loginSuccess.dart';
import 'alarmTap.dart'; // alarmTap.dart
import 'categoryTap.dart'; // categoryTap.dart 파일
import 'join.dart';
import 'searchTap.dart'; // searchTap.dart 파일


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

    void login() {
      String logId = idController.text;
      String logPassword = passwordController.text;

      if (registeredUser != null &&
          logId == registeredUser!.email &&
          logPassword == registeredUser!.password) {
        // Navigate to the home screen or any other screen upon successful login
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route<dynamic> route) => false,
        );
      } else {
        // Display an error message or handle unsuccessful login
        print("Invalid ID or password");
      }
    }




    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인', style: TextStyle(fontSize: 25,
          fontFamily: 'HakgyoansimDoldam',
          fontWeight: FontWeight.w600,)),
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


      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                controller: idController,
                decoration: const InputDecoration(labelText: 'ID(Email)',
                    labelStyle: TextStyle(fontSize: 25,
                      fontFamily: 'HakgyoansimDoldam',
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
                      fontFamily: 'HakgyoansimDoldam',
                      fontWeight: FontWeight.w700,)
                ),
                maxLines: 1,
                obscureText: true, // Hide the password
              ),
            ),


            const SizedBox(height: 50),


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
                width: 150, height: 50,
                alignment: Alignment.center,
                child: const Text('로그인', style: TextStyle(fontSize: 32,
                  fontFamily: 'HakgyoansimDoldam',
                  fontWeight: FontWeight.w700,)
                ),
              ),
            ),


            const SizedBox(height: 20),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    goToAnotherPage(context, "JoinScreen");
                  },
                  child: const Text('회원가입', style: TextStyle(fontSize: 25,
                      fontFamily: 'HakgyoansimDoldam',
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline)),
                ),


                const SizedBox(width: 10),


                TextButton(
                  onPressed: () {
                    goToAnotherPage(context, "FindPasswordScreen");
                  },
                  child: const Text('비밀번호 찾기', style: TextStyle(fontSize: 25,
                      fontFamily: 'HakgyoansimDoldam',
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline)),
                ),
              ],
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
