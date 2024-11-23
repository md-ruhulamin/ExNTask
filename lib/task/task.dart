class Task {
  int taskId;
  String title;
  String? description;
  bool isDone;
  DateTime startDateTime;
  DateTime deadlineDateTime;
  int? taskColor;

  Task({
    required this.taskId,
    required this.title,
    this.description,
    this.isDone = false,
    DateTime? startDateTime,
    DateTime? deadlineDateTime,
    this.taskColor,
  })  : startDateTime = startDateTime ?? DateTime.now(),
        deadlineDateTime = deadlineDateTime ??
            DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day);

  Map<String, dynamic> toMap() {
    return {
      'taskId': taskId,
      'title': title,
      'description': description,
      'isDone': isDone ? 1 : 0,
      'startDateTime': startDateTime.toIso8601String(),
      'deadlineDateTime': deadlineDateTime.toIso8601String(),
      'taskColor': taskColor,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      taskId: map['taskId'],
      title: map['title'],
      description: map['description'],
      isDone: map['isDone'] == 1,
      startDateTime: DateTime.parse(map['startDateTime']),
      deadlineDateTime: DateTime.parse(map['deadlineDateTime']),
      taskColor: map['taskColor'],
    );
  }
  Task copyWith(
      {int? taskId,
      String? title,
      String? description,
      bool? isDone,
      int? taskColor,
      DateTime? startDateTime,
      DateTime? deadlineDateTime}) {
    return Task(
        taskId: taskId ?? this.taskId,
        title: title ?? this.title,
        description: description ?? this.description,
        isDone: isDone ?? this.isDone,
        startDateTime: startDateTime ?? this.startDateTime,
        deadlineDateTime: deadlineDateTime ?? this.deadlineDateTime,
        taskColor: taskColor ?? this.taskColor);
  }
}
 List<String> notes = [
      "he team on the projectSubmit expense reports from last month by the end of the day.",
      "Grocery shopping: eggs, milk, bread, and vegetables.Remember to follow up with the team on the project updates.Remember to follow up with the team on the project updates.Remember to follow up with the team on the project updates.Remember to follow up with the team on the project updates.",
      "Complete the monthly budget review before Friday.Remember to follow up with the team on the project updates.",
      "Plan the weekend trip - book a hotel and check the weather forecast.",
      "Check the new policy update from HR and confirm any changes.Remember to follow up with the team on the project updates.",
      "Call the plumber to fix the kitchen sink before next week.",
      "Schedule annual health check-up and dental appointment.",
      "Brainstorm ideas",
      "Prepare and send out invitations for John's farewell party.Remember to follow up with the team on the project updates.Remember to follow up with the team on the project updates.",
      "Finish the final draft of the report by the end of the week.",
      "Review and sign off on the design proposals for the new website.",
      "Research potential venues for the company retreat, considering the budget.Remember to follow up with the team on the project updates.Remember to follow up with the team on the project updates.Remember to follow up with the team on the project updates.Remember to follow up with the team on the project updates.",
      "Book flights and accommodations for the upcoming business trip to San Francisco.",
      "Submit expense reports from last month by the end of the day.Submit expense reports from last month by the end of the day.Submit expense reports from last month by the end of the day.",
      "Organize the workshop material for the team training next month.Submit expense reports from last month by the end of the day.Submit expense reports from last month by the end of the day.Submit expense reports from last month by the end of the day.Submit expense reports from last month by the end of the day.Submit expense reports from last month by the end of the day.",
      "Read up on the latest industry trend",
      "Gather feedback from the last client meeting and prepare a follow-up plan.",
      "Read up on the latest industry trend",
      "Gather feedback from the last client meeting and prepare a follow-up plan.",
      "Update the portfolio with re with potential clients.Submit expense reports from last month by the end of the day.",
      "Organize the monthly team meeting, set the agenda, and send invites.Submit expense reports from last month by the end of the day.",
      "Refine the goals for Q4 to ensure alignment with the annual objectives.Submit expense reports from last month by the end of the day.Submit expense reports from last month by the end of the day."
          "Update the portfolio with re with potential clients.Submit expense reports from last month by the end of the day.",
      "Organize the monthly team meeting, set the agenda, and send invites.Submit expense reports from last month by the end of the day.",
      "Refine the goals for Q4 to ensure alignment with the annual objectives.Submit expense reports from last month by the end of the day.Submit expense reports from last month by the end of the day."
    ];