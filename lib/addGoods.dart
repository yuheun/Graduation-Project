import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
//import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'imageDisplay.dart';

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
  // PlatformFile? _image;
  //
  // Future<void> _pickIMGFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['png', 'jpg'],
  //   );
  //
  //   if (result != null && result.files.isNotEmpty) {
  //     PlatformFile imageFile = result.files.first;
  //     setState(() {
  //       _image = imageFile;
  //     });
  //
  //     String fileName = imageFile.name;
  //     Uint8List fileBytes = imageFile.bytes!;
  //     debugPrint(fileName);
  //
  //     // Perform actions with the file as needed
  //     /*    do jobs    */
  //  }
  XFile? _image;

  Future<void> _pickIMGFile(ImageSource source) async {
    final picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);

    // if (image != null) {
    //   setState(() {
    //     _image = image;
    //   });
    //
    //   String fileName = image.name;
    //   Uint8List fileBytes = await image.readAsBytes();
    //   debugPrint(fileName);

    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ImageDisplayScreen(imagePath: image.path)),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('분실물 등록',
            style: TextStyle(fontSize: 25, fontFamily: 'HakgyoansimDoldam', fontWeight: FontWeight.w600,)
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

      body: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // _image == null
            //   ? const Text('이미지를 선택하세요.')
            //   : Image.memory(
            //     _image!.bytes!,
            //     width: 400,
            //     height: 400,
            // ),
            // ElevatedButton(
            //   onPressed: () {
            //     _pickIMGFile();
            //   },
            //   child: const Text('폴더에서 이미지 선택'),
            // ),

            _image == null
                ? const Text('업로드할 방식을 선택하세요',
                style: TextStyle(fontSize: 28, fontFamily: 'HakgyoansimDoldam', fontWeight: FontWeight.w600,))
                : Image.file(
                    File(_image!.path),
                    width: 400,
                    height: 400,
                  ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _pickIMGFile(ImageSource.gallery);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 130, 155, 255), // 갤러리 버튼 색상
                    onPrimary: Colors.white, // 갤러리 텍스트 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // 버튼 모서리를 조절
                    ),
                    minimumSize: const Size(180, 180),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.photo, size: 120), // 갤러리 아이콘
                      const SizedBox(height: 3), // 간격 조절
                      const Text('갤러리에서 선택',
                          style: TextStyle(fontSize: 20, fontFamily: 'HakgyoansimDoldam', fontWeight: FontWeight.w600,)),
                    ],
                  ),
                ),

                const SizedBox(width: 15), // 간격 조절

                ElevatedButton(
                  onPressed: () {
                    _pickIMGFile(ImageSource.camera);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(230, 170, 173, 173), // 카메라 버튼 색상
                    onPrimary: Colors.white, // 카메라 텍스트 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // 버튼 모서리를 조절합니다.
                    ),
                    minimumSize: const Size(180, 180),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.camera_alt, size: 120), // 카메라 아이콘
                      const SizedBox(height: 3), // 간격 조절
                      const Text('카메라로 촬영',
                          style: TextStyle(fontSize: 20, fontFamily: 'HakgyoansimDoldam', fontWeight: FontWeight.w600,)),
                    ],
                  ),
                ),
              ],
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
