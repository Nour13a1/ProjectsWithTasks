import 'package:flutter/material.dart';

import '../../viewmodels/Auth_vm.dart';

class RegistersScreen extends StatefulWidget {
  const RegistersScreen({super.key});

  @override
  State<RegistersScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegistersScreen> {
  AuthVm authVm = AuthVm();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register Screen"),
      ),
      body: Column(
        children: [
          TextFormField(controller: emailcontroller,),
          TextFormField(controller: passcontroller,),
          ElevatedButton(onPressed: () {
            authVm.createAccountbyemailandpassword(email : emailcontroller.text , password : passcontroller.text);
            //authVm.createaccountbygoogle();
          }
            , child: Text("Register"),
          ),
          SizedBox(height: 20,),
          Text("OR"),
           ElevatedButton(onPressed: () {
             // authVm.createAccountbyemailandpassword(email : emailcontroller , password : passcontroller), 
             authVm.createaccountbygoogle();
           }
            , child: Text("Google"),
           ),


          ElevatedButton(onPressed: (){
            
            dynamic name = "ali";
            int x = name ;
          }, child: Text("Click for Crash"))

        ],
      ),
    );
  }
}
