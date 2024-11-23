// // ignore_for_file: public_member_api_docs, sort_constructors_first
// class Note {
//   final String title;
//   final String description;
//   final int noteId;
//   DateTime dateTime;

//   Note({
//     required this.description,
//     required this.noteId,
//     required this.title,
//     DateTime? dateTime,
//   }):dateTime = dateTime ?? DateTime.now();

//   // Method to convert Task to Map for database storage
//   Map<String, dynamic> toMap() {
//     return {
//       'noteId': noteId,
//       'description': description,
//       'title': title,
//       'dateTime': dateTime.toIso8601String(),
//     };
//   }

//   // Factory constructor to create a Task from a Map
//   factory Note.fromMap(Map<String, dynamic> map) {
//     return Note(
//       description: map['description'],
//       noteId: map['noteId'],
//       title: map['title'],
//       dateTime: DateTime.parse(map['dateTime']),
//     );
//   }

//   // Note copyWith({
//   //   String? title,
//   //   bool? isDone,
//   //   int? noteId,
//   //   DateTime? dateTime,
//   // }) {
//   //   return Note(
//   //     noteId: noteId ?? this.noteId,
//   //     title: title ?? this.title,
//   //     dateTime: dateTime ?? this.dateTime,
//   //     description: description ?? this.description,
//   //   );
//   // }
// }

import 'package:flutter/material.dart';

class Note {
  final String title;
  final String description;
  final int noteId;
  DateTime dateTime;
  Color color; // New color field

  Note({
    required this.title,
    required this.description,
    required this.noteId,
    this.color = const Color.fromARGB(255, 237, 236, 236), // Default color
    DateTime? dateTime,
  }) : dateTime = dateTime ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'noteId': noteId,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'color': color.value, // Convert Color to int
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      noteId: map['noteId'],
      title: map['title'],
      description: map['description'],
      dateTime: DateTime.parse(map['dateTime']),
      color: Color(map['color']), // Convert int back to Color
    );
  }
}
