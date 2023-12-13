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
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> fetchItems(String searchQuery) async {
    print("fetchItems started");

    // Mapping 컬렉션에서 검색어에 해당하는 문서를 찾는다. (Mapping의 category, subcategory, type, yolo_label에서 모두 검색
    var mappingQuerySnapshots = await Future.wait([
      FirebaseFirestore.instance
          .collection('Mapping')
          .where('category', isEqualTo: searchQuery)
          .get(),
      FirebaseFirestore.instance
          .collection('Mapping')
          .where('subcategory', isEqualTo: searchQuery)
          .get(),
      FirebaseFirestore.instance
          .collection('Mapping')
          .where('type', isEqualTo: searchQuery)
          .get(),
      FirebaseFirestore.instance
          .collection('Mapping')
          .where('yolo_label', isEqualTo: searchQuery)
          .get(),
    ]);

    // 검색 결과 담을 리스트
    List<GulItem> fetchedItems = [];

    // 'PostItems'의 각 항목에 대하여
    for (var snapshot in mappingQuerySnapshots) {
      for (var doc in snapshot.docs) {
        var mappingData = doc.data();
        print("MappingData: ${mappingData}"); // PostItem 데이터 로깅

        // 'PostItems' 컬렉션에서 추가 데이터 가져오기
        var postItemsQuerySnapshot = await FirebaseFirestore.instance
            .collection('PostItems')
            .where('label_id', isEqualTo: mappingData['label_id'])
            .get();

        // 만약 매핑 데이터가 있으면 'GulItem' 객체 생성
        if (postItemsQuerySnapshot.docs.isNotEmpty) {
          // 문서가 존재하면 첫 번째 문서의 데이터를 사용
          var postItemsDoc = postItemsQuerySnapshot.docs.first;
          print("Mapping data for label_id ${postItemsDoc['label_id']}: ${postItemsDoc.data()}");
          var postItemData = postItemsDoc.data();

          var gulItem = GulItem(
            label_id: postItemData['label_id'],
            image_url: postItemData['image_url'] ?? 'Unknown',
            description: postItemData['description'],
            location: postItemData['location'],
            category: mappingData['category'] ?? 'Unknown',
            // 기본값 설정
            subcategory: mappingData['subcategory'] ?? 'Unknown',
            type: mappingData['type'] ?? 'Unknown',
            yolo_label: mappingData['yolo_label'] ?? 'Unknown',
          );
          fetchedItems.add(gulItem);
        } else {
          print(
              "No mapping data found for label_id ${mappingData['label_id']}");
        }
      }

      // 상태 업데이트
      setState(() {
        postItems = fetchedItems;
      });
    }
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
                  });
                },
                decoration: InputDecoration(
                  labelText: '검색:',
                  hintText: 'ex) 흰색 아이폰',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      fetchItems(searchController.text);                    },
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: postItems.length,
              itemBuilder: (context, index) {
                final GulItem item = postItems[index];

                return GestureDetector(
                  onTap: () {
                    navigateToDetailScreen(item);
                  },
                  child: Card(
                    child: ListTile(
                      leading: item.image_url != null
                        ? SizedBox(
                        width: 50,
                        height: 50,
                        child: Image.network(item.image_url, fit: BoxFit.cover),
                      )
                      : null,
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
