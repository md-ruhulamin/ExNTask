// update_task_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:note_app/task/task.dart';
import 'package:note_app/widget/app_bar.dart';
import 'package:note_app/widget/custom_text.dart';
import 'task_controller.dart';

enum TaskStatus { pending, inProgress, completed }

extension TaskStatusExtension on TaskStatus {
  String get displayName {
    switch (this) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
    }
  }
}

class TaskStatusDropdown extends StatefulWidget {
  final TaskStatus initialStatus;
  final Function(TaskStatus) onStatusChanged;

  TaskStatusDropdown({
    Key? key,
    required this.initialStatus,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  _TaskStatusDropdownState createState() => _TaskStatusDropdownState();
}

class _TaskStatusDropdownState extends State<TaskStatusDropdown> {
  late TaskStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<TaskStatus>(
      value: _selectedStatus,
      items: TaskStatus.values.map((TaskStatus status) {
        return DropdownMenuItem<TaskStatus>(
            value: status,
            child: Text(status.displayName,
                style: TextStyle(
                  fontFamily: 'Bitter',
                )));
      }).toList(),
      onChanged: (TaskStatus? newStatus) {
        if (newStatus != null) {
          setState(() {
            _selectedStatus = newStatus;
          });
          widget.onStatusChanged(newStatus);
        }
      },
      isExpanded: true,
      underline: Container(
        height: 1,
        color: Colors.grey,
      ),
      style: TextStyle(fontSize: 16, color: Colors.black),
    );
  }
}

class UpdateTaskScreen extends StatefulWidget {
  final Task task;

  UpdateTaskScreen({required this.task});

  @override
  _UpdateTaskScreenState createState() => _UpdateTaskScreenState();
}

class _UpdateTaskScreenState extends State<UpdateTaskScreen> {
  final TaskController taskController = Get.find();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late DateTime _startDateTime;
  late DateTime _endDateTime;
  late int _taskColor;
  late bool _isDone;

  @override
  void initState() {
    super.initState();
    // Initialize the fields with the existing task values
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);

    _startDateTime = widget.task.startDateTime;
    _endDateTime = widget.task.deadlineDateTime;
    _taskColor = widget.task.taskColor!;
    _isDone = widget.task.isDone;
    getStatus();
  }

  void getStatus() {
    if (widget.task.taskColor == 4) {
      currentStatus = TaskStatus.completed;
    } else if (widget.task.taskColor == 2)
      // ignore: curly_braces_in_flow_control_structures
      currentStatus = TaskStatus.inProgress;
    // ignore: curly_braces_in_flow_control_structures
    else if (widget.task.taskColor == 3) currentStatus = TaskStatus.pending;
  }

  Future<void> _pickDateTime(BuildContext context, bool isStart) async {
    // Pick the date
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDateTime : _endDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime day) {
        // Only allow days from today onward
        return day.isAfter(DateTime.now().subtract(const Duration(days: 1)));
      },
    );

    if (pickedDate != null) {
      // Pick the time
      final pickedTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(isStart ? _startDateTime : _endDateTime),
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
            _startDateTime = pickedDateTime;
          } else {
            _endDateTime = pickedDateTime;
          }
        });
      }
    }
  }

  String formatDateTime(DateTime dateTime) {
    // Format: dd-MM-yyyy HH:mm
    return DateFormat('dd-MM-yyyy  HH:mm').format(dateTime);
  }

  void _updateTask() {
    if (_titleController.text.isEmpty) {
      Get.snackbar("Empty", "Please Enter a  Title",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    if (_endDateTime != null && _endDateTime!.isBefore(_startDateTime!)) {
      // Swap dates if the end date is before the start date
      final temp = _endDateTime;
      _endDateTime = _startDateTime;
      _startDateTime = temp;
 //     Get.snackbar("Update", "Start and End Date is Exchanged");
    }
    // Update the task with new data
    final updatedTask = Task(
      taskId: widget.task.taskId, // Keep the same id
      title: _titleController.text,
      description: _descriptionController.text,
      isDone: _isDone,

      startDateTime: _startDateTime,
      deadlineDateTime: _endDateTime,
      taskColor: _taskColor,
    );

    taskController.updateTask(updatedTask);
    Get.back(); // Close the form after saving
  }

  late TaskStatus currentStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(double.infinity, 60),
          child: CustomAppBar(title: "Update Tasks")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(
              height: 5,
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
            // TextField(
            //   controller: _noteController,
            //   decoration: InputDecoration(labelText: 'Note'),
            // ),
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
                      text: "${formatDateTime(_startDateTime)}",
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
                      text: "${formatDateTime(_endDateTime)}",
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
            //         pickerColor: _taskColor,
            //         onColorChanged: (color) =>
            //             setState(() => _taskColor = color),
            //       ),
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
        onPressed: _updateTask,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
    );
  }
}
