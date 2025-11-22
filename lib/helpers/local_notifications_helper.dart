import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsHelper{
  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidsettings = AndroidInitializationSettings("@mipmap/ic_launcher");
  DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
  AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails("channel1", "default");
  //DarwinNotificationDetails andriodDetails = DarwinNotificationDetails();
  DarwinNotificationDetails isoDetails = DarwinNotificationDetails();

  initLocalNotification() async{
    InitializationSettings settings = InitializationSettings(android: androidsettings,iOS: iosSettings);
    await plugin.initialize(settings);
  }

  showAlert(RemoteMessage message){
    plugin.show(1, message.notification!.title, message.notification!.body, NotificationDetails(iOS: isoDetails, android: androidNotificationDetails));
    }
}