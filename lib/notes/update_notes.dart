import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:note_app/notes/add_notes.dart';
import 'package:note_app/notes/note_controller.dart';
import 'package:note_app/notes/notes.dart';
import 'package:note_app/widget/app_bar.dart';

class UpdateNotes extends StatefulWidget {
  final Note note;
  UpdateNotes({super.key, required this.note});

  @override
  State<UpdateNotes> createState() => _UpdateNotesState();
}

class _UpdateNotesState extends State<UpdateNotes> {
  final NoteController noteController = Get.put(NoteController());

  @override
  void initState() {
    super.initState();
    noteController.backgroundColor.value = widget.note.color;
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
    final TextEditingController titlecontroller =
        TextEditingController(text: widget.note.title);
    final TextEditingController decsriptionController =
        TextEditingController(text: widget.note.description);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 60),
          child: CustomAppBar(title: "Update Notes")),
      body: Obx(
        () => Container(
          color: noteController.backgroundColor.value.withAlpha(80),
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                child: TextField(
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
              ),
              TextField(
                controller: decsriptionController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: 'Description',
                  border: InputBorder.none,
                ),
              ),
              Expanded(
                child: SizedBox(),
              ),
              SizedBox(
                height: 50,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: colors.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          noteController.backgroundColor.value = colors[index];
                        },
                        child: Container(
                          margin: EdgeInsets.all(2),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colors[index].withAlpha(80),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black12, width: 2),
                          ),    child:noteController.backgroundColor==colors[index]? Icon(Icons.done):SizedBox(),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
        onPressed: () {
          if (titlecontroller.text.isEmpty &&
              decsriptionController.text.isEmpty) {
            Get.snackbar("Empty", "Please Enter Title or Description",
                snackPosition: SnackPosition.BOTTOM);
          } else {
            print(titlecontroller.text);

            var newnote = Note(
                color: noteController.backgroundColor.value,
                noteId: widget.note.noteId,
                description: decsriptionController.text.toString(),
                title: titlecontroller.text.toString());

            noteController.updateNotes(newnote);

            titlecontroller.clear();
            decsriptionController.clear();
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
