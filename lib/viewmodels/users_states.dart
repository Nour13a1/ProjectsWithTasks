import 'package:untitled8/models/app_user.dart';

abstract class UsersStates {}


class EmptyUsers extends UsersStates{}
class loadingUsers extends UsersStates{}
class loadedUsers extends UsersStates {
   List<AppUser> users;

  loadedUsers({required this.users}) {

  }
}
class ErrorUsers extends UsersStates{}