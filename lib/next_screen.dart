import 'package:flutter/material.dart';
import 'package:fortest/searchTap.dart';
import 'package:fortest/main.dart';
import 'alarmTap.dart';
import 'categoryTap.dart';
import 'listAccessory.dart';
import 'listEtc.dart';
import 'listElectronics.dart';

void goToAnotherPage(BuildContext context, String pageName){
  // 버튼에 따라 그에 해당하는 파일로 이동
  switch(pageName){
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


    case "ElectronicTap":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ListElectronics()),
      );
      break;

    case "AccessoryTap":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ListAccessory()),
      );
      break;

    case "EtcTap":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ListEtc()),
      );
      break;
  }
}

class NextScreen extends StatelessWidget {
  final String markerText;

  const NextScreen({Key? key, required this.markerText}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(markerText),
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


      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              goToAnotherPage(context, "ElectronicTap");
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 130, 155, 255),
              ),
              minimumSize: MaterialStateProperty.all(Size(screenWidth * 0.7, screenHeight * 0.23)),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.fromLTRB(15, 0, 10, 0),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Make the button rectangular
                ),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.phone_android, size: 100),
                SizedBox(width: 16.0),
                Text('전자기기\nElectronics', style: TextStyle(fontSize: 35)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              goToAnotherPage(context, "AccessoryTap");
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 130, 155, 255),
              ),
              minimumSize: MaterialStateProperty.all(Size(screenWidth * 0.4, screenHeight * 0.23)),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.fromLTRB(15, 0, 10, 0),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Make the button rectangular
                ),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.redeem, size: 100),
                SizedBox(width: 16.0),
                Text('악세사리\nAccessories', style: TextStyle(fontSize: 35)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              goToAnotherPage(context, "EtcTap");
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 130, 155, 255),
              ),
              minimumSize: MaterialStateProperty.all(Size(screenWidth * 0.4, screenHeight * 0.23)),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.fromLTRB(15, 0, 10, 0),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // Make the button rectangular
                ),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.star_outline, size: 100),
                SizedBox(width: 20.0),
                Text('기타\nAnything Else', style: TextStyle(fontSize: 35)),
              ],
            ),
          ),
        ],
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
