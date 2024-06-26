import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Login_Feature/custom_splash.dart';
import 'Login_Feature/login.dart';
import 'Mybook/bookmark.dart';
import 'profile_full_page/Theme/ThemeNotifier.dart';
import '../Homepage/notification_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseOptions options = const FirebaseOptions(
    appId: '1:1014651146431:android:08e43aec476db73bd2f60a',
    apiKey: 'AIzaSyDt1ba8t3dXrJe8fC-SK-61JPD2WdcfFI8',
    messagingSenderId: '1014651146431',
    projectId: 'bookiee-300cc',
    storageBucket: 'bookiee-300cc.appspot.com'
  );

  await Firebase.initializeApp(options: options);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  //static const String defaultUserId = "temp_user_id";

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoriteBookList()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: Consumer<ThemeNotifier>(  // Use Consumer to listen to ThemeNotifier
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Bookie',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              brightness: themeNotifier.isDarkMode ? Brightness.dark : Brightness.light,  // Adjust brightness dynamically
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => const CustomSplashScreen(),
              '/signin': (context) => const LoginScreen(),
              '/notifications': (context) => NotificationListPage(),
              // Add more routes as needed, including those for MyBook features
            },
          );
        },
      ),
    );
  }
}

