import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MaterialApp(
    home: KeywordsScreen(),
  ));
}

class KeywordsScreen extends StatefulWidget {
  const KeywordsScreen({Key? key}) : super(key: key);

  @override
  _KeywordsScreenState createState() => _KeywordsScreenState();
}

class _KeywordsScreenState extends State<KeywordsScreen> {

  List<String> selectedKeywords = [];

  @override
  void initState() {
    super.initState();
    _loadSelectedKeywords();
  }

  Future<void> _loadSelectedKeywords() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   selectedKeywords = prefs.getStringList('selectedKeywords') ?? [];
    // });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        selectedKeywords = prefs.getStringList('selectedKeywords') ?? [];
      });
    } catch (e) {
      print('Error loading selected keywords: $e');
      // Handle the error as needed
    }
  }

  Future<void> _saveSelectedKeywords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selectedKeywords', selectedKeywords);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('키워드 등록',
            style: TextStyle(fontSize: 25,
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


      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildCategory("전자기기", ["휴대폰", "에어팟", "노트북", "아이패드"]),
                _buildCategory("악세사리", ["지갑", "쥬얼리", "키링"]),
                _buildCategory("기타", ["인형", "화장품", "책"]),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                _registerKeywordsToFirebase();
                _showSelectedKeywordsDialog();
              },
              child: const Text("키워드 등록"),
            ),
          ),
        ],
      ),


    );
  }

  Widget _buildCategory(String category, List<String> keywords) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        for (String keyword in keywords)
          CheckboxListTile(
            title: Text(keyword),
            value: selectedKeywords.contains(keyword),
            onChanged: (bool? value) {
              setState(() {
                if (value != null) {
                  if (value) {
                    selectedKeywords.add(keyword);
                  } else {
                    selectedKeywords.remove(keyword);
                  }
                  _saveSelectedKeywords(); // Save selected keywords to SharedPreferences
                }
              });
            },
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  void _registerKeywordsToFirebase() {
    // 여기에 내가 선택한 키워드 값들 파베로 넘기는거 하면 됨!
    print("Selected Keywords: $selectedKeywords");
  }

  Future<void> _showSelectedKeywordsDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('선택한 키워드'),
          content: Row(
            children: selectedKeywords.map((String keyword) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(keyword),
              );
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }


}
