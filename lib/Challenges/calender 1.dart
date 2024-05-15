/*import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class HeatmapCalendarScreen extends StatefulWidget {
  const HeatmapCalendarScreen({Key? key}) : super(key: key);

  @override
  _HeatmapCalendarScreenState createState() => _HeatmapCalendarScreenState();
}

class _HeatmapCalendarScreenState extends State<HeatmapCalendarScreen> {
  late Map<DateTime, int> datasets;
  late Map<int, Color> colorsets = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? user;
  late DateTime _currentDate;
  late Timer _timer;
  late DateTime _lastDate = DateTime.now();
  int _appUsage = 0;

  @override
  void initState() {
    super.initState();
    datasets = {};
    _initializeColorSets();
    _currentDate = DateTime.now();
    _startTimer();
    FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) {
      setState(() {
        user = firebaseUser;
      });
      if (user != null) {
        _fetchUserData(_currentDate);
      }
    });
  }

  void _initializeColorSets() {
    colorsets = {
      0: Colors.red,
      1: Colors.lightGreen,
      2: Colors.lightGreen,
      3: Colors.lightGreen,
      4: Colors.lightGreen,
      5: Colors.green,
      6: Colors.green,
    };
  }

  Future<void> _fetchUserData(DateTime date) async {
    try {
      if (user != null) {
        String dateString = _formatDate(date);
        DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
            .collection('users')
            .doc(user!.uid)
            .collection('calendar_data')
            .doc(dateString)
            .get();

        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data()!;
          if (userData.containsKey('app_usage')) {
            setState(() {
              _appUsage = userData['app_usage'];
              datasets = {date: _appUsage};
            });
          }
          if (userData.containsKey('color_value')) {
            setState(() {
              int colorValue = userData['color_value'];
              colorsets = {0: Color(colorValue)};
            });
          }
        } else {
          setState(() {
            _appUsage = 0;
            datasets = {date: 0};
            _initializeColorSets();
          });
        }
      }
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _appUsage++;
        _updateAppUsageTime();
      });
    });
  }

  void _updateAppUsageTime() async {
    String dateString = _formatDate(_currentDate);

    // Check if the current date is different from the last updated date
    DateTime now = DateTime.now();
    if (!_isSameDay(_lastDate, now)) {
      _appUsage = 0; // Reset app usage count for a new day
    }
    _lastDate = now; // Update the last updated date

    int colorValue = _getColorForAppUsage(_appUsage); // Get color based on app usage
    try {
      await _updateDataForDay(_currentDate, _appUsage, colorValue);
    } catch (error) {
      print("Error updating data for day: $error");
    }
  }
  int _getColorForAppUsage(int appUsage) {
    if (appUsage < 30) {
      return Colors.lightGreen.value;
    } else if (appUsage < 60) {
      return Colors.yellow.value;
    } else {
      return Colors.red.value;
    }
  }

  Future<void> _updateDataForDay(
      DateTime date, int appUsage, int colorValue) async {
    String dateString = _formatDate(date);
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('calendar_data')
        .doc(dateString)
        .get();

    try {
      if (docSnapshot.exists) {
        // Data exists for the current date, update the existing data
        await _firestore
            .collection('users')
            .doc(user!.uid)
            .collection('calendar_data')
            .doc(dateString)
            .update({
          'app_usage': appUsage,
          'color_value': colorValue,
          'timestamp': Timestamp.now(),
        });
      } else {
        // Data does not exist for the current date, store new data
        await _firestore
            .collection('users')
            .doc(user!.uid)
            .collection('calendar_data')
            .doc(dateString)
            .set({
          'app_usage': appUsage,
          'color_value': colorValue,
          'timestamp': Timestamp.now(),
        });
      }
    } catch (error) {
      print("Error updating data for day: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (snapshot.hasData && snapshot.data != null) {
                user = snapshot.data;
                return HeatMapCalendar(
                  flexible: true,
                  colorMode: ColorMode.opacity,
                  colorTipCount: 4,
                  datasets: datasets,
                  colorsets: colorsets,
                  onClick: (value) async {
                    DateTime clickedDate = value;
                    int appUsage = await _fetchAppUsage(clickedDate);
                    String message =
                        'App usage on ${clickedDate.day}/${clickedDate.month}/${clickedDate.year}: $appUsage minutes';
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)));
                  },
                  onMonthChange: (date) {
                    setState(() {
                      _currentDate = date;
                      _fetchUserData(date);
                    });
                  },
                );
              } else {
                return const Text('User not authenticated.');
              }
            },
          ),

        ),

      ),
    );
  }

  Future<int> _fetchAppUsage(DateTime date) async {
    if (user != null) {
      String dateString = _formatDate(date);
      DocumentSnapshot<Map<String, dynamic>> userDoc = await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('calendar_data')
          .doc(dateString)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data()!;
        if (userData.containsKey('app_usage')) {
          return userData['app_usage'];
        }
      }
    }
    return 0;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
*/