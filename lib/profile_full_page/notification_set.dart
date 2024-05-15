import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool _notificationEnabled = true; // Set to true by default for new users
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _checkNotification();
    _sendNotification(
        'Come back and continue your reading journey.' );
  }

  Future<void> _checkNotification() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DateTime now = DateTime.now();
      String formattedDate = "${now.year}-${now.month}-${now.day}";

      DocumentSnapshot notificationSnapshot = await firestore
          .collection('users')
          .doc(user?.uid)
          .collection('notifications')
          .doc(formattedDate)
          .get();

      if (notificationSnapshot.exists) {
        Map<String, dynamic>? data = notificationSnapshot.data() as Map<String, dynamic>?; // Explicit cast
        if (data != null) {
          bool isNotificationEnabled = data['enabled'];
          setState(() {
            _notificationEnabled = isNotificationEnabled;
          });
        }
      } else {
        // If no data exists for the current date, set notification to enabled by default
        _toggleNotification(true);
      }
    } catch (error) {
      print('Error checking notification: $error');
    }
  }


  Future<void> _toggleNotification(bool enabled) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DateTime now = DateTime.now();
      String formattedDate = "${now.year}-${now.month}-${now.day}";

      DocumentReference userDocRef = firestore.collection('users').doc(user?.uid);

      // Ensure the 'notifications' subcollection exists
      CollectionReference notificationsCollectionRef = userDocRef.collection('notifications');

      // Set notification status
      await notificationsCollectionRef.doc(formattedDate).set({'enabled': enabled});
    } catch (error) {
      print('Error updating notification status: $error');
    }
  }


  Future<void> _sendNotification(String message) async {
    try {
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'your_channel_id',
        'Reminder Channel',
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
        enableLights: true,
        ledColor: Colors.blue,
        ledOnMs: 500,
        ledOffMs: 500,
      );
      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        0,
        'We miss you!',
        message,
        platformChannelSpecifics,
      );

      // Store notification in Firestore with timestamp and message
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DateTime now = DateTime.now();
      String formattedDate = "${now.year}-${now.month}-${now.day}";
      String formattedTime = "${now.hour}:${now.minute}";

      await firestore
          .collection('users')
          .doc(user?.uid)
          .collection('notifications')
          .doc(formattedDate)
          .set({
        'enabled': true,
        'timestamp': formattedTime,
        'message': message, // Add the message to the data
      });
    } catch (error) {
      print('Error sending notification: $error');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: const Text('Notification Settings'),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Allow Notification',
              style: TextStyle(fontSize: 16.0),
            ),
            const Spacer(),
            Row(
              children: [
                const Text('Off',style: TextStyle(fontSize: 8.0),),
                Switch(
                  value: _notificationEnabled,
                  onChanged: (value) {
                    setState(() {
                      _notificationEnabled = value;
                    });
                    _toggleNotification(value);
                  },
                ),
                const Text('On',style: TextStyle(fontSize: 8.0),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
