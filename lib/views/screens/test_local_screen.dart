import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:untitled8/helpers/local_notifications_helper.dart';

class TestLocalScreen extends StatelessWidget {
  const TestLocalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: (){
          LocalNotificationsHelper helper = LocalNotificationsHelper();
          //helper.showAlert();
        }, child: Text("notification")),
      ),
    );
  }
}
