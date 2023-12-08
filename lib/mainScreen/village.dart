import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navigationBar/alarmTap.dart'; // alarmTap.dart 파일
import '../navigationBar/categoryTap.dart'; // categoryTap.dart 파일
import '../navigationBar/searchTap.dart'; // searchTap.dart 파일


void main() {
  runApp(MaterialApp(
    home: VillageScreen(),
  ));
}


Future<void> goToAnotherPage(BuildContext context, String pageName, {String? selectedDistrict}) async {
  // 버튼에 따라 그에 해당하는 파일로 이동
  switch(pageName){

    case "HomeScreen":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(selectedDistrict: selectedDistrict)),
      );

      // Save the selected district to SharedPreferences
      if (selectedDistrict != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('selectedDistrict', selectedDistrict);
      }

      // Send the selected district to Firebase
      // Replace the code below with your Firebase logic
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).update({
        'selectedDistrict': selectedDistrict,
      });

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
                  goToAnotherPage(context, "HomeScreen", selectedDistrict: selectedDistrict);
                } else {
                  print('No district selected.');
                 }
                },
              child: const Text('확인'),
            ),
          ],
        ),
      ),


      // 하단 탭바 (카테고리, 검색, 알림)
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

