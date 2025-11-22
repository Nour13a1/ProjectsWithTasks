import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled8/viewmodels/users_states.dart';

import '../models/app_user.dart';


import 'package:flutter_bloc/flutter_bloc.dart';

class UserVM extends Cubit<UsersStates> {
  List<AppUser> users = [];
  FirebaseFirestore _db = FirebaseFirestore.instance;

  UserVM() : super(EmptyUsers()); // Start with empty state

  Future<void> loadUserFromFirebase() async {
    try {
      // Emit loading state
      emit(loadingUsers());

      QuerySnapshot<Map<String, dynamic>> firebaseUser = await _db.collection("users").get();
      List<QueryDocumentSnapshot<Map<String, dynamic>>> userDocument = firebaseUser.docs;

      users = userDocument.map((item) => AppUser.fromJSON(item.data())).toList();

      // Debug print to verify data
      print('=== DEBUG: Loaded ${users.length} users from Firebase ===');
      for (var user in users) {
        print('User: ${user.name}');
      }

      // Emit loaded state with the users
      emit(loadedUsers( users:users));

    } catch (e) {
      print('Error loading users: $e');
      // Emit error state
      //emit(ErrorLoadingUsers(e.toString()));
    }
  }
}
/*
class UserVM extends Cubit<UsersStates>{

  List<AppUser> users =[];
  FirebaseFirestore _db = FirebaseFirestore.instance;

  //UserVM(super.initialState);
  UserVM():super(EmptyUsers());
  Future<List<AppUser>> loadUserFromFirebase() async
  {
    QuerySnapshot<Map<String,dynamic>> firebaseUser= await _db.collection("users").get();
    List<QueryDocumentSnapshot<Map<String,dynamic>>> userDocument=firebaseUser.docs;
    users = userDocument.map((item) => AppUser.fromJSON(item.data())).toList();
    return users;

    }
}
*/
