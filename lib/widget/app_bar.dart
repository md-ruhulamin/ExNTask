import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/home/calender.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  const CustomAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.blue,
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: IconButton(
            onPressed: ()=>Get.to(Calender()),
            icon:Icon(Icons.calendar_month)),
        )
      ],
    );
  }
}
