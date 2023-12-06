//
//예림이 코드 복붙해서 클래스 이름만 바꿈
//

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fortest/findGoods/next_screen.dart';

class NMarkerWithText {
  final String id;
  final NLatLng position;
  final String text;

  NMarkerWithText({
    required this.id,
    required this.position,
    required this.text,
  });
}

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

class FindGoodsScreen extends StatelessWidget {
  const FindGoodsScreen({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: NaverMap(
          options: const NaverMapViewOptions(),
          onMapReady: (controller){

            // 마커 선언해서 해당 위치에 띄우기
            final markers = <NMarkerWithText>[
              NMarkerWithText(
                id: 'jongno',
                position: const NLatLng(37.57348488165832, 126.97904655995124),
                text:'종로구',
              ),
              NMarkerWithText(
                  id: 'jung',
                  position: const NLatLng(37.563823538846414, 126.99760611549013),
                  text:'중구'
              ),
              NMarkerWithText(
                  id: 'yongsan',
                  position: const NLatLng(37.532540511138, 126.99058685711543),
                  text:'용산구'
              ),
              NMarkerWithText(
                  id: 'seongdong',
                  position: const NLatLng(37.56334928438189, 127.03688143304035),
                  text:'성동구'
              ),
              NMarkerWithText(
                  id: 'gwangjin',
                  position: const NLatLng(37.538526386975896, 127.08230085925821),
                  text:'광진구'
              ),
              NMarkerWithText(
                  id: 'dongdaemun',
                  position: const NLatLng(37.574417089930876, 127.03973109228332),
                  text:'동대문구'
              ),
              NMarkerWithText(
                  id: 'jungnang',
                  position: const NLatLng(37.606462575414945, 127.09285133067745),
                  text: '중랑구'
              ),
              NMarkerWithText(
                  id: 'seongbuk',
                  position: const NLatLng(37.58933853737355, 127.0167430958719),
                  text: '성북구'
              ),
              NMarkerWithText(
                  id: 'gangbuk',
                  position: const NLatLng(37.639679696246446, 127.02555220996017),
                  text: '강북구'
              ),
              NMarkerWithText(
                  id: 'dobong',
                  position: const NLatLng(37.66863057777034, 127.04725069829999),
                  text:'도봉구'
              ),
              NMarkerWithText(
                  id: 'nowon',
                  position: const NLatLng(37.65429645908108, 127.05638113020919),
                  text:'노원구'
              ),
              NMarkerWithText(
                  id: 'eunpyeong',
                  position: const NLatLng(37.60280165476516, 126.92891608256764),
                  text:'은평구'
              ),
              NMarkerWithText(
                  id: 'seodaemun',
                  position: const NLatLng(37.57912582394314, 126.93681512480893),
                  text:'서대문구'
              ),
              NMarkerWithText(
                  id: 'mapo',
                  position: const NLatLng(37.56616372029839, 126.9019382288193),
                  text:'마포구'
              ),
              NMarkerWithText(
                  id: 'yangcheon',
                  position: const NLatLng(37.5170381453465, 126.86660312490005),
                  text:'양천구'
              ),
              NMarkerWithText(
                  id: 'gangseo',
                  position: const NLatLng(37.55094260232656, 126.84958189950584),
                  text:'강서구'
              ),
              NMarkerWithText(
                  id: 'guro',
                  position: const NLatLng(37.49536816015178, 126.88744887060629),
                  text:'구로구'
              ),
              NMarkerWithText(
                  id: 'geumcheon',
                  position: const NLatLng(37.45684392258026, 126.89553702359527),
                  text:'금천구'
              ),
              NMarkerWithText(
                  id: 'yeongdeungpo',
                  position: const NLatLng(37.526348313590944, 126.89634238807515),
                  text:'영등포구'
              ),
              NMarkerWithText(
                  id: 'dongjak',
                  position: const NLatLng(37.512462234511005, 126.9393427839368),
                  text:'동작구'
              ),
              NMarkerWithText(
                  id: 'gwanak',
                  position: const NLatLng( 37.47832422507189, 126.95155792537209),
                  text:'관악구'
              ),
              NMarkerWithText(
                  id: 'seocho',
                  position: const NLatLng(37.483548717654976, 127.0327266118686),
                  text:'서초구'
              ),
              NMarkerWithText(
                  id: 'gangnam',
                  position: const NLatLng(37.51729767480405, 127.0474096247077),
                  text:'강남구'
              ),
              NMarkerWithText(
                  id: 'songpa',
                  position: const NLatLng(37.51451384357314, 127.10597133785653 ),
                  text:'송파구'
              ),
              NMarkerWithText(
                  id: 'gangdong',
                  position: const NLatLng(37.5301559370412, 127.12378395434159),
                  text:'강동구'
              )
            ];



            markers.forEach((marker) {
              final id = marker.id;
              final position = marker.position;
              final text = marker.text;

              final markerOverlay = NMarker(
                id: id,
                position: position,
              );

              // 마커 클릭하면 다른 페이지로 이동
              markerOverlay.setOnTapListener((overlay) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NextScreen(markerText: text)),
                );
              });

              controller.addOverlay(markerOverlay);

              // 마커에 정보 띄우기
              final onMarkerInfoWindow = NInfoWindow.onMarker(id: id, text: text);
              markerOverlay.openInfoWindow(onMarkerInfoWindow);
            });
          },


        ),
      ),
    );
  }
}
