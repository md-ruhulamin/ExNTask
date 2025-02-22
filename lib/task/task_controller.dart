import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:note_app/database_helper.dart';
import 'package:note_app/task/task_home.dart';

import 'task.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks() async {
    taskList.value = await dbHelper.fetchTasks();
    print(taskList.value.length);
    taskList.value = taskList.reversed.toList();
  }

  Future<void> addTask(Task task) async {
    await dbHelper.insertTask(task);
    loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await dbHelper.updateTask(task);
    loadTasks();
  }

  Future<void> deleteTask(int taskId) async {
    await dbHelper.deleteTask(taskId);
    loadTasks();
  }

  Map<DateTime, List<Task>> groupTasksByDate(List<Task> tasks) {
    Map<DateTime, List<Task>> groupedTasks = {};

    for (var task in tasks) {
      // Get only the date part (year, month, day)
      DateTime date = DateTime(task.startDateTime.year,
          task.startDateTime.month, task.startDateTime.day);

      if (groupedTasks[date] == null) {
        groupedTasks[date] = [];
      }
      groupedTasks[date]!.add(task);
    }

    // Sort tasks within each date by time
    for (var date in groupedTasks.keys) {
      groupedTasks[date]!
          .sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
    }

    return groupedTasks;
  }

  Map<DateTime, List<Task>> expandAndGroupTasks(List<Task> tasks) {
    Map<DateTime, List<Task>> groupedTasks = {};

    for (var task in tasks) {
      DateTime currentDate = task.startDateTime;
      while (currentDate.isBefore(task.deadlineDateTime) ||
          currentDate.isAtSameMomentAs(task.deadlineDateTime)) {
        // Get only the date part (year, month, day)
        DateTime date =
            DateTime(currentDate.year, currentDate.month, currentDate.day);

        if (groupedTasks[date] == null) {
          groupedTasks[date] = [];
        }
        groupedTasks[date]!.add(task);

        // Move to the next day
        currentDate = currentDate.add(Duration(days: 1));
      }
    }

    return groupedTasks;
  }

  List<Task> filterTasksForDate(List<Task> tasks, DateTime date) {
    return tasks.where((task) {
      bool isWithinDateRange = !task.isDone &&
          task.startDateTime.isBefore(date.add(Duration(days: 1))) &&
          task.deadlineDateTime.isAfter(date.subtract(Duration(days: 1)));

      return isWithinDateRange;
    }).toList();
  }

  Map<DateTime, List<Task>> generateDailyTaskView(List<Task> tasks) {
    Map<DateTime, List<Task>> dailyTasks = {};
    DateTime today = DateTime.now();

    for (var task in tasks) {
      if (!task.isDone) {
        DateTime currentDate = task.startDateTime;

        // Add the task to each date from start date until end date, or until it's marked as done
        while (!currentDate.isAfter(task.deadlineDateTime)) {
          if (currentDate.isAfter(today) ||
              currentDate.isAtSameMomentAs(today)) {
            dailyTasks.putIfAbsent(currentDate, () => []).add(task);
          }
          currentDate = currentDate.add(Duration(days: 1));
        }
      }
    }

    return dailyTasks;
  }

  void setupDailyUpdate(Function updateTasks) {
    Timer.periodic(Duration(minutes: 1), (timer) {
      DateTime now = DateTime.now();
      if (now.hour == 0 && now.minute == 0) {
        // Refresh the task list at midnight
        updateTasks();
      }
    });
  }
}

enum TaskFilter { all, inProgress, pending, completed }

class TaskListView extends StatefulWidget {
  final List<Task> tasks;
  TaskListView({required this.tasks});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  String formatDateTime(DateTime dateTime) {
    // Format: dd-MM-yyyy HH:mm
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }

  final TaskController taskController = Get.find();
  TaskFilter _selectedFilter = TaskFilter.all;
  List<Task> getFilteredTasks() {
    switch (_selectedFilter) {
      case TaskFilter.completed:
        return widget.tasks.where((task) => task.taskColor == 4).toList();
      case TaskFilter.inProgress:
        return widget.tasks.where((task) => task.taskColor == 2).toList();
      case TaskFilter.pending:
        return widget.tasks.where((task) => task.taskColor == 3).toList();
      case TaskFilter.all:
      default:
        return widget.tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks = getFilteredTasks();

    final groupedTasks = taskController.groupTasksByDate(filteredTasks);
    final sortedDates = groupedTasks.keys.toList()..sort();
    return Column(

      
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2, bottom: 2),
          child: Wrap(
            spacing: 2.0,
            children: [
              ChoiceChip(
                labelPadding: EdgeInsets.all(0),
                label: Text('All',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                selected: _selectedFilter == TaskFilter.all,
                onSelected: (selected) {
                  
                  setState(() {
                    _selectedFilter = TaskFilter.all;
                  });
                },
              ),
              ChoiceChip(
                label: Text('Progress',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                selected: _selectedFilter == TaskFilter.inProgress,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = TaskFilter.inProgress;
                  });
                },
              ),
              ChoiceChip(
                label: Text('Pending',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                selected: _selectedFilter == TaskFilter.pending,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = TaskFilter.pending;
                  });
                },
              ),
              ChoiceChip(
                label: Text('Completed',style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                selected: _selectedFilter == TaskFilter.completed,
                onSelected: (selected) {
                  setState(() {
                    _selectedFilter = TaskFilter.completed;
                  });
                },
              ),
            ],
          ),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
          
            DateTime date = sortedDates[index];
            List<Task> dailyTasks = groupedTasks[date]!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Date Header
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${date.day}-${date.month}-${date.year}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                // List of tasks for that date
                ...dailyTasks.map((task) {
                  return TaskCard(
                    task: task,
                  );
                }).toList(),
              ],
            );
          },
        )),
      ],
    );
  }
}
