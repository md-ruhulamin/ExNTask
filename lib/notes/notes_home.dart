import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:note_app/notes/add_notes.dart';
import 'package:note_app/notes/note_controller.dart';
import 'package:intl/intl.dart';
import 'package:note_app/notes/update_notes.dart';
import 'package:note_app/widget/app_bar.dart';

class NoteScreen extends StatelessWidget {
  final NoteController noteController = Get.put(NoteController());

  @override
  Widget build(BuildContext context) {
    String formatDateTime(DateTime dateTime) {
      // Format: dd-MM-yyyy HH:mm
      return DateFormat('dd-MM-yyyy  HH:mm').format(dateTime);
    }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 60),
          child: CustomAppBar(title: "All Notes")),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Obx(() {
          if (noteController.noteList.isEmpty) {
            return Center(child: Text("No Notes available"));
          }
          return MasonryGridView.builder(
              itemCount: noteController.noteList.length,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
              itemBuilder: (context, index) {
                if (noteController.noteList.length == 0) {
                  return Center(
                    child: Text("No Notes Found"),
                  );
                } else {
                  final note = noteController.noteList[index];
                  return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color.fromARGB(255, 215, 215, 215),
                            width: 1)),
                    child: InkWell(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Are You want to delete this note?"),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    noteController.deleteNote(note.noteId);
                                    Navigator.pop(context);
                                  },
                                  child: Text("Delete"),
                                )
                              ],
                            );
                          },
                        );
                      },
                      onTap: () {
                        Get.to(UpdateNotes(note: note));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: note.color.withAlpha(80),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.title,
                              overflow: TextOverflow.visible,
                              maxLines: 1,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            Text(
                              note.description,
                              overflow: TextOverflow.visible,
                              maxLines: 8,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 14),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              formatDateTime(note.dateTime),
                              overflow: TextOverflow.visible,
                              maxLines: 2,
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              });
        }),
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Get.to(AddNotes());
        },
      ),
    );
  }

  Color getRandomPrimaryColor() {
    Random random = Random();
    return Colors.primaries[random.nextInt(Colors.primaries.length)].shade100;
  }
}
