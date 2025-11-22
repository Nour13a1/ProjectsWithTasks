import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  //final String projectId;
  final String description;
  final DateTime startDate;
  final DateTime deadline;
  final String assignee;
  final String? imagePath;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    String? id,
    required this.title,
    //required this.projectId,
    required this.description,
    required this.startDate,
    required this.deadline,
    this.assignee = 'Unassigned',
    this.imagePath,
    this.isCompleted = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // Convert Task to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
     // 'projectId': projectId,
      'startDate': startDate.millisecondsSinceEpoch,
      'deadline': deadline.millisecondsSinceEpoch,
      'assignee': assignee,
      'imagePath': imagePath,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  // Create Task from Map
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      startDate: _parseDate(map['startDate']),
      deadline: _parseDate(map['deadline']),
      assignee: map['assignee'] ?? 'Unassigned',
      imagePath: map['imagePath'],
      isCompleted: map['isCompleted'] ?? false,
      createdAt: _parseDate(map['createdAt']),
      updatedAt: _parseDate(map['updatedAt']),
    );
  }
  static DateTime _parseDate(dynamic date) {
    if (date is Timestamp) {
      return date.toDate();
    } else if (date is int) {
      return DateTime.fromMillisecondsSinceEpoch(date);
    } else if (date is String) {
      return DateTime.tryParse(date) ?? DateTime.now();
    } else {
      return DateTime.now();
    }
  }
  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Task.fromMap({
      'id': doc.id, // Include the document ID
      ...data, // Spread all the data from Firestore
    });
  }
  // Create a copy of task with updated fields
  Task copyWith({
    String? title,
    String? description,
    DateTime? startDate,
    DateTime? deadline,
    String? assignee,
    String? imagePath,
    bool? isCompleted,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      //projectId: description ?? this.projectId,
      startDate: startDate ?? this.startDate,
      deadline: deadline ?? this.deadline,
      assignee: assignee ?? this.assignee,
      imagePath: imagePath ?? this.imagePath,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  // Helper method to check if task is overdue
  bool get isOverdue => !isCompleted && deadline.isBefore(DateTime.now());

  // Helper method to get task status
  String get status {
    if (isCompleted) return 'Completed';
    if (isOverdue) return 'Overdue';
    if (DateTime.now().isAfter(startDate)) return 'In Progress';
    return 'Upcoming';
  }

  // Helper method to get days remaining
  int get daysRemaining => deadline.difference(DateTime.now()).inDays;

  @override
  String toString() {
    return 'Task(id: $id, title: $title, status: $status, deadline: $deadline)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}