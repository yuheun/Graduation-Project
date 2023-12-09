import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'addGoods/addGoods.dart'; // addGoods.dart 파일
import 'findGoods/findGoods.dart'; // findGoods.dart 파일
import 'mainScreen/alarm.dart';
import 'mainScreen/goodsList.dart'; // goodsList.dart 파일
import 'mainScreen/keywords.dart'; // keywords.dart 파일
import 'mainScreen/search.dart'; // search.dart 파일
import 'personalInfo/personalInfo.dart'; // personalInfo.dart 파일
import 'mainScreen/village.dart'; // village.dart 파일
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //// Flutter 바인딩 초기화
  await NaverMapSdk.instance.initialize(
      clientId: 'gnosf14maf',
      onAuthFailed: (ex) {
        print('******** 네이버맵 인증 오류 : $ex ********');
      });
  await Firebase.initializeApp( // Firebase 초기화
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    home: MyApp(),
  )); // 앱 실행

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

    case "PersonalInfo":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
      );
      break;

    case "GoodsList":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GoodsListScreen()),
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

    case "Search":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchScreen()),
      );
      break;

    case "Alarm":
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AlarmScreen()),
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
  String? mylocation;

  UserData(
      {required this.name,
        required this.password,
        required this.email,
        required this.nickname,
        required this.profileImgUrl,
        required this.mylocation
      });
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: const MyAppPage(),
      theme: ThemeData(fontFamily: 's-core'),
      themeMode: ThemeMode.system,
    );
  }
}

// 하단 바 설정
class MyAppPage extends StatefulWidget {
  const MyAppPage({super.key});
  @override
  State<MyAppPage> createState() => _MyAppPageState();
}

class _MyAppPageState extends State<MyAppPage> {

  int _selectedIndex = 0;

  final List<Widget> _navIndex = [
    const HomeScreen(),
    AlarmScreen(),
    const PersonalInfoScreen(),
  ];

  void _onNavTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _navIndex.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: const Color.fromARGB(255, 78, 103, 169),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: '알림'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: '개인 정보'
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String? selectedDistrict;

  const HomeScreen({Key? key, this.selectedDistrict}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  UserData userData =
  UserData(name: '',
    email: '',
    nickname: '',
    profileImgUrl: '',
    password: '',
    mylocation:'',);

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser);
    if (currentUser != null) {
      DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      print("Loaded user data: ${userDataSnapshot.data()}");
      setState(() {
        userData = UserData(
            name: userDataSnapshot['username'],
            email: currentUser.email ?? '',
            nickname: userDataSnapshot['nickname'],
            profileImgUrl: userDataSnapshot['profileImgUrl'],
            password: '',
            mylocation: userDataSnapshot['mylocation']
        );
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/image/logo_onlyimg.png', // Update the path accordingly
              height: 50, // Set the height of the image
            ),
            SizedBox(width: 8.0),
            Flexible(
              child: Text(
                'Lost&Found Vision',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          ],
        ),
      ),
      body: SingleChildScrollView( // 스크롤 하게 만듦
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("   "+"${userData.nickname.isNotEmpty ? userData.nickname : 'OOO'} 님",
                          style: TextStyle(fontSize: 23,
                              fontWeight: FontWeight.w800)),
                      Text("    내 동네: ${userData.mylocation != null ?
                      '서울특별시 ' + userData.mylocation! : '지역구를 선택하세요'}",
                          style: TextStyle(fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.account_circle,
                      size: 60, color: Color.fromARGB(255, 78, 103, 169)),
                  padding: const EdgeInsets.all(0),
                  onPressed: () {
                    goToAnotherPage(context, "PersonalInfo");
                  },
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    goToAnotherPage(context, "AddGoods");
                  },
                  style: ButtonStyle(
                    minimumSize:
                    MaterialStateProperty.all(Size(screenWidth*0.4, screenHeight*0.23)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 78, 103, 169)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                    ),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min, // 버튼 내용 - 최소한의 공간을 사용
                    children: [
                      Icon(Icons.playlist_add, size: 130, color: Colors.white),
                      Text("분실물 등록",
                          style: TextStyle(fontSize: 20, color: Colors.white,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const FindGoodsScreen()));
                  },
                  style: ButtonStyle(
                    minimumSize:
                    MaterialStateProperty.all(Size(screenWidth*0.4, screenHeight*0.23)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 78, 103, 169)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                    ),
                  ),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min, // 버튼 내용 - 최소한의 공간을 사용
                    children: [
                      Icon(Icons.manage_search, size: 130, color: Colors.white),
                      Text("분실물 찾기", style: TextStyle(fontSize: 20, color: Colors.white,
                           fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                goToAnotherPage(context, "GoodsList");
              },
              style: ButtonStyle(
                minimumSize:
                MaterialStateProperty.all(Size(screenWidth*0.9, screenHeight*0.25)),
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 78, 103, 169)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                ),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min, // 버튼 내용을 깨져서 최최최소한 공간 쓰게 만듦
                children: [
                  Icon(Icons.view_list, size: 130, color: Colors.white),
                  Text("우리 동네 분실물 목록", style: TextStyle(fontSize: 25, color: Colors.white,
                       fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const SizedBox(height: 10),

            const Divider(),
            const SizedBox(height: 5),

            InkWell(
              onTap: () {
                goToAnotherPage(context, "Keywords");
              },
              child: const Row(
                children: [
                  SizedBox(width:15),
                  Icon(Icons.loyalty, size: 30, color: Color.fromARGB(
                      255, 119, 119, 119)),
                  SizedBox(width: 15),
                  Text("알림받는 키워드", style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w500, color: Color.fromARGB(
                          255, 119, 119, 119))
                  ),
                ],
              ),
            ),

            const Divider(),
            const SizedBox(height: 5),
            
            InkWell(
              onTap: () {
                goToAnotherPage(context, "Village");
              },
              child: const Row(
                children: [
                  SizedBox(width:15),
                  Icon(Icons.apartment, size: 30, color: Color.fromARGB(
                      255, 119, 119, 119)),
                  SizedBox(width: 15),
                  Text("내 동네 설정", style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w500, color: Color.fromARGB(
                          255, 119, 119, 119))
                  ),
                ],
              ),
            ),

            const Divider(),
            const SizedBox(height: 5),

            InkWell(
              onTap: () {
                goToAnotherPage(context, "Search");
              },
              child: const Row(
                children: [
                  SizedBox(width:15),
                  Icon(Icons.search, size: 30, color: Color.fromARGB(
                      255, 119, 119, 119)),
                  SizedBox(width: 15),
                  Text("검색하기", style: TextStyle(fontSize: 20,
                    fontWeight: FontWeight.w500, color: Color.fromARGB(
                          255, 119, 119, 119))
                  ),
                ],
              ),
            ),
            
            
          ],
        ),
      ),

      // 알림 floating action button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 78, 103, 169),
        onPressed: () {
          goToAnotherPage(context, "Alarm");
        },
        child: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
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
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
