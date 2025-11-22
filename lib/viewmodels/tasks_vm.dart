/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TaskVm extends Cubit{
  TaskVm(super.initialState);
  static Future<void> saveTaskTofirebase({required String projectId,required String title, required String description,required DateTime startDate,required DateTime deadline,required String assignee,required String imagePath,required double isCompleted,  required DateTime createdAt, required DateTime updatedAt}) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      //DocumentReference taskRef = db.collection("tasks").doc();
      DocumentReference taskRef = db.collection("projects").doc(projectId).collection("tasks").doc();

      await taskRef.set({
        "id": taskRef.id,
        "title": title,
        "description": description,
        "startDate": startDate,
        "deadline": deadline,
        "assignee": assignee,
        "imagePath": imagePath,
        "isCompleted": isCompleted,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      });
      print("Project saved successfully with ID: ${taskRef.id}");

    } catch (e) {
      print("Error saving project: $e");

    }
  }
}*/
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/tasks.dart';

class TaskVm {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reference to tasks subcollection
  static CollectionReference _tasksCollection(String projectId) {
    return _firestore.collection('projects').doc(projectId).collection('tasks');
  }

  // Save task method (you already have this)
  static Future<void> saveTaskTofirebase({
    required String projectId,
    required String title,
    required String description,
    required DateTime startDate,
    required DateTime deadline,
    required String assignee,
    required String? imagePath,
    required bool isCompleted,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) async {
    final taskRef = _tasksCollection(projectId).doc();
    await taskRef.set({
      'title': title,
      'description': description,
      'startDate': Timestamp.fromDate(startDate),
      'deadline': Timestamp.fromDate(deadline),
      'assignee': assignee,
      'imagePath': imagePath,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    });
  }

  // Get tasks stream
  static Stream<List<Task>> getTasksStream(String projectId) {
    return _tasksCollection(projectId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Task.fromFirestore(doc))
        .toList());
  }

  // Toggle task completion
  static Future<void> toggleTaskCompletion({
    required String projectId,
    required String taskId,
    required bool isCompleted,
  }) async {
    await _tasksCollection(projectId).doc(taskId).update({
      'isCompleted': isCompleted,
      'updatedAt': Timestamp.now(),
    });
  }

  // Delete task
  static Future<void> deleteTask({
    required String projectId,
    required String taskId,
  }) async {
    await _tasksCollection(projectId).doc(taskId).delete();
  }

  // Get tasks by status (optional)
  static Stream<List<Task>> getTasksByStatus(String projectId, String status) {
    Query query = _tasksCollection(projectId);

    switch (status) {
      case 'Completed':
        query = query.where('isCompleted', isEqualTo: true);
        break;
      case 'Overdue':
        final now = Timestamp.now();
        query = query
            .where('isCompleted', isEqualTo: false)
            .where('deadline', isLessThan: now);
        break;
      default:
      // Handle other statuses
        break;
    }

    return query.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Task.fromFirestore(doc))
        .toList());
  }
}