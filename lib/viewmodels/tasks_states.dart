import 'package:untitled8/models/tasks.dart';

abstract class TasksStates {}


class EmptyTasks extends TasksStates{}
class loadingTasks extends TasksStates{}
class loadedTasks extends TasksStates{

  List<Task> task;

  loadedTasks({required this.task}) {

  }
}
class ErrorProjects extends TasksStates{}