import 'package:firebase_messaging/firebase_messaging.dart';

import 'local_notifications_helper.dart';

class FCMHelper{
  FirebaseMessaging fcm = FirebaseMessaging.instance;

  initFCM()async{
    fcm.requestPermission(
      alert: true,
      sound:  true,
      badge:  true,
    );

    String? appToken = await fcm.getToken();
    print("the deviceToken is : $appToken");
    HandleFCM();
  }


  HandleFCM(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message){

        LocalNotificationsHelper localNotificationsHelper = LocalNotificationsHelper();
        localNotificationsHelper.showAlert(message);

    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){

    });

  }
}