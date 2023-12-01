import 'package:flutter/material.dart';


import 'addGoods.dart'; // addGoods.dart 파일
import 'alarmTap.dart'; // alarmTap.dart 파일
import 'categoryTap.dart'; // categoryTap.dart 파일
import 'community.dart'; // community.dart 파일
import 'findGoods.dart'; // findGoods.dart 파일
import 'goodsList.dart'; // goodsList.dart 파일
import 'keywords.dart'; // keywords.dart 파일
import 'personalInfo.dart'; // personalInfo.dart 파일
import 'searchTap.dart'; // searchTap.dart 파일
import 'village.dart'; // village.dart 파일
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter 바인딩 초기화
  await Firebase.initializeApp( // Firebase 초기화
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp()); // 앱 실행
}




void goToAnotherPage(BuildContext context, String pageName) {
  // 버튼에 따라 그에 해당하는 파일로 이동
  switch (pageName) {
    case "HomeScreen":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      break;


    case "AddGoods":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddGoodsScreen()),
      );
      break;


    case "FindGoods":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FindGoodsScreen()),
      );
      break;


    case "PersonalInfo":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
      );
      break;


    case "GoodsList":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const GoodsListScreen()),
      );
      break;


    case "Keywords":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const KeywordsScreen()),
      );
      break;


    case "Village":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VillageScreen()),
      );
      break;


    case "Community":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CommunityScreen()),
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
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("분실물 어플",
            style: TextStyle(fontSize: 25, fontFamily: 'HakgyoansimDoldam',
                fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView( // 스크롤 하게 만듦
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Color.fromARGB(255, 130, 155, 255), // 시작 색상
                Color.fromARGB(255, 255, 255, 255), // 끝 색상
              ],
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text("  user_name 님",
                            style: TextStyle(fontSize: 25,
                                fontFamily: 'HakgyoansimDoldam',
                                fontWeight: FontWeight.w800)),
                        Text("  내 동네: 서울특별시 00구",
                            style: TextStyle(fontSize: 18,
                                fontFamily: 'HakgyoansimDoldam',
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.account_circle,
                        size: 40, color: Color.fromARGB(255, 255, 255, 255)),
                    padding: const EdgeInsets.all(0),
                    onPressed: () {
                      goToAnotherPage(context, "PersonalInfo");
                    },
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      goToAnotherPage(context, "AddGoods");
                    },
                    style: ButtonStyle(
                      minimumSize:
                      MaterialStateProperty.all(Size(screenWidth*0.4, screenHeight*0.229)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 57, 235, 161)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(80.0),
                          ),
                        ),
                      ),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min, // 버튼 내용 - 최소한의 공간을 사용
                      children: [
                        Icon(Icons.playlist_add, size: 130, color: Colors.white),
                        Text("분실물 등록",
                            style: TextStyle(fontSize: 25, color: Colors.white,
                                fontFamily: 'HakgyoansimDoldam', fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      goToAnotherPage(context, "FindGoods");
                    },
                    style: ButtonStyle(
                      minimumSize:
                      MaterialStateProperty.all(Size(screenWidth*0.4, screenHeight*0.229)),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 121, 203, 250)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(80.0),
                          ),
                        ),
                      ),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min, // 버튼 내용 - 최소한의 공간을 사용
                      children: [
                        Icon(Icons.manage_search, size: 130, color: Colors.white),
                        Text("분실물 찾기", style: TextStyle(fontSize: 25, color: Colors.white,
                            fontFamily: 'HakgyoansimDoldam', fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  goToAnotherPage(context, "GoodsList");
                },
                style: ButtonStyle(
                  minimumSize:
                  MaterialStateProperty.all(Size(screenWidth*0.9, screenHeight*0.229)),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 130, 155, 255)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(80.0),
                      ),
                    ),
                  ),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min, // 버튼 내용을 깨져서 최최최소한 공간 쓰게 만듦
                  children: [
                    Icon(Icons.view_list, size: 130, color: Colors.white),
                    Text("우리 동네 분실물 목록", style: TextStyle(fontSize: 25, color: Colors.white,
                        fontFamily: 'HakgyoansimDoldam', fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          goToAnotherPage(context, "Keywords"); // 태그 로고 클릭 시 수행할 동작
                        },
                        child: const Icon(Icons.loyalty,
                            size: 100, color: Color.fromARGB(255, 239, 151, 151)), // 키워드 아이콘 색상
                      ),
                      const Text("알림받는 키워드",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'HakgyoansimDoldam',
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 239, 151, 151), // 키워드 텍스트 색상
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          goToAnotherPage(context, "Village"); // 집 로고 클릭 시 수행할 동작
                        },
                        child: const Icon(Icons.apartment,
                            size: 100, color: Color.fromARGB(255, 139, 181, 229)), // 동네 설정 아이콘 색상
                      ),
                      const Text("내 동네 설정",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'HakgyoansimDoldam',
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 139, 181, 229), // 동네 설정 텍스트 색상
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          goToAnotherPage(context, "Community");
                        },
                        child: const Icon(Icons.forum,
                            size: 100, color: Color.fromARGB(255, 255, 180, 93)), // 커뮤니티 아이콘 색상
                      ),
                      const Text("동네 커뮤니티",
                        style: TextStyle(
                          fontSize: 15,
                          fontFamily: 'HakgyoansimDoldam',
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 255, 180, 93), // 커뮤니티 텍스트 색상
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
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

class MenuButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const MenuButton({
    Key? key,
    required this.iconData,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
        shape: MaterialStateProperty.all(
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(80.0),
            ),
          ),
        ),
      ),
      child: Column(
        children: [
          Icon(iconData, size: 130, color: Colors.white),
          Text(
            text,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontFamily: 'HakgyoansimDoldam',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
