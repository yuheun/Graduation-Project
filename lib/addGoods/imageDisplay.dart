import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fortest/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'imsi_gul.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
///////////////
//import 'package:tflite_flutter/tflite_flutter.dart';
//import 'dart:typed_data';
//////////////
//import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:palette_generator/palette_generator.dart';

void main() {
  runApp(const MaterialApp(
    home: ImageDisplayScreen(
      imagePath: '',
    ),
  ));
}

class ImageDisplayScreen extends StatefulWidget {
  final String imagePath;
  const ImageDisplayScreen({required this.imagePath});

  @override
  _ImageDisplayScreenState createState() => _ImageDisplayScreenState();
}

class UserData {
  String name;
  String email;
  String nickname;
  String? profileImgUrl;

  UserData({
    required this.name,
    required this.email,
    required this.nickname,
    required this.profileImgUrl,
  });
}

class _ImageDisplayScreenState extends State<ImageDisplayScreen> {
  UserData userData =
      UserData(name: '', email: '', nickname: '', profileImgUrl: '');

  String item = '';
  String selectedCategory = '전자기기'; // To store the selected category value
  // Define the available categories
  List<String> categories = ['전자기기', '악세사리', '기타'];
  String features = '';

  @override
  void initState() {
    super.initState();
    loadUserData();
    ////////////////색상이라도 뽑아내야할거 같아서..////////////////
    extractDominantColor();
  }

  //////////////////색상이라도 뽑아내야할거 같아서..//////////////
  Color dominantColor = Colors.white;
  String colorCategory = '';

  Future<void> extractDominantColor() async {
    try {
      Image image = Image.file(File(widget.imagePath));
      PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(image.image);

      dominantColor = paletteGenerator.dominantColor?.color ?? Colors.white;

      print('Dominant Color: $dominantColor');

      // 분류된 색상 출력
      String colorCategory = classifyColor(dominantColor);
      print('Color Category: $colorCategory');

      setState(() {
        // features 값 업데이트
        //features = 'Dominant Color: ${dominantColor.toString()}, Category: $colorCategory';
        features = '$colorCategory';
      });
    } catch (e) {
      print('Error extracting dominant color: $e');
    }
  }

  String classifyColor(Color color) {
    Map<String, List<int>> colorMapping = {
      "빨간색": [255, 0, 0],
      "주황색": [255, 165, 0],
      "노란색": [255, 255, 0],
      "초록색": [0, 128, 0],
      "파란색": [0, 0, 255],
      "보라색": [128, 0, 128],
      "흰색": [255, 255, 255],
      "검은색": [0, 0, 0],
      // 더 추가함
      "갈색": [139, 69, 19],
      "분홍색": [255, 182, 193],
      "회색": [128, 128, 128],
      "하늘색": [135, 206, 250],
      "청록색": [0, 255, 255],
      "남색": [0, 0, 128],
      "연보라색": [230, 230, 250],
      "연녹색": [50, 205, 50],
    };

    // 입력된 RGB 값과 가장 가까운 색상 찾기
    String closestColor = findClosestColor(color, colorMapping);
    return closestColor;
  }

  String findClosestColor(
      Color targetColor, Map<String, List<int>> colorMapping) {
    int minDistance = double.maxFinite.toInt();
    String closestColor = '알 수 없는 색상';

    // 각 미리 정의된 색상과의 거리 계산
    colorMapping.forEach((String colorName, List<int> rgbValues) {
      int distance = calculateDistance(targetColor,
          Color.fromARGB(255, rgbValues[0], rgbValues[1], rgbValues[2]));
      if (distance < minDistance) {
        minDistance = distance;
        closestColor = colorName;
      }
    });

    return closestColor;
  }

  int calculateDistance(Color color1, Color color2) {
    // 각 색상의 RGB 값 차이의 제곱을 계산하여 거리 측정
    int redDiff = color1.red - color2.red;
    int greenDiff = color1.green - color2.green;
    int blueDiff = color1.blue - color2.blue;
    return (redDiff * redDiff) +
        (greenDiff * greenDiff) +
        (blueDiff * blueDiff);
  }

  /////////////////// 색 인식 함수 끝 /////////////////

  Future<void> loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    print(currentUser);
    if (currentUser != null) {
      DocumentSnapshot userDataSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      print("Loaded user data: ${userDataSnapshot.data()}");
      setState(() {
        userData = UserData(
          name: userDataSnapshot['username'],
          email: currentUser.email ?? '',
          nickname: userDataSnapshot['nickname'],
          profileImgUrl: userDataSnapshot['profileImgUrl'],
        );
      });
    }
  }

// Firebase 연결 (model 연결 이후에)
  void uploadDataToFirestore() async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Firestore 'posts' 컬렉션에 데이터 추가
        await FirebaseFirestore.instance.collection('z').add({
          'user_id': currentUser.uid,
          'image_url': widget.imagePath,
          'item': item,
          'category': selectedCategory,
          'features': features,
          // 기타 필요한 데이터 추가
        });
      }
    } catch (e) {
      print('Error uploading data to Firestore: $e');
    }
  }

  // 현재위치 불러오기
  Future<Position> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        print('Error! 위치 권한이 거부되었습니다.');
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);

    return position;
  }

  //위치 주소변환
  Future<String?> getAddress() async {
    var gps = await getLocation();

    double lat = gps.latitude;
    double lon = gps.longitude;

    List<Placemark> placemarks = await placemarkFromCoordinates(
      lat,
      lon,
    );

    Placemark placemark = placemarks[0];

    if (placemarks != null && placemarks.isNotEmpty) {
      String address =
          "${placemark.subLocality} ${placemark.thoroughfare}, ${placemark.locality}, ${placemark.administrativeArea}";

      print("변환된 주소: $address");

      return placemark.subLocality;
    } else {
      print("주소를 변환할 수 없습니다.");

      return "주소를 변환할 수 없습니다.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('글 작성',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyAppPage()),
                (Route<dynamic> route) => false,
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(
              File(widget.imagePath),
              width: 400,
              height: 400,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  buildInputField('종류', item),
                  //Text('종류: $item', style: TextStyle(fontSize: 20),),
                  buildCategoryDropdown(), // Added the category dropdown
                  //buildInputField('특징', features),
                  const SizedBox(height: 8),
                  //임시로 그냥 색상 출력...
                  Text(
                    '특징: $features',
                    style: TextStyle(fontSize: 20),
                  ),

                  SizedBox(height: 7),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        '현재 위치: ',
                        style: TextStyle(fontSize: 20),
                      ),
                      FutureBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.hasData == false) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Error:$snapshot',
                                style: const TextStyle(fontSize: 15),
                              ),
                            );
                          } else {
                            String address = snapshot.data as String;

                            // 이 값 PostItems firebase에 저장해야댐 ----------------------------

                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(address,
                                      style: const TextStyle(fontSize: 20)),
                                ],
                              ),
                            );
                          }
                        },
                        future: getAddress(),
                      )
                    ],
                  ),

                  ElevatedButton(
                    onPressed: () {
                      uploadDataToFirestore();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImsiGulScreen(
                              ///////////변수 써야함////////////

                              ),
                        ),
                      );
                    },
                    child: Text('작성'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryDropdown() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('대분류:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              )),
          SizedBox(width: 8),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedCategory,
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputField(String label, String value) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text('$label:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              )),
          SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
              ),
              onChanged: (newValue) {
                setState(() {
                  switch (label) {
                    case '종류':
                      item = newValue;
                      break;
                    // case '대분류':
                    //   category = newValue;
                    //   break;
                    case '특징':
                      features = newValue;
                      break;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
