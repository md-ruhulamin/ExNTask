// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:note_app/notes/note_controller.dart';
import 'package:note_app/task/add_task.dart';
import 'package:note_app/task/task.dart';
import 'package:note_app/task/task_controller.dart';
import 'package:note_app/task/update_task.dart';
import 'package:note_app/widget/app_bar.dart';
import 'package:note_app/widget/custom_text.dart';

class TaskScreen extends StatelessWidget {
  final TaskController taskController = Get.put(TaskController());
  final NoteController noteController = Get.put(NoteController());
  String formatDateTime(DateTime dateTime) {
    // Format: dd-MM-yyyy HH:mm
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 60),
          child: CustomAppBar(title: "All Tasks")),
      body: Obx(() {
        if (taskController.taskList.isEmpty) {
          return Center(child: Text("No tasks available"));
        }
        return Container(
          height: double.infinity,
          padding: EdgeInsets.only(left: 10, right: 5),
          child: TaskListView(tasks: taskController.taskList),
        );
      }),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Get.to(AddTaskScreen());
        },
      ),
    );
  }

  Color getRandomPrimaryColor() {
    Random random = Random();
    return Colors.primaries[random.nextInt(Colors.primaries.length)].shade100;
  }
}

class TaskCard extends StatefulWidget {
  Task task;
  TaskCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  final TaskController taskController = Get.put(TaskController());
  final NoteController noteController = Get.put(NoteController());
  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yy  HH:mm').format(dateTime);
  }

  String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  String formatDuration(Duration difference) {
    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;

    if (days == 0 && hours == 0 && minutes == 0) {
      return "0M"; // No time difference
    } else if (days == 0 && hours == 0) {
      return "${minutes}M"; // Only minutes
    } else if (days == 0 && minutes == 0) {
      return "${hours}H"; // Only hours
    } else if (hours == 0 && minutes == 0) {
      return "${days}D"; // Only days
    } else if (days == 0) {
      return "${hours}H ${minutes}M"; // Hours and minutes
    } else if (hours == 0) {
      return "${days}D ${minutes}M"; // Days and minutes
    } else if (minutes == 0) {
      return "${days}D ${hours}H"; // Days and hours
    } else {
      return "${days}D ${hours}H ${minutes}M"; // All components
    }
  }

  String calculateDifference(DateTime start, DateTime end) {
    Duration difference = end.difference(start);
    return formatDuration(difference);
  }

  @override
  Widget build(BuildContext context) {
    Task task = widget.task;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          children: [
            Container(
              width: 2,
              height: 60,
              color: Colors.grey,
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Color(task.taskColor!).withAlpha(30)),
              child: Text(
                formatTime(task.startDateTime),style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            // if (index != taskController.taskList.length)
            Container(
              width: 2,
              height: 60,
              color: Colors.grey,
            ),
          ],
        ),
        SizedBox(width: 4), // Space between timeline and content
        Expanded(
          child: InkWell(
            child: Container(
              height: 120,
              padding: EdgeInsets.only(bottom: 5, left: 10, right:10,top:5),
              margin: EdgeInsets.only(top: 3, right: 5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withAlpha(80)),
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 234, 243, 248)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 220, // Adjust width as needed
                        child: Text(
                          task.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 46, 45, 45),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      InkWell(
                   //   style:IconButton.styleFrom(backgroundColor: Colors.yellow),
                          onTap: () {
                            taskController.updateTask(
                                task.copyWith(isDone: !task.isDone));
                          },
                          child: task.isDone
                              ? Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : Icon(
                                  Icons.favorite_border_outlined,
                                  color: Colors.red,
                                ))
                    ],
                  ),
                  Text(
                    task.description ?? "",
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                    textAlign: TextAlign.justify,
                    style:
                        TextStyle(color: const Color.fromARGB(255, 93, 92, 92)),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Due :${formatDateTime(task.deadlineDateTime)}",
                        maxLine: 1,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        size: 12,
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5, vertical: 2),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.amber.withAlpha(230)),
                            child: Text(
                                calculateDifference(
                                    DateTime.now(), task.deadlineDateTime),
                                style: TextStyle(
                                    color: Colors.white,
                              //      fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ),
                          SizedBox(
                            width:2,
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 2),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: task.taskColor == 4
                                      ? Colors.purple
                                      : task.taskColor == 3
                                          ? Colors.redAccent
                                          : Colors.green),
                              child: task.taskColor == 4
                                  ? Text(
                                      "Completed",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    )
                                  : task.taskColor == 2
                                      ? Text(
                                          "Progress",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        )
                                      : Text(
                                          "Pending",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12),
                                        ))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            onTap: () {
              Get.to(UpdateTaskScreen(task: task));
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Are you want to delete this task?"),
                    actions: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          taskController.deleteTask(task.taskId);
                          Navigator.pop(context);
                        },
                        child: Text("Delete"),
                      )
                    ],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
