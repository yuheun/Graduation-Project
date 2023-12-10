import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fortest/firebase/gulItem.dart';
import '../findGoods/seeGuDetail.dart';

void main() {
  runApp(const MaterialApp(
    home: SearchScreen(),
  ));
}

class SearchScreen extends StatefulWidget {

  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<GulItem> postItems = [];
  List<GulItem> filteredItems = [];
  Map<String, GulItem> mappingData = {};
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchItems(); // Fetch data when the screen is initialized
  }

  Future<void> fetchItems() async {
    print("fetchItems started");

    // PostItems 컬렉션에서 데이터 가져오기 (화면에 띄울 데이터)
    final postItemsQuerySnapshot = await FirebaseFirestore.instance
        .collection('PostItems')
        .get();

    print("items fetched: ${postItemsQuerySnapshot.docs}");

    List<GulItem> newFetchedPostItems = [];

    // 'PostItems'의 각 항목에 대하여
    for (var doc in postItemsQuerySnapshot.docs) {
      print("PostItem: ${doc.data()}"); // PostItem 데이터 로깅

      var postItemData = doc.data();

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
        var mappingData = mappingDoc.data();

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
        title: Text("검색", style: TextStyle(fontSize: 20,
          fontWeight: FontWeight.w700,)),
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
                  hintText: 'ex) 흰색 아이폰',
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
                      title: Text('${item.yolo_label}'),
                      subtitle: Text('대분류: ${item.category}\n중분류: ${item.subcategory}\n소분류: ${item.type}'),
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
