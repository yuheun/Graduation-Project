import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: VillageScreen(),
  ));
}

Future<void> goToAnotherPage(BuildContext context, String pageName, {String? myloaction}) async {
  // 버튼에 따라 그에 해당하는 파일로 이동
  switch(pageName){

    case "HomeScreen":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(selectedDistrict: myloaction)),
      );

      // Save the selected district to SharedPreferences
      if (myloaction != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('selectedDistrict', myloaction);
      }

      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).update({
        'mylocation': myloaction,
      });

      break;

  }
}


class VillageScreen extends StatefulWidget {
  const VillageScreen({Key? key}) : super(key: key);

  @override
  _VillageScreenState createState() => _VillageScreenState();
}

class _VillageScreenState extends State<VillageScreen> {
  String? selectedDistrict; // Variable to store the selected district

  @override
  void initState() {
    super.initState();
    _loadSelectedDistrict();
  }

  Future<void> _loadSelectedDistrict() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedDistrict = prefs.getString('selectedDistrict');
    });
  }


  @override
  Widget build(BuildContext context) {

    //자치구 리스트
    List<String> districts = [
      '강남구',
      '강동구',
      '강북구',
      '강서구',
      '관악구',
      '광진구',
      '구로구',
      '금천구',
      '노원구',
      '도봉구',
      '동대문구',
      '동작구',
      '마포구',
      '서대문구',
      '서초구',
      '성동구',
      '성북구',
      '송파구',
      '양천구',
      '영등포구',
      '용산구',
      '은평구',
      '종로구',
      '중구',
      '중랑구',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('내 동네 설정',
            style: TextStyle(fontSize: 20,
              fontWeight: FontWeight.w700,)
        ),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 지역구 선택박스버튼
            for (String district in districts)
              RadioListTile<String>(
                title: Text(district),
                value: district,
                groupValue: selectedDistrict,
                onChanged: (String? value) {
                  setState(() {
                    selectedDistrict = value;
                  });
                },
              ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedDistrict != null) {
                  print('Selected District: $selectedDistrict');
                  goToAnotherPage(context, "HomeScreen", myloaction: selectedDistrict);
                } else {
                  print('No district selected.');
                 }
                },
              child: const Text('확인'),
            ),
          ],
        ),
      ),


    );
  }
}

