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
        title: const Text('알림',
            style: TextStyle(fontSize: 25)
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


      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("  알림~~~~화면 \n  알림 화면입니당. 나중에 만들자 방학 때나 \n"
                " 내년 4-1 졸작3 때 하겠다고 합쉬당. 지금은 이거 할 수 없음"),
          ],
        ),
      ),

    );
  }




}
