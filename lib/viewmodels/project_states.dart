import 'package:untitled8/models/projects.dart';

abstract class ProjectStates {}


class EmptyProjects extends ProjectStates{}
class loadingProjects extends ProjectStates{}
class loadedProjects extends ProjectStates{

  List<Project> project;

  loadedProjects({required this.project}) {

  }
}
class ErrorProjects extends ProjectStates{}