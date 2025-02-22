// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:note_app/database_helper.dart';
import 'package:note_app/home/home.dart';
import 'package:note_app/home/onboarding.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'notes/notes_home.dart';

Future<void> main() async {
  // Initialize database factory for desktop platforms
  if (isDesktopPlatform()) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  WidgetsFlutterBinding.ensureInitialized();
  final bool isFirstTime = await DatabaseHelper.instance.checkIfFirstTime();
  runApp(MyApp(isFirstTime: isFirstTime));
}

bool isDesktopPlatform() {
  return identical(0, 0.0) ||
      identical(1, 1.0); // Detects if running on desktop (non-mobile)
}

// GoogleFonts.bitterTextTheme(

//           Theme.of(context).textTheme,
//         ),

class MyApp extends StatelessWidget {
  final bool isFirstTime;

  MyApp({required this.isFirstTime});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Bitter',
      ),
      title: 'Task Manager',
      home: isFirstTime ? OnboardingScreen() : HomeScreen(),
    );
  }
}

// void main() {
//   // Initialize database factory for desktop platforms

//   runApp(MyApp());
// }

// // GoogleFonts.bitterTextTheme(

// //           Theme.of(context).textTheme,
// //         ),

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         fontFamily: 'Bitter',
//       ),
//       title: 'Task Manager',
//       home:MathEvaluator() ,
//     );
//   }
// }

// class MathEvaluator extends StatefulWidget {
//   @override
//   _MathEvaluatorState createState() => _MathEvaluatorState();
// }

// class _MathEvaluatorState extends State<MathEvaluator> {
//   final TextEditingController _controller = TextEditingController();
//   String _result = "";

//   void evaluateExpression() {
//     String input = _controller.text;
//     final validCharacters = RegExp(r'^[\d\s\+\-\*\/\(\)\.]+$');
//     if (!validCharacters.hasMatch(input)) {
//       setState(() {
//         _result = "Invalid expression";
//       });
//       return;
//     }

   
//     try {
//       final expression = Expression.parse(input);
//       final evaluator = const ExpressionEvaluator();
//       final result = evaluator.eval(expression, {});
//       setState(() {
//         _result = "Result: $result";
//       });
//     } catch (e) {
//       setState(() {
//         _result = "Error: Invalid expression";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Math Expression Evaluator")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 labelText: "Enter a math expression",
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: evaluateExpression,
//               child: Text("Evaluate"),
//             ),
//             SizedBox(height: 20),
//             Text(_result, style: TextStyle(fontSize: 18)),
//           ],
//         ),
//       ),
//     );
//   }
// }
