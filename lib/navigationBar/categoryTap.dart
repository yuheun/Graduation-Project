import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fortest/navigationBar/alarmTap.dart';
import 'package:fortest/main.dart';
import 'package:fortest/mainScreen/gulItem.dart';
import 'package:fortest/navigationBar/searchTap.dart';

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
    home: CategoryTapScreen(),
  ));
}

class CategoryTapScreen extends StatefulWidget {
  const CategoryTapScreen({super.key});

  @override
  _CategoryTapScreenState createState() => _CategoryTapScreenState();
}


class _CategoryTapScreenState extends State<CategoryTapScreen> {
  int _currentIndex = 0; // 현재 활성화된 탭 인덱스

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
        currentScreen = AlarmTapScreenContent();// 알림 탭 화면
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
            onPressed: () {
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

class CategoryTabScreenContent extends StatefulWidget {
  @override
  _CategoryTabScreenContentState createState() =>
      _CategoryTabScreenContentState();
}

class _CategoryTabScreenContentState extends State<CategoryTabScreenContent> {
  late List<GulItem> gulItems;
  @override
  void initState() {
    super.initState();
    gulItems = [];
    fetchGulItems('전자기기'); // Fetch items for the initial category
  }

  void fetchGulItems(String category) {
    FirebaseFirestore.instance
        .collection('gulItems')
        .where('selectedCategory', isEqualTo: category)
        .get()
        .then((querySnapshot) {
      setState(() {
        gulItems = querySnapshot.docs
            .map((doc) => GulItem(
          label_id: doc['item'],
          category: doc['selectedCategory'],
          yolo_label: doc['features'],
          image_url: doc['imagePath'],
          description: doc['description'],
          location: doc['loaction'],
          subcategory: doc['subcategory'],
          type: doc['type'],
        ))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Category Buttons (전자기기, 악세사리, 기타)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  fetchGulItems('전자기기');
                },
                child: Text('전자기기'),
              ),
              ElevatedButton(
                onPressed: () {
                  fetchGulItems('악세사리');
                },
                child: Text('악세사리'),
              ),
              ElevatedButton(
                onPressed: () {
                  fetchGulItems('기타');
                },
                child: Text('기타'),
              ),
            ],
          ),

          // ListView for each category
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 8.0, // Space between columns
                mainAxisSpacing: 8.0, // Space between rows
              ),
              itemCount: gulItems.length,
              itemBuilder: (context, index) {
                GulItem currentItem = gulItems[index];

                return GestureDetector(
                  onTap: () {
                    // Handle item tap
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        child: Image.network(
                          currentItem.image_url,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '${currentItem.type} ${currentItem.label_id}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
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

