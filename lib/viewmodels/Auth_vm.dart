import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthVm{
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<UserCredential?>createAccountbyemailandpassword({required String email, required String password}) async{

      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);


      FirebaseFirestore db = FirebaseFirestore.instance;
     if(firebaseAuth.currentUser != null){

       db.collection("users").add({
         "id":firebaseAuth.currentUser!.uid,
         "name" : "Noor",
         //"email" : email,
         "email" : firebaseAuth.currentUser!.email,
         "gender" : "Female"
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
       }

       //this will delete all the record and then create it and add this email to it
       //db.collection("users").doc("hdfhkhs").set({"email": "nour@gmail.com"});
       //this will change this email
       //db.collection("users").doc("hdfhkhs").update({"email": "nour@gmail.com"});
       //db.collection("users").doc("hdfhkhs").delete();
       //select * from users
       //db.collection("users").doc("hdfhkhs").get();
       //db.collection("users").where("gender" , isEqualTo: "female").get();
       //db.collection("users").where("city" , whereIn: ["aden","sana"]).get();

     }


  Future<UserCredential?>createaccountbygoogle() async{
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if(googleUser != null){

      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken,accessToken:googleAuth.accessToken );
      return firebaseAuth.signInWithCredential(credential);
      //firebaseAuth.s
      //firebaseAuth.si
    }


    ///firebaseAuth.signInWithCredential(credential)


  }
  Stream<QuerySnapshot<Map<String,dynamic>>>readData(){
    FirebaseFirestore db = FirebaseFirestore.instance;
    return db.collection("users").snapshots();
  }

  logout(){
    firebaseAuth.authStateChanges();
  }
}


