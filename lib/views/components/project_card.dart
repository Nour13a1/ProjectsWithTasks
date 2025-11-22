import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final int teamCount;
  final DateTime startDate;
  final DateTime deadline;
  final String projectId; // Add projectId
  final VoidCallback onTap;
/*  final VoidCallback onAddTask;
  final VoidCallback onListTask;// Add callback for task button*/

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.teamCount,
    required this.startDate,
    required this.deadline,
    required this.projectId,
    required this.onTap,
 /*   required this.onAddTask,
    required this.onListTask,*/
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and add task button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
               /* IconButton(
                  onPressed: onAddTask,
                  icon: Icon(Icons.add_task, color: Colors.blue),
                  tooltip: 'Add Task',
                ),
                IconButton(
                  onPressed: onListTask,
                  icon: Icon(Icons.task, color: Colors.blue),
                  tooltip: 'List tasks',
                ),*/
              ],
            ),
            SizedBox(height: 8),
            Text(description),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.people, size: 16),
                SizedBox(width: 4),
                Text('$teamCount members'),
                Spacer(),
                IconButton(
                  onPressed: onTap,
                  icon: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}