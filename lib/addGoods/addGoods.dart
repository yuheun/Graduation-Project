import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'package:image_picker/image_picker.dart';
import 'imageDisplay.dart';


void main() {
  runApp(const MaterialApp(
    home: AddGoodsScreen(),
  ));
}


class AddGoodsScreen extends StatefulWidget {
  const AddGoodsScreen({super.key});

  @override
  _AddGoodsScreenState createState() => _AddGoodsScreenState();
}

class _AddGoodsScreenState extends State<AddGoodsScreen>{
  XFile? _image;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickIMGFile(ImageSource source) async {
    final picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);

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
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600,)
        ),
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

      body: Container(
        // decoration: const BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.center,
        //     colors: [
        //       Color.fromARGB(255, 130, 155, 255), // 시작 색상
        //       Color.fromARGB(255, 255, 255, 255), // 끝 색상
        //     ],
        //   ),
        // ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _image == null
                ? const Text('업로드할 방식을 선택하세요',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600,))
                : Image.file(
                    File(_image!.path),
                    width: 400,
                    height: 400,
                  ),

            const SizedBox(height: 50),

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
                    minimumSize: const Size(160, 180),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.photo, size: 120), // 갤러리 아이콘
                      const SizedBox(height: 3), // 간격 조절
                      const Text('갤러리에서 선택',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,)),
                    ],
                  ),
                ),

                const SizedBox(width: 10), // 간격 조절

                ElevatedButton(
                  onPressed: () {
                    _pickIMGFile(ImageSource.camera);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(230, 170, 173, 173), // 카메라 버튼 색상
                    onPrimary: Colors.white, // 카메라 텍스트 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // 버튼 모서리를 조절
                    ),
                    minimumSize: const Size(170, 180),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.camera_alt, size: 110), // 카메라 아이콘
                      const SizedBox(height: 3), // 간격 조절
                      const Text('카메라로 촬영',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,)),
                    ],
                  ),
                ),
              ],
            ),


          ],
        ),
      ),


    );
  }


}
