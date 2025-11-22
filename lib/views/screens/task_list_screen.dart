import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:untitled8/viewmodels/tasks_vm.dart';

import '../../models/tasks.dart';
import '../components/tasl_Card.dart'; // Import your TaskVm

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String? projectId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getProjectId();
  }

  void _getProjectId() {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments != null) {
      setState(() {
        projectId = arguments as String;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (projectId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Tasks")),
        body: const Center(child: Text('Project ID not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/add_task',
                arguments: projectId,
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Task>>(
        stream: TaskVm.getTasksStream(projectId!), // Use TaskVm instead of TaskService
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data ?? [];

          if (tasks.isEmpty) {
            return const Center(
              child: Text(
                'No tasks yet\nAdd your first task!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskCard(task: task, projectId: projectId!);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/add_task',
            arguments: projectId,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}