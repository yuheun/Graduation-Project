import 'package:flutter/material.dart';
import 'package:fortest/navigationBar/alarmTap.dart';
import 'package:fortest/navigationBar/categoryTap.dart';
import 'package:fortest/main.dart';
import '../findGoods/seeGuDetail.dart';
import '../mainScreen/gulItem.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void goToAnotherPage(BuildContext context, String pageName) {
  // 버튼에 따라 그에 해당하는 파일로 이동
  switch (pageName) {

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

void main() {
  runApp(const MaterialApp(
    home: SearchTapScreen(),
  ));
}

class SearchTapScreen extends StatefulWidget {
  const SearchTapScreen({super.key});

  @override
  _SearchTapScreenState createState() => _SearchTapScreenState();
}


class _SearchTapScreenState extends State<SearchTapScreen> {
  int _currentIndex = 1; // 현재 활성화된 탭 인덱스


  // 각 탭에 해당하는 제목
  final List<String> _tabTitles = ["카테고리", "검색", "알림"];


  void _onTabTapped(int index) {
    String pageName;

    switch (index) {
      case 0:
        pageName = "CategoryTab";
        break;
      case 1:
        pageName = "SearchTab";
        break;
      case 2:
        pageName = "AlarmTab";
        break;
      default:
        pageName = "CategoryTab"; // Set a default page if needed
    }
    goToAnotherPage(context, pageName);


    setState(() {
      _currentIndex = index; // 탭 변경 시 _currentIndex 업데이트
    });
  }


  @override
  Widget build(BuildContext context) {
    Widget currentScreen;
    switch (_currentIndex) {
      case 0:
        currentScreen = CategoryTabScreenContent(); // Show the CategoryTabScreen
        break;
      case 1:
        currentScreen = SearchTapScreenContent();
        break;
      case 2:
        currentScreen = AlarmTapScreenContent();
        break;
      default:
        currentScreen = Container(); // 예외 처리 - 이 부분을 다른 화면으로 대체하거나 적절히 처리
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(_tabTitles[_currentIndex],
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

      body: currentScreen, // 현재 선택된 탭에 대한 화면 표시


      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // 버튼 크기 고정
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: "카테고리",
            backgroundColor: _currentIndex == 0 ? Colors.blue : null,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: "검색",
            backgroundColor: _currentIndex == 1 ? Colors.blue : null,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.notifications),
            label: "알림",
            backgroundColor: _currentIndex == 2 ? Colors.blue : null,
          ),
        ],
      ),
    );
  }
}

class SearchTapScreenContent extends StatefulWidget {
  @override
  _SearchTabScreenContentState createState() =>
      _SearchTabScreenContentState();
}

class _SearchTabScreenContentState extends State<SearchTapScreenContent> {
  late List<GulItem> gulItems;
  TextEditingController searchController = TextEditingController();
  List<GulItem> items = [];
  List<GulItem> filteredItems = [];

  @override
  void initState() {
    super.initState();
    gulItems = [];
    fetchItems();
  }

  Future<void> fetchItems() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('your_collection_name').get();

    setState(() {
      items = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return GulItem(
          label_id: data['item'] ?? '',
          category: data['selectedCategory'] ?? '',
          yolo_label: data['features'] ?? '',
          image_url: data['imagePath'] ?? '',
          description: data['description'] ?? '',
          location: data['loaction'],
          subcategory: data['subcategory'],
          type: data['type'],
        );
      }).toList();
      filteredItems = List.from(items);
    });
  }
  void navigateToDetailScreen(GulItem selectedGulItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => seeGuDetailScreen(gulItem: selectedGulItem, items: [], filteredItems: [],),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 350, // Adjust the width according to your preference
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    filteredItems = items
                        .where((item) =>
                        item.label_id.toLowerCase().contains(value.toLowerCase()))
                        .toList();
                  });
                },
                decoration: InputDecoration(
                  labelText: '검색:',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      // No need to duplicate the search logic here since it's already in onChanged
                    },
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // 클릭한 항목의 데이터를 seeGuDetailScreen으로 전달
                    navigateToDetailScreen(filteredItems[index]);
                  },
                  child: Card(
                    child: ListTile(
                      leading: Image.network(filteredItems[index].image_url),
                      title: Text(
                        '${filteredItems[index].type} + ${filteredItems[index].label_id}',
                      ),
                    ),
                  ),
                );
              },
            ),
          ),



        ],
      ),
    );
  }
}


