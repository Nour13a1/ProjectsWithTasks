import 'package:flutter/material.dart';
import 'package:untitled8/models/projects.dart';
import 'package:untitled8/views/components/project_card.dart';

class AppProjectList extends StatelessWidget {
  final List<Project> projects;

  const AppProjectList({super.key, required this.projects});
  //const AppProjectList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        return ProjectCard(
          title: project.title!,
          description: project.description!,
          teamCount: 5 + index,
          startDate: DateTime.now().subtract(Duration(days: index * 3)),
          deadline: DateTime.now().add(Duration(days: (index + 1) * 10)),
          onTap: () => Navigator.pushNamed(context, '/projectDetails'), projectId: '',
        );
      }
    );


  }
}
