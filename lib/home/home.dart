import 'package:flutter/material.dart';
import 'package:note_app/expences/expenses_home.dart';
import 'package:note_app/notes/add_notes.dart';
import 'package:note_app/notes/notes_home.dart';
import 'package:note_app/task/task_home.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> screenList = [
    ExpensesHome(),
    TaskScreen(),
    NoteScreen(),
     
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screenList[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_outlined), label: "Expense"),
            BottomNavigationBarItem(icon: Icon(Icons.task), label: "Task"),
            BottomNavigationBarItem(
                icon: Icon(Icons.edit_note_sharp), label: "Note"),
            
          ],
          unselectedItemColor: Colors.blue,
          currentIndex: selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: (int index) {
            setState(() {
              selectedIndex = index;
            });
          }),
    );
  }
}
