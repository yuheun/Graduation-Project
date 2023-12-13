import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase/gulItem.dart';

void main() {
  runApp(MaterialApp(
    home: AlarmScreen(),
  ));
}

class AlarmScreen extends StatefulWidget {

  @override
  _AlarmScreenState createState() => _AlarmScreenState();

}

class _AlarmScreenState extends State<AlarmScreen>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.notifications, size: 30,
                color: Color.fromARGB(255, 78, 103, 169)),
            SizedBox(width: 8.0),
            Flexible(
              child: Text(
                '알림',
                style: TextStyle(
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 78, 103, 169)
                ),
              ),
            ),
          ],
        ),

      ),


      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("     키워드 알림 화면 \n     2024년 4학년 1학기 졸업작품3 때 진행할 예정입니다."),
          ],
        ),
      ),

    );
  }




}
