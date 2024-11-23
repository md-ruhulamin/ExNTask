import 'package:flutter/material.dart';
import 'package:note_app/database_helper.dart';
import 'package:note_app/home/home.dart';
import 'package:note_app/widget/custom_text.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 245, 255),
      body: Stack(children: [
        Positioned(
            left: 20,
            top: 180,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Center(
                  child: Row(
                children: [
                  Image.asset(
                    "assets/wallet.png",
                    height: 130,
                  ),
                ],
              )),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: CustomText(
                  text: "Track Your\nExpenses | Notes | Tasks",
                  size: 27,
                  maxLine: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: CustomText(
                  text:
                      "All Your Expenses Bill,Credit,\nCard ,Savings and other Expenses,\n Notes,Tasks in one place.",
                  size: 20,
                  maxLine: 3,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                    style: OutlinedButton.styleFrom(
                        minimumSize: Size(270, 45),
                        padding: EdgeInsets.only(
                            left: 30, right: 30, top: 10, bottom: 10),
                        backgroundColor: Colors.blueAccent),
                    onPressed: () async {
                      await DatabaseHelper.instance
                          .setFirstTimeComplete(); // Mark onboarding as completed
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Text(
                      "Get Started",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ])),
      ]),
    );
  }
}
