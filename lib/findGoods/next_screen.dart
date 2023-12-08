import 'package:flutter/material.dart';
import 'package:fortest/findGoods/seeGuDetail.dart';
import 'package:fortest/navigationBar/searchTap.dart';
import 'package:fortest/main.dart';
import '../navigationBar/alarmTap.dart';
import '../navigationBar/categoryTap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fortest/mainScreen/gulItem.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  }
}

class NextScreen extends StatefulWidget {
  final String markerText;

  const NextScreen({Key? key, required this.markerText}) : super(key: key);

  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  TextEditingController searchController = TextEditingController();
  List<GulItem> items = [];
  List<GulItem> filteredItems = [];

  @override
  void initState() {
    super.initState();
    fetchItems(); // Fetch data when the screen is initialized
  }

  Future<void> fetchItems() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('your_collection_name').get();

    setState(() {
      items = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return GulItem(
          subcategory: data['subcategory'] ?? '',
          category: data['category'] ?? '',
          type: data['type'] ?? '',
          image_url: data['image_url'] ?? '',
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

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.markerText),
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
                        item.subcategory.toLowerCase().contains(value.toLowerCase()))
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
                        '${filteredItems[index].type} ${filteredItems[index].subcategory}',
                      ),
                    ),
                  ),
                );
              },
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
