import 'package:untitled8/views/components/app_project_list.dart';
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
          leading: IconButton( // Left side button
            icon: const Icon(Icons.notes),
            onPressed: () {
              Navigator.pushNamed(context, '/notes');
            },
          ),
          actions: [ // Right side buttons
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.pushNamed(context, '/registers');
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

              return AppProjectList(projects: projects);
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