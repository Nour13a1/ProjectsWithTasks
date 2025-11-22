import 'package:untitled8/views/screens/project_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/projects.dart';
import '../../viewmodels/project_states.dart';
import '../../viewmodels/projects_vm.dart';
import '../components/project_card.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProjectVm()..loadProjectsFromFirebase(), // تحميل المشاريع من Firebase عند البدء
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Projects"),
          actions: [
           /* Padding(
              padding: const EdgeInsets.only(right: 12),
              child: CircleAvatar(
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.chat, color: Colors.black87),
              ),
            ),*/
            IconButton(
              icon: const Icon(Icons.notes),
              onPressed: () {
                Navigator.pushNamed(context, '/notes');
              },
            ),
          ],
        ),
        body:
        BlocBuilder<ProjectVm, ProjectStates>(
          builder: (context, state) {
            if (state is loadingProjects) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is loadedProjects) {
              final projects = state.project;

              if (projects.isEmpty) {
                return const Center(child: Text("No projects found."));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  Project project = projects[index];
                  return ProjectCard(
                    title: project.title ?? "No title",
                    description: project.description ?? "No description",
                    teamCount: project.users?.length ?? 0,
                    startDate: project.startAt ?? DateTime.now(),
                    deadline: project.endAt ?? DateTime.now(),
                    projectId: project.projectId ?? '', // Pass the project ID
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/project_details',
                        arguments: project, // Pass the full project object
                      );
                    },
                   /* onAddTask: () {
                      // Navigate to Add Task screen with project ID
                      print('Project ID being sent: ${project.projectId}');
                      print('Project object: $project');

                      Navigator.pushNamed(
                        context,
                        '/add_task',
                        arguments: project.projectId, // Pass project ID as argument
                      );

                    },*/
                   /* onListTask: () {
                      // Navigate to Add Task screen with project ID
                      print('Project ID being sent: ${project.projectId}');
                      print('Project object: $project');

                      Navigator.pushNamed(
                        context,
                        '/taskList',
                        arguments: project.projectId, // Pass project ID as argument
                      );

                    },*/
                  );
                },
              );
            }  else {
              return const SizedBox();
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.pushNamed(context, '/add_Project'),
          label: const Text("Add Project"),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}