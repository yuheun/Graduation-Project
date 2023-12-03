// import 'package:flutter/material.dart';
// import 'package:fortest/main.dart';
//
//
// import 'join.dart';
//
//
// class ImsiJoinScreen extends StatelessWidget {
//   final UserData userData;
//
//
//   const ImsiJoinScreen({super.key, required this.userData});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('가입 정보 확인'),
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
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('이름: ${userData.name}', style: const TextStyle(fontSize: 20)),
//             Text('PW: ${userData.password}', style: const TextStyle(fontSize: 20)),
//             Text('이메일: ${userData.email}', style: const TextStyle(fontSize: 20)),
//             Text('닉네임: ${userData.nickname}', style: const TextStyle(fontSize: 20)),
//             // Add other fields as needed
//           ],
//         ),
//       ),
//     );
//   }
// }
