import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/notes/note_controller.dart';
import 'package:note_app/notes/notes.dart';
import 'package:note_app/widget/app_bar.dart';

class AddNotes extends StatefulWidget {
  AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  final NoteController noteController = Get.put(NoteController());
  int selectedindex = 0;
  @override
  void initState() {
    super.initState();
    noteController.backgroundColor.value = Colors.white;
  }

  List<Color> colors = [
    Colors.white,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
    Colors.cyan,
    Colors.teal,
    Colors.indigo,
    Colors.lime,
    Colors.amber,
    Colors.deepOrange,
    Colors.lightGreen,
    Colors.deepPurple,
    Colors.lightBlue,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    final TextEditingController titlecontroller = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    return Scaffold(
      backgroundColor: noteController.backgroundColor.value,
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 60),
          child: CustomAppBar(title: "Add Notes")),
      body: Obx(
        () => Container(
          color: noteController.backgroundColor.value.withAlpha(80),
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: titlecontroller,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    labelStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight
                          .bold), // This sets the text style for typed text
                ),
                TextField(
                  controller: descriptionController,
                  maxLines: 8,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    border: InputBorder.none,
                  ),
                ),
                Expanded(child: SizedBox()),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: colors.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            noteController.backgroundColor.value =
                                colors[index];
                                selectedindex=index;
                          },
                          child: Container(
                            margin: EdgeInsets.all(2),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: colors[index].withAlpha(80),
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.black12, width: 2),
                            ),
                            child:selectedindex==index? Icon(Icons.done):SizedBox(),
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
        onPressed: () {
          if (titlecontroller.text.isEmpty &&
              descriptionController.text.isEmpty) {
            Get.snackbar("Empty", "Please Enter Title or Description");
          } else {
            print(titlecontroller.text);
            int timestamp = DateTime.now().millisecondsSinceEpoch;
            var newnote = Note(
                noteId: timestamp,
                color: noteController.backgroundColor.value,
                description: descriptionController.text.toString(),
                title: titlecontroller.text.toString());

            noteController.addNotes(newnote);

            titlecontroller.clear();
            descriptionController.clear();
            Navigator.pop(context);
          }
        },
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ColorChangeScreen extends StatefulWidget {
  @override
  _ColorChangeScreenState createState() => _ColorChangeScreenState();
}

class _ColorChangeScreenState extends State<ColorChangeScreen> {
  // List of colors to choose from
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
  ];

  // Initial background color
  Color backgroundColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Choose Background Color'),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Tap a color below to change the background',
                style: TextStyle(fontSize: 20, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: colors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      backgroundColor = color;
                    });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12, width: 2),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
