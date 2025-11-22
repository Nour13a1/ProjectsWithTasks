import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:untitled8/viewmodels/tasks_vm.dart';

import '../../models/projects.dart';
import '../../models/tasks.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final Project project;
  const ProjectDetailsScreen({super.key, required this.project});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(project.title ?? "Project Details"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final projectId = project.projectId ?? project.projectId;
          if (projectId != null) {
            Navigator.pushNamed(
              context,
              '/add_task',
              arguments: projectId,
            );
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("New Task"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // --- Project Info Section ---
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.title ?? "No Title",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    project.description ?? "No description available",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),

                  // Project Dates - FIXED DATE FORMATTING
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined,
                              color: Colors.indigo[400], size: 18),
                          const SizedBox(width: 6),
                          Text(
                            "Start: ${project.startAt != null ? dateFormat.format(project.startAt!) : 'Not set'}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.flag_outlined,
                              color: Colors.red[400], size: 18),
                          const SizedBox(width: 6),
                          Text(
                            "Due: ${project.endAt != null ? dateFormat.format(project.endAt!) : 'Not set'}",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Project Status and Progress
                  Row(
                    children: [
                      _buildStatusChip(project.status ?? 'Not Started'),
                      const Spacer(),
                      _buildProgressIndicator(project.progress ?? 0.0),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Divider
            Container(
              height: 8,
              color: Colors.grey[100],
            ),

            // --- Tasks Section ---
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tasks",
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Real Task List from Firestore
                    Expanded(
                      child: _buildTaskList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'completed':
        statusColor = Colors.green;
      case 'in progress':
        statusColor = Colors.orange;
      case 'not started':
        statusColor = Colors.grey;
      default:
        statusColor = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${(progress * 100).toStringAsFixed(0)}% Complete',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Container(
          width: 100,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            children: [
              Container(
                width: 100 * progress,
                decoration: BoxDecoration(
                  color: _getProgressColor(progress),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.3) return Colors.red;
    if (progress < 0.7) return Colors.orange;
    return Colors.green;
  }

  Widget _buildTaskList() {
    final projectId = widget.project.projectId ?? widget.project.projectId;

    if (projectId == null) {
      return const Center(
        child: Text('Project ID not found'),
      );
    }

    return StreamBuilder<List<Task>>(
      stream: TaskVm.getTasksStream(projectId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = snapshot.data ?? [];

        if (tasks.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.task_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No tasks yet',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  'Add your first task to get started',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: tasks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final task = tasks[index];
            return _TaskCard(
              task: task,
              projectId: projectId,
            );
          },
        );
      },
    );
  }
}

// --- Fixed Task Card Widget ---
class _TaskCard extends StatelessWidget {
  final Task task;
  final String projectId;

  const _TaskCard({
    required this.task,
    required this.projectId,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM');

    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Header with Title and Status
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Checkbox
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    TaskVm.toggleTaskCompletion(
                      projectId: projectId,
                      taskId: task.id,
                      isCompleted: value ?? false,
                    );
                  },
                ),

                // Title and Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted ? Colors.grey : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _statusColor(task.status).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          task.status,
                          style: TextStyle(
                            color: _statusColor(task.status),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Description
            if (task.description.isNotEmpty) ...[
              Text(
                task.description,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Task Footer with Assignee and Deadline
            Row(
              children: [
                // Assignee
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      task.assignee,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),

                const Spacer(),

                // Deadline
                Row(
                  children: [
                    Icon(Icons.flag_outlined, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      dateFormat.format(task.deadline),
                      style: TextStyle(
                        fontSize: 12,
                        color: task.isOverdue ? Colors.red : Colors.grey[600],
                        fontWeight: task.isOverdue ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}