import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled8/models/projects.dart';
import 'package:untitled8/viewmodels/project_states.dart';

class ProjectVm extends Cubit<ProjectStates>{
  FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Project> project =[];
  ProjectVm():super(EmptyProjects());
 /*saveProjectTofirebase(){
    _db.collection("projects").doc("").collection("tasks").add("data");
  }*/
  static Future<void> saveProjectTofirebase({required String title, required String description,required List users,required String endAt,required String createdAt,required String status,required double progress}) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentReference projectRef = db.collection("projects").doc();

      await projectRef.set({
        "projectId": projectRef.id,
        "title": title,
        "description": description,
        "users": users,
        "createdAt": createdAt,
        "endAt": createdAt,
        "status": status,
        "progress": progress,
      });
      print("Project saved successfully with ID: ${projectRef.id}");

    } catch (e) {
      print("Error saving project: $e");

    }
  }
  static Future<Project?> getProjectById(String projectId) async {
    try {
       final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final doc = await _firestore.collection('projects').doc(projectId).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return Project.fromJson({
          'projectId': doc.id,
          ...data,
        });
      }
      return null;
    } catch (e) {
      print("Error getting project: $e");
      return null;
    }
  }
  /*saveProjectTofirebase() async{

    //await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);


    FirebaseFirestore db = FirebaseFirestore.instance;

      db.collection("projects").doc("").collection("tasks").add({
        "projectId": "1",
        "title": "New Project",

        "description" : "New Project description",
        "users" : ["Nour","Noor"],

      });
      //QuerySnapshot<Map<String,dynamic>> documnets = await db.collection("users").where("city" , whereIn: ["aden","sana"]).get();
      QuerySnapshot<Map<String,dynamic>> documnets = await db.collection("users").get();
      // dosn't make any refresh for page value changed directly
      db.collection("users").snapshots();
      QueryDocumentSnapshot record =  documnets.docs[0];
      (record.data() as Map<String,dynamic>)["id"];

      documnets.docs.forEach((item){
        Map<String,dynamic> row = item.data();
      });
 //   }

    //this will delete all the record and then create it and add this email to it
    //db.collection("users").doc("hdfhkhs").set({"email": "nour@gmail.com"});
    //this will change this email
    //db.collection("users").doc("hdfhkhs").update({"email": "nour@gmail.com"});
    //db.collection("users").doc("hdfhkhs").delete();
    //select * from users
    //db.collection("users").doc("hdfhkhs").get();
    //db.collection("users").where("gender" , isEqualTo: "female").get();
    //db.collection("users").where("city" , whereIn: ["aden","sana"]).get();

  }*/

  /*Future<List<Project>> loadProjectsFromFirebase() async
  {
    QuerySnapshot<Map<String,dynamic>> firebaseUser= await _db.collection("projects").get();
    List<QueryDocumentSnapshot<Map<String,dynamic>>> userDocument=firebaseUser.docs;
    project = userDocument.map((item) => Project.fromJson(item.data())).toList();
    return project;

  }*/
  Future<void> loadProjectsFromFirebase() async {
    try {
      // Emit loading state
      emit(loadedProjects(project: project));

      print('=== DEBUG: Loading projects from Firebase ===');

      QuerySnapshot<Map<String, dynamic>> firebaseProjects = await _db
          .collection("projects").get();
      List<QueryDocumentSnapshot<
          Map<String, dynamic>>> projectDocuments = firebaseProjects.docs;

      print(
          '=== DEBUG: Found ${projectDocuments.length} project documents ===');

      project = projectDocuments.map((item) {
        print('=== DEBUG: Processing project: ${item.data()} ===');
        return Project.fromJson(item.data());
      }).toList();

      // Debug print to verify data
      print('=== DEBUG: Loaded ${project.length} projects ===');
      for (var project in project) {
        print('Project: ${project.title}');
      }

      // Emit loaded state with the projects
      emit(loadedProjects(project: project));
    } catch (e) {
      print('Error loading projects: $e');
      // Emit error state
      //emit(ErrorLoadingProjects(e.toString()));
    }
  }
}