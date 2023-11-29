import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

import 'alarmTap.dart'; // alarmTap.dart 파일
import 'categoryTap.dart'; // categoryTap.dart 파일
import 'searchTap.dart'; // searchTap.dart 파일

void main() {
  runApp(const MaterialApp(
    home: AddGoodsScreen(),
  ));
}

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


class AddGoodsScreen extends StatefulWidget {
  const AddGoodsScreen({super.key});

  @override
  _AddGoodsScreenState createState() => _AddGoodsScreenState();
}

class _AddGoodsScreenState extends State<AddGoodsScreen>{
  PlatformFile? _image;

  Future<void> _pickIMGFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg'],
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile imageFile = result.files.first;
      setState(() {
        _image = imageFile;
      });

      String fileName = imageFile.name;
      Uint8List fileBytes = imageFile.bytes!;
      debugPrint(fileName);

      // Perform actions with the file as needed
      /*    do jobs    */

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('분실물 등록'),
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

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
              ? const Text('이미지를 선택하세요.')
              : Image.memory(
                _image!.bytes!,
                width: 400,
                height: 400,
            ),
            ElevatedButton(
              onPressed: () {
                _pickIMGFile();
              },
              child: const Text('폴더에서 이미지 선택'),
            ),
          ],
        ),
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
