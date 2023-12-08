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
  List<GulItem> postItems = [];
  List<GulItem> filteredItems = []; // 선택된 location
  Map<String, GulItem> mappingData = {};
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchItems(); // Fetch data when the screen is initialized
  }

  Future<void> fetchItems() async {
    print("fetchItems started");
    print("widget.markerText: ${widget.markerText}"); // markerText 출력

    // PostItems 컬렉션에서 데이터 가져오기 (화면에 띄울 데이터)
    final postItemsQuerySnapshot = await FirebaseFirestore.instance
        .collection('PostItems')
        .where('location', isEqualTo: widget.markerText)
        .get();

    print("items fetched: ${postItemsQuerySnapshot.docs}");

    List<GulItem> newFetchedPostItems = [];

    // 'PostItems'의 각 항목에 대하여
    for (var doc in postItemsQuerySnapshot.docs) {
      print("PostItem: ${doc.data()}"); // PostItem 데이터 로깅

      var postItemData = doc.data() as Map<String, dynamic>;

      // 'Mapping' 컬렉션에서 추가 데이터 가져오기
      var mappingDocSnapshot = await FirebaseFirestore.instance
          .collection('Mapping')
          .where('label_id', isEqualTo: postItemData['label_id'])
          .get();

      // 만약 매핑 데이터가 있으면 'GulItem' 객체 생성
      if (mappingDocSnapshot.docs.isNotEmpty) {
        // 문서가 존재하면 첫 번째 문서의 데이터를 사용
        var mappingDoc = mappingDocSnapshot.docs.first;
        print("Mapping data for label_id ${postItemData['label_id']}: ${mappingDoc.data()}");
        var mappingData = mappingDoc.data() as Map<String, dynamic>;

        var gulItem = GulItem(
          label_id: postItemData['label_id'],
          image_url: postItemData['image_url'],
          description: postItemData['description'],
          location: postItemData['location'],
          category: mappingData['category'] ?? 'Unknown', // 기본값 설정
          subcategory: mappingData['subcategory'] ?? 'Unknown',
          type: mappingData['type'] ?? 'Unknown',
          yolo_label: mappingData['yolo_label'] ?? 'Unknown',
        );
        newFetchedPostItems.add(gulItem);
      } else {
        print("No mapping data found for label_id ${postItemData['label_id']}");
      }
    }

    // 상태 업데이트
    setState(() {
      postItems = newFetchedPostItems;
      filteredItems = List.from(newFetchedPostItems);
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
                    filteredItems = postItems
                        .where((itemModel) =>
                        itemModel.description.toLowerCase().contains(value.toLowerCase()))
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
                final GulItem item = filteredItems[index];

                return GestureDetector(
                  onTap: () {
                    navigateToDetailScreen(item);
                  },
                  child: Card(
                    child: ListTile(
                      leading: item.image_url != null ? Image.network(item.image_url) : null,
                      title: Text('${item.description}'),
                      subtitle: Text('카테고리: ${item.category}\n서브카테고리: ${item.subcategory}\n타입: ${item.type}'),
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
