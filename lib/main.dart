import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled8/helpers/fcm_helper.dart';
import 'package:untitled8/helpers/local_notifications_helper.dart';
import 'package:untitled8/viewmodels/notes_vm.dart';
import 'package:untitled8/viewmodels/projects_vm.dart';
import 'package:untitled8/viewmodels/users_vm.dart';

import 'package:untitled8/views/screens/add_edit_task_screen.dart';
import 'package:untitled8/views/screens/add_new_project_screen.dart';
import 'package:untitled8/views/screens/home_screen.dart';
import 'package:untitled8/views/screens/login_screen.dart';
import 'package:untitled8/views/screens/noted_screen.dart';
import 'package:untitled8/views/screens/project_details_screen.dart';
import 'package:untitled8/views/screens/register_screen.dart';
import 'package:untitled8/views/screens/registration_screen.dart';
import 'package:untitled8/views/screens/splash_screen.dart';
import 'package:untitled8/theme/app_theme.dart';
import 'package:untitled8/views/screens/task_list_screen.dart';
import 'package:untitled8/views/screens/test_local_screen.dart';

import 'firebase_options.dart';
import 'models/projects.dart';


Future<void>fcmBackgroundListener(RemoteMessage message) async{

}
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(fcmBackgroundListener);

  LocalNotificationsHelper helper = LocalNotificationsHelper();
  helper.initLocalNotification();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };


  FCMHelper fcm  = FCMHelper()..initFCM();
  //FCMHelper fcm  = FCMHelper();
  //fcm.initFCM();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   // return BlocProvider(create: (ctx)=> ProjectVm(),
        return MultiBlocProvider(
        providers: [
        BlocProvider<UserVM>(
        create: (context) => UserVM(),
    ),
          BlocProvider<ProjectVm>(
            create: (context) => ProjectVm(),
          ),
          BlocProvider<NotesVM>(
            create: (context) => NotesVM(),
          ),
     ],

     child:  MaterialApp(
      title: 'TaskFlow',
      theme: AppTheme.lightTheme,
      initialRoute: '/home',
      /*routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/home': (_) => const HomeScreen(),
        '/splash': (_) => const SplashScreen(),
        '/project_details': (_) => const ProjectDetailsScreen(),
        '/add_task': (_) => const AddEditTaskScreen(),
        '/add_Project': (_) => const AddNewProjectScreen(),
        '/registers': (_) => const RegistersScreen(),
        '/notes': (_) =>  NotedScreen(),
        '/localnot': (_) =>  TestLocalScreen(),
        '/taskList': (_) => const TaskListScreen(),

        // Other screens to be added
      },*/
       routes: {
         '/login': (context) => const LoginScreen(),
         '/register': (context) => const RegisterScreen(),
         '/home': (context) => const HomeScreen(),
         '/splash': (context) => const SplashScreen(),
        // '/project_details': (context) => const ProjectDetailsScreen(),
         '/project_details': (context) {
           final project = ModalRoute.of(context)!.settings.arguments as Project;
           return ProjectDetailsScreen(project: project);},
         /*'/add_task': (_) => const AddEditTaskScreen(),*/
         '/add_task': (context) {
           final args = ModalRoute.of(context)!.settings.arguments;
           return AddEditTaskScreen(projectId: args as String);
         },
         '/add_Project': (context) => const AddNewProjectScreen(),
         '/registers': (context) => const RegistersScreen(),
         '/notes': (context) => NotedScreen(),
         '/localnot': (context) => TestLocalScreen(),
         '/taskList': (_) => const TaskListScreen(),

        /* '/taskList': (context) {
           final args = ModalRoute.of(context)!.settings.arguments;
           if (args is String) {
             return TaskListScreen(projectId: args);
           } else {
             return const Scaffold(
               body: Center(child: Text('Project ID is required')),
             );
           }
         },*/
       },
    ),
    );
   /* return;*/
  }
}
