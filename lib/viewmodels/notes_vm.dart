import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled8/models/NotesStates.dart';

import '../models/notes.dart';

class NotesVM extends Cubit{
  NotesVM():super(EmptyNote());
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

Future<bool>addNewNotes(Note n,{File? image}) async{
  String? img = "";
if(image != null){

  img = await addFile(image!);
}
n.img = img;
await  _db.collection("notes").doc(n.id).set(n.toJSON());
return true;
}
Stream<QuerySnapshot<Map<String,dynamic>>>loadallnotes(){
  emit(loadingNote());
  emit(loadedNote());
  return _db.collection("notes").orderBy("id",descending: true).snapshots();
}
Future<String?>addFile(File f) async{
int randNo = Random().nextInt(3000);
Reference ref = _storage.ref("images/users/$randNo.png");
String? imageurl ;
 UploadTask  task =  ref.putFile(f);
 await task.whenComplete(() async{
   imageurl = await ref.getDownloadURL();

 });
 return imageurl;

}
}