// import 'package:flutter/material.dart';
// import 'package:flutter_naver_map/flutter_naver_map.dart';
// import 'package:fortest/main.dart';
// import 'package:fortest/next_screen.dart';
// import 'dart:async';
// import 'alarmTap.dart'; // alarmTap.dart 파일
// import 'categoryTap.dart'; // categoryTap.dart 파일
// import 'searchTap.dart'; // searchTap.dart 파일
//
// void main() async {
//   await _initialize();
//   runApp(const FindGoodsScreen());
// }
//
// Future<void> _initialize() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await NaverMapSdk.instance.initialize(
//       clientId: 'afo3a4wxc1',
//       onAuthFailed: (ex){
//         print('******** 네이버맵 인증 오류 : $ex ********');
//       });
//
//   // 이렇게 바꿔야 MaterialPageRoute 실행됨(?)
//   runApp(const MaterialApp(
//     home: FindGoodsScreen(),
//   ));
// }
//
//
// void goToAnotherPage(BuildContext context, String pageName){
//   // 버튼에 따라 그에 해당하는 파일로 이동
//   switch(pageName){
//     case "CategoryTap":
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const CategoryTapScreen()),
//       );
//       break;
//
//
//     case "SearchTap":
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const SearchTapScreen()),
//       );
//       break;
//
//
//     case "AlarmTap":
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const AlarmTapScreen()),
//       );
//       break;
//   }
// }
//
// // class FindGoodsScreen extends StatefulWidget{
// //   @override
// //   _FindGoodsScreenState createState() => _FindGoodsScreenState();
// //   const FindGoodsScreen({super.key});
// // }
// //
// //
// // class _FindGoodsScreenState extends State<FindGoodsScreen> {
//
// class FindGoodsScreen extends StatelessWidget{
//   const FindGoodsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('분실물 찾기',
//             style: TextStyle(fontSize: 25,
//               fontFamily: 'HakgyoansimDoldam',
//               fontWeight: FontWeight.w700,)
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.home),
//             onPressed: (){
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (context) => const HomeScreen()),
//                     (Route<dynamic> route) => false,
//               );
//             },
//           )
//         ],
//       ),
//
//
//       body: NaverMap(
//         options: const NaverMapViewOptions(),
//         onMapReady: (controller){
//           // 마커 선언해서 해당 위치에 띄우기
//           final marker = NMarker(id: 'jongno',
//               position: const NLatLng(37.57348488165832, 126.97904655995124));
//           final marker1 = NMarker(id: 'jung',
//               position: const NLatLng(37.563823538846414, 126.99760611549013));
//           final marker2 = NMarker(id: 'yongsan',
//               position: const NLatLng(37.532540511138, 126.99058685711543));
//           final marker3 = NMarker(id: 'seongdong',
//               position: const NLatLng(37.56334928438189, 127.03688143304035));
//           final marker4 = NMarker(id: 'gwangjin',
//               position: const NLatLng(37.538526386975896, 127.08230085925821));
//           final marker5 = NMarker(id: 'dongdaemun',
//               position: const NLatLng(37.574417089930876, 127.03973109228332));
//           final marker6 = NMarker(id: 'jungnang',
//               position: const NLatLng(37.606462575414945, 127.09285133067745));
//           final marker7 = NMarker(id: 'seongbuk',
//               position: const NLatLng(37.58933853737355, 127.0167430958719));
//           final marker8 = NMarker(id: 'gangbuk',
//               position: const NLatLng(37.639679696246446, 127.02555220996017));
//           final marker9 = NMarker(id: 'dobong',
//               position: const NLatLng(37.66863057777034, 127.04725069829999));
//           final marker10 = NMarker(id: 'nowon',
//               position: const NLatLng(37.65429645908108, 127.05638113020919));
//           final marker11 = NMarker(id: 'eunpyeong',
//               position: const NLatLng(37.60280165476516, 126.92891608256764));
//           final marker12 = NMarker(id: 'seodaemun',
//               position: const NLatLng(37.57912582394314, 126.93681512480893));
//           final marker13 = NMarker(id: 'mapo',
//               position: const NLatLng(37.56616372029839, 126.9019382288193));
//           final marker14 = NMarker(id: 'yangcheon',
//               position: const NLatLng(37.5170381453465, 126.86660312490005));
//           final marker15 = NMarker(id: 'gangseo',
//               position: const NLatLng(37.55094260232656, 126.84958189950584));
//           final marker16 = NMarker(id: 'guro',
//               position: const NLatLng(37.49536816015178, 126.88744887060629));
//           final marker17 = NMarker(id: 'geumcheon',
//               position: const NLatLng(37.45684392258026, 126.89553702359527));
//           final marker18 = NMarker(id: 'yeongdeungpo',
//               position: const NLatLng(37.526348313590944, 126.89634238807515));
//           final marker19 = NMarker(id: 'dongjak',
//               position: const NLatLng(37.512462234511005, 126.9393427839368));
//           final marker20 = NMarker(id: 'gwanak',
//               position: const NLatLng( 37.47832422507189, 126.95155792537209));
//           final marker21 = NMarker(id: 'seocho',
//               position: const NLatLng(37.483548717654976, 127.0327266118686));
//           final marker22 = NMarker(id: 'gangnam',
//               position: const NLatLng(37.51729767480405, 127.0474096247077));
//           final marker23 = NMarker(id: 'songpa',
//               position: const NLatLng(37.51451384357314, 127.10597133785653 ));
//           final marker24 = NMarker(id: 'gangdong',
//               position: const NLatLng(37.5301559370412, 127.12378395434159));
//           controller.addOverlayAll({marker,marker1,marker2,marker3,marker4,marker5,marker6,marker7,
//             marker8,marker9,marker10,marker11,marker12,marker13,marker14,marker15,marker16,marker17,
//             marker18,marker19,marker20,marker21,marker22,marker23,marker24});
//
//           // 마커에 정보 띄우기
//           final onMarkerInfoWindow = NInfoWindow.onMarker(id: marker.info.id, text: "종로구");
//           marker.openInfoWindow(onMarkerInfoWindow);
//           final onMarkerInfoWindow1 = NInfoWindow.onMarker(id: marker1.info.id, text: "중구");
//           marker1.openInfoWindow(onMarkerInfoWindow1);
//           final onMarkerInfoWindow2 = NInfoWindow.onMarker(id: marker2.info.id, text: "용산구");
//           marker2.openInfoWindow(onMarkerInfoWindow2);
//           final onMarkerInfoWindow3 = NInfoWindow.onMarker(id: marker3.info.id, text: "성동구");
//           marker3.openInfoWindow(onMarkerInfoWindow3);
//           final onMarkerInfoWindow4 = NInfoWindow.onMarker(id: marker4.info.id, text: "광진구");
//           marker4.openInfoWindow(onMarkerInfoWindow4);
//           final onMarkerInfoWindow5 = NInfoWindow.onMarker(id: marker5.info.id, text: "동대문구");
//           marker5.openInfoWindow(onMarkerInfoWindow5);
//           final onMarkerInfoWindow6 = NInfoWindow.onMarker(id: marker6.info.id, text: "중랑구");
//           marker6.openInfoWindow(onMarkerInfoWindow6);
//           final onMarkerInfoWindow7 = NInfoWindow.onMarker(id: marker7.info.id, text: "성북구");
//           marker7.openInfoWindow(onMarkerInfoWindow7);
//           final onMarkerInfoWindow8 = NInfoWindow.onMarker(id: marker8.info.id, text: "강북구");
//           marker8.openInfoWindow(onMarkerInfoWindow8);
//           final onMarkerInfoWindow9 = NInfoWindow.onMarker(id: marker9.info.id, text: "도봉구");
//           marker9.openInfoWindow(onMarkerInfoWindow9);
//           final onMarkerInfoWindow10 = NInfoWindow.onMarker(id: marker10.info.id, text: "노원구");
//           marker10.openInfoWindow(onMarkerInfoWindow10);
//           final onMarkerInfoWindow11 = NInfoWindow.onMarker(id: marker11.info.id, text: "은평구");
//           marker11.openInfoWindow(onMarkerInfoWindow11);
//           final onMarkerInfoWindow12 = NInfoWindow.onMarker(id: marker12.info.id, text: "서대문구");
//           marker12.openInfoWindow(onMarkerInfoWindow12);
//           final onMarkerInfoWindow13 = NInfoWindow.onMarker(id: marker13.info.id, text: "마포구");
//           marker13.openInfoWindow(onMarkerInfoWindow13);
//           final onMarkerInfoWindow14 = NInfoWindow.onMarker(id: marker14.info.id, text: "양천구");
//           marker14.openInfoWindow(onMarkerInfoWindow14);
//           final onMarkerInfoWindow15 = NInfoWindow.onMarker(id: marker15.info.id, text: "강서구");
//           marker15.openInfoWindow(onMarkerInfoWindow15);
//           final onMarkerInfoWindow16 = NInfoWindow.onMarker(id: marker16.info.id, text: "구로구");
//           marker16.openInfoWindow(onMarkerInfoWindow16);
//           final onMarkerInfoWindow17 = NInfoWindow.onMarker(id: marker17.info.id, text: "금천구");
//           marker17.openInfoWindow(onMarkerInfoWindow17);
//           final onMarkerInfoWindow18 = NInfoWindow.onMarker(id: marker18.info.id, text: "영등포구");
//           marker18.openInfoWindow(onMarkerInfoWindow18);
//           final onMarkerInfoWindow19 = NInfoWindow.onMarker(id: marker19.info.id, text: "동작구");
//           marker19.openInfoWindow(onMarkerInfoWindow19);
//           final onMarkerInfoWindow20 = NInfoWindow.onMarker(id: marker20.info.id, text: "관악구");
//           marker20.openInfoWindow(onMarkerInfoWindow20);
//           final onMarkerInfoWindow21 = NInfoWindow.onMarker(id: marker21.info.id, text: "서초구");
//           marker21.openInfoWindow(onMarkerInfoWindow21);
//           final onMarkerInfoWindow22 = NInfoWindow.onMarker(id: marker22.info.id, text: "강남구");
//           marker22.openInfoWindow(onMarkerInfoWindow22);
//           final onMarkerInfoWindow23 = NInfoWindow.onMarker(id: marker23.info.id, text: "송파구");
//           marker23.openInfoWindow(onMarkerInfoWindow23);
//           final onMarkerInfoWindow24 = NInfoWindow.onMarker(id: marker24.info.id, text: "강동구");
//           marker24.openInfoWindow(onMarkerInfoWindow24);
//
//           // 마커 클릭하면 다른 페이지로 이동
//           //marker.setOnTapListener((overlay) => Navigator.push(context, MaterialPageRoute(builder: (context) => const NextScreen())));
//         },
//       ),
//
//
//
//
//       // 하단 탭바 (카테고리, 검색, 알림)
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list),
//             label: "카테고리",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: "검색",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.notifications),
//             label: "알림",
//           ),
//         ],
//         onTap: (int index) {
//           switch (index) {
//             case 0: // 카테고리 탭
//               goToAnotherPage(context, "CategoryTap");
//               break;
//             case 1: // 검색 탭
//               goToAnotherPage(context, "SearchTap");
//               break;
//             case 2: // 알림 탭
//               goToAnotherPage(context, "AlarmTap");
//               break;
//           }
//         },
//
//
//       ),
//
//
//     );
//   }
// }

//
//예림이 코드 복붙해서 클래스 이름만 바꿈
//이거라도 되어야하는데
//아니왜안되는건데진짜
//인간적으로복붙했으면되어야하는거아님?????
//진짜나한테왜이래
//

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fortest/next_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: 'gnosf14maf',
      onAuthFailed: (ex){
        print('******** 네이버맵 인증 오류 : $ex ********');
      });

  // 이렇게 바꿔야 MaterialPageRoute 실행됨(?)
  runApp(const MaterialApp(
    home: FindGoodsScreen(),
  ));
}

// void main() async {
//   await _initialize();
//   runApp(const FindGoodsScreen());
// }
//
// Future<void> _initialize() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await NaverMapSdk.instance.initialize(
//       clientId: 'gnosf14maf',
//       );
// }


class FindGoodsScreen extends StatelessWidget {
  const FindGoodsScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: NaverMap(
          options: const NaverMapViewOptions(),
          onMapReady: (controller){
            // 마커 선언해서 해당 위치에 띄우기
            final marker = NMarker(id: 'jongno',
                position: const NLatLng(37.57348488165832, 126.97904655995124));
            final marker1 = NMarker(id: 'jung',
                position: const NLatLng(37.563823538846414, 126.99760611549013));
            final marker2 = NMarker(id: 'yongsan',
                position: const NLatLng(37.532540511138, 126.99058685711543));
            final marker3 = NMarker(id: 'seongdong',
                position: const NLatLng(37.56334928438189, 127.03688143304035));
            final marker4 = NMarker(id: 'gwangjin',
                position: const NLatLng(37.538526386975896, 127.08230085925821));
            final marker5 = NMarker(id: 'dongdaemun',
                position: const NLatLng(37.574417089930876, 127.03973109228332));
            final marker6 = NMarker(id: 'jungnang',
                position: const NLatLng(37.606462575414945, 127.09285133067745));
            final marker7 = NMarker(id: 'seongbuk',
                position: const NLatLng(37.58933853737355, 127.0167430958719));
            final marker8 = NMarker(id: 'gangbuk',
                position: const NLatLng(37.639679696246446, 127.02555220996017));
            final marker9 = NMarker(id: 'dobong',
                position: const NLatLng(37.66863057777034, 127.04725069829999));
            final marker10 = NMarker(id: 'nowon',
                position: const NLatLng(37.65429645908108, 127.05638113020919));
            final marker11 = NMarker(id: 'eunpyeong',
                position: const NLatLng(37.60280165476516, 126.92891608256764));
            final marker12 = NMarker(id: 'seodaemun',
                position: const NLatLng(37.57912582394314, 126.93681512480893));
            final marker13 = NMarker(id: 'mapo',
                position: const NLatLng(37.56616372029839, 126.9019382288193));
            final marker14 = NMarker(id: 'yangcheon',
                position: const NLatLng(37.5170381453465, 126.86660312490005));
            final marker15 = NMarker(id: 'gangseo',
                position: const NLatLng(37.55094260232656, 126.84958189950584));
            final marker16 = NMarker(id: 'guro',
                position: const NLatLng(37.49536816015178, 126.88744887060629));
            final marker17 = NMarker(id: 'geumcheon',
                position: const NLatLng(37.45684392258026, 126.89553702359527));
            final marker18 = NMarker(id: 'yeongdeungpo',
                position: const NLatLng(37.526348313590944, 126.89634238807515));
            final marker19 = NMarker(id: 'dongjak',
                position: const NLatLng(37.512462234511005, 126.9393427839368));
            final marker20 = NMarker(id: 'gwanak',
                position: const NLatLng( 37.47832422507189, 126.95155792537209));
            final marker21 = NMarker(id: 'seocho',
                position: const NLatLng(37.483548717654976, 127.0327266118686));
            final marker22 = NMarker(id: 'gangnam',
                position: const NLatLng(37.51729767480405, 127.0474096247077));
            final marker23 = NMarker(id: 'songpa',
                position: const NLatLng(37.51451384357314, 127.10597133785653 ));
            final marker24 = NMarker(id: 'gangdong',
                position: const NLatLng(37.5301559370412, 127.12378395434159));
            controller.addOverlayAll({marker,marker1,marker2,marker3,marker4,marker5,marker6,marker7,
              marker8,marker9,marker10,marker11,marker12,marker13,marker14,marker15,marker16,marker17,
              marker18,marker19,marker20,marker21,marker22,marker23,marker24});

            // 마커에 정보 띄우기
            final onMarkerInfoWindow = NInfoWindow.onMarker(id: marker.info.id, text: "종로구");
            marker.openInfoWindow(onMarkerInfoWindow);
            final onMarkerInfoWindow1 = NInfoWindow.onMarker(id: marker1.info.id, text: "중구");
            marker1.openInfoWindow(onMarkerInfoWindow1);
            final onMarkerInfoWindow2 = NInfoWindow.onMarker(id: marker2.info.id, text: "용산구");
            marker2.openInfoWindow(onMarkerInfoWindow2);
            final onMarkerInfoWindow3 = NInfoWindow.onMarker(id: marker3.info.id, text: "성동구");
            marker3.openInfoWindow(onMarkerInfoWindow3);
            final onMarkerInfoWindow4 = NInfoWindow.onMarker(id: marker4.info.id, text: "광진구");
            marker4.openInfoWindow(onMarkerInfoWindow4);
            final onMarkerInfoWindow5 = NInfoWindow.onMarker(id: marker5.info.id, text: "동대문구");
            marker5.openInfoWindow(onMarkerInfoWindow5);
            final onMarkerInfoWindow6 = NInfoWindow.onMarker(id: marker6.info.id, text: "중랑구");
            marker6.openInfoWindow(onMarkerInfoWindow6);
            final onMarkerInfoWindow7 = NInfoWindow.onMarker(id: marker7.info.id, text: "성북구");
            marker7.openInfoWindow(onMarkerInfoWindow7);
            final onMarkerInfoWindow8 = NInfoWindow.onMarker(id: marker8.info.id, text: "강북구");
            marker8.openInfoWindow(onMarkerInfoWindow8);
            final onMarkerInfoWindow9 = NInfoWindow.onMarker(id: marker9.info.id, text: "도봉구");
            marker9.openInfoWindow(onMarkerInfoWindow9);
            final onMarkerInfoWindow10 = NInfoWindow.onMarker(id: marker10.info.id, text: "노원구");
            marker10.openInfoWindow(onMarkerInfoWindow10);
            final onMarkerInfoWindow11 = NInfoWindow.onMarker(id: marker11.info.id, text: "은평구");
            marker11.openInfoWindow(onMarkerInfoWindow11);
            final onMarkerInfoWindow12 = NInfoWindow.onMarker(id: marker12.info.id, text: "서대문구");
            marker12.openInfoWindow(onMarkerInfoWindow12);
            final onMarkerInfoWindow13 = NInfoWindow.onMarker(id: marker13.info.id, text: "마포구");
            marker13.openInfoWindow(onMarkerInfoWindow13);
            final onMarkerInfoWindow14 = NInfoWindow.onMarker(id: marker14.info.id, text: "양천구");
            marker14.openInfoWindow(onMarkerInfoWindow14);
            final onMarkerInfoWindow15 = NInfoWindow.onMarker(id: marker15.info.id, text: "강서구");
            marker15.openInfoWindow(onMarkerInfoWindow15);
            final onMarkerInfoWindow16 = NInfoWindow.onMarker(id: marker16.info.id, text: "구로구");
            marker16.openInfoWindow(onMarkerInfoWindow16);
            final onMarkerInfoWindow17 = NInfoWindow.onMarker(id: marker17.info.id, text: "금천구");
            marker17.openInfoWindow(onMarkerInfoWindow17);
            final onMarkerInfoWindow18 = NInfoWindow.onMarker(id: marker18.info.id, text: "영등포구");
            marker18.openInfoWindow(onMarkerInfoWindow18);
            final onMarkerInfoWindow19 = NInfoWindow.onMarker(id: marker19.info.id, text: "동작구");
            marker19.openInfoWindow(onMarkerInfoWindow19);
            final onMarkerInfoWindow20 = NInfoWindow.onMarker(id: marker20.info.id, text: "관악구");
            marker20.openInfoWindow(onMarkerInfoWindow20);
            final onMarkerInfoWindow21 = NInfoWindow.onMarker(id: marker21.info.id, text: "서초구");
            marker21.openInfoWindow(onMarkerInfoWindow21);
            final onMarkerInfoWindow22 = NInfoWindow.onMarker(id: marker22.info.id, text: "강남구");
            marker22.openInfoWindow(onMarkerInfoWindow22);
            final onMarkerInfoWindow23 = NInfoWindow.onMarker(id: marker23.info.id, text: "송파구");
            marker23.openInfoWindow(onMarkerInfoWindow23);
            final onMarkerInfoWindow24 = NInfoWindow.onMarker(id: marker24.info.id, text: "강동구");
            marker24.openInfoWindow(onMarkerInfoWindow24);

            // 마커 클릭하면 다른 페이지로 이동
            marker.setOnTapListener((overlay) => Navigator.push(context, MaterialPageRoute(builder: (context) => const NextScreen())));
          },
        ),
      ),
    );
  }
}



