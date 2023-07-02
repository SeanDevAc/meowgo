// import 'package:flutter/material.dart';
// import 'package:meowgo/main-views/home-page-widget.dart';
// import 'package:meowgo/main-views/step_count_page.dart';

// class StartPageWidget extends StatelessWidget {
//   const StartPageWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final gradientColors = [
//       Colors.red,
//       Colors.red,
//       Colors.white,
//       Colors.white,
//     ];
//     final stops = [0.0, 0.5, 0.5, 1.0];

//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: gradientColors,
//           stops: stops,
//         ),
//       ),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Start Page'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 'Welcome to the Start Page!',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute<void>(
//                       builder: (BuildContext context) {
//                         return HomePage();
//                       },
//                     ),
//                   );
//                 },
//                 child: Text('Continue'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
