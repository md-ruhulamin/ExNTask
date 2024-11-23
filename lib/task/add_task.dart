// add_task_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:note_app/task/task.dart';
import 'package:note_app/task/update_task.dart';
import 'package:note_app/widget/app_bar.dart';
import 'package:note_app/widget/custom_text.dart';
import 'task_controller.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TaskController taskController = Get.find();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  int _taskColor = 3;
  bool _isDone = false;
  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      23,
      59,
    );
  }

  Future<void> _pickDateTime(BuildContext context, bool isStart) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime day) {
        // Only allow days from today onward
        return day.isAfter(DateTime.now().subtract(const Duration(days: 1)));
      },
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (isStart) {
            _startDate = pickedDateTime;
          } else {
            _endDate = pickedDateTime;
          }
        });
      }
    }
  }

  TaskStatus currentStatus = TaskStatus.pending;

  void _saveTask() {
    if (_titleController.text.isEmpty ||
        _startDate == null ||
        _endDate == null) {
      Get.snackbar("Empty", "Please Enter a  Title",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (_endDate != null && _endDate!.isBefore(_startDate!)) {
      // Swap dates if the end date is before the start date
      final temp = _endDate;
      _endDate = _startDate;
      _startDate = temp;
     // Get.snackbar("Update", "Start and End Date is Exchanged");
    }
    final task = Task(
      taskId: DateTime.now().millisecondsSinceEpoch,
      title: _titleController.text,
      description: _descriptionController.text,
      isDone: _isDone,
      startDateTime: _startDate!,
      deadlineDateTime: _endDate!,
      taskColor: _taskColor,
    );

    taskController.addTask(task);
    Get.back(); // Close the form
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy  HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 60),
          child: CustomAppBar(title: "Add Tasks")),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            TextField(
              maxLines: 1,
              controller: _titleController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Title'),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                  labelText: 'Description', border: OutlineInputBorder()),
            ),
            SwitchListTile(
              title: Text("Is Emergency"),
              value: _isDone,
              onChanged: (value) => setState(() => _isDone = value),
            ),
            ListTile(
              title: RichText(
                text: TextSpan(
                  text: "Start Date & Time:\n",
                  style: GoogleFonts.lato(
                    textStyle:
                        TextStyle(color: Colors.black, letterSpacing: .5),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "${formatDateTime(_startDate!)}",
                      style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(color: Colors.blue, letterSpacing: .5),
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _pickDateTime(context, true),
            ),
            ListTile(
              title: RichText(
                text: TextSpan(
                  text: "End Date & Time:\n",
                  style: GoogleFonts.lato(
                    textStyle:
                        TextStyle(color: Colors.black, letterSpacing: .5),
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: "${formatDateTime(_endDate!)}",
                      style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(color: Colors.blue, letterSpacing: .5),
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () => _pickDateTime(context, false),
            ),
            // ListTile(
            //   title: Text('Pick Task Color'),
            //   trailing: CircleAvatar(backgroundColor: _taskColor),
            //   onTap: () => showDialog(
            //     context: context,
            //     builder: (context) => AlertDialog(
            //       content: BlockPicker(
            //           pickerColor: _taskColor,
            //           onColorChanged: (color) {
            //             setState(() => _taskColor = color);
            //           }),
            //     ),
            //   ),
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomText(text: "Status: "),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: TaskStatusDropdown(
                    initialStatus: currentStatus,
                    onStatusChanged: (TaskStatus newStatus) {
                      if (newStatus == TaskStatus.completed) {
                        _taskColor = 4;
                      } else if (newStatus == TaskStatus.inProgress) {
                        _taskColor = 2;
                      } else if (newStatus == TaskStatus.pending) {
                        _taskColor = 3;
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.blue,
        shape: CircleBorder(),
        onPressed: _saveTask,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
