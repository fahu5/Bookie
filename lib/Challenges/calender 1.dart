/*import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class HeatmapCalendarScreen extends StatefulWidget {
  const HeatmapCalendarScreen({super.key});

  @override
  _HeatmapCalendarScreenState createState() => _HeatmapCalendarScreenState();
}

class _HeatmapCalendarScreenState extends State<HeatmapCalendarScreen> with WidgetsBindingObserver {
  Map<DateTime, int> datasets = {};
  Map<int, Color> colorsets = {
    1: Colors.green.shade400,
    2: Colors.green.shade600,
    3: Colors.green.shade800,
    4: Colors.green.shade900,
  };
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  DateTime _currentDate = DateTime.now();
  DateTime _lastDate = DateTime.now();
  int _appUsage = 0;
  StreamSubscription<QuerySnapshot>? _listenerSubscription;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) {
      setState(() {
        user = firebaseUser;
      });
      if (user != null) {
        _fetchUserData(_currentDate);
        _setUpRealTimeListener();
        _fetchAppUsageForToday();
        _startTimer();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _stopTimer();
    } else if (state == AppLifecycleState.resumed) {
      _fetchAppUsageForToday();
      _startTimer();
    }
  }

  Future<void> _fetchUserData(DateTime date) async {
    try {
      if (user != null) {
        DateTime startOfMonth = DateTime(date.year, date.month, 1);
        DateTime endOfMonth = DateTime(date.year, date.month + 1, 0);

        QuerySnapshot<Map<String, dynamic>> userDocs = await _firestore
            .collection('users')
            .doc(user!.uid)
            .collection('calendar_data')
            .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
            .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
            .get();

        Map<DateTime, int> newDatasets = {};
        userDocs.docs.forEach((doc) {
          DateTime docDate = (doc.data()['date'] as Timestamp).toDate();
          newDatasets[docDate] = doc.data()['app_usage'];
        });

        setState(() {
          datasets = newDatasets;
        });
      }
    } catch (error) {
      print("Error fetching user data: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error fetching user data: $error")));
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        _appUsage++;
        _updateAppUsageTime();
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _fetchAppUsageForToday() async {
    DateTime now = DateTime.now();
    int appUsage = await _fetchAppUsage(now);
    setState(() {
      _appUsage = appUsage;
    });
  }

  void _updateAppUsageTime() async {
    DateTime now = DateTime.now();
    if (!_isSameDay(_lastDate, now)) {
      _appUsage = 0;
    }
    _lastDate = now;

    int colorValue = _getColorForAppUsage(_appUsage).value;
    try {
      await _updateDataForDay(now, _appUsage, colorValue);
      setState(() {
        colorsets = {
          for (int i = 1; i < 5; i++) i: Color(colorValue),
        };
      });
    } catch (error) {
      print("Error updating data for day: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating data: $error")));
    }
  }

  Color _getColorForAppUsage(int appUsage) {
    if (appUsage < 30) {
      return colorsets[1]!;
    } else if (appUsage < 60) {
      return colorsets[2]!;
    } else if (appUsage < 90) {
      return colorsets[3]!;
    } else {
      return colorsets[4]!;
    }
  }

  Future<void> _updateDataForDay(DateTime date, int appUsage, int colorValue) async {
    String dateString = _formatDate(date);
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('calendar_data')
        .doc(dateString)
        .get();

    try {
      if (docSnapshot.exists) {
        await _firestore
            .collection('users')
            .doc(user!.uid)
            .collection('calendar_data')
            .doc(dateString)
            .update({
          'app_usage': appUsage,
          'colorValue': colorValue,
          'date': Timestamp.fromDate(date),

        });
      } else {
        await _firestore
            .collection('users')
            .doc(user!.uid)
            .collection('calendar_data')
            .doc(dateString)
            .set({
          'app_usage': appUsage,
          'colorValue': colorValue,
          'date': Timestamp.fromDate(date),

        });
      }
    } catch (error) {
      print("Error updating data for day: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating data: $error")));
    }
  }

  void _setUpRealTimeListener() {
    DateTime startOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
    DateTime endOfMonth = DateTime(_currentDate.year, _currentDate.month + 1, 0);

    _listenerSubscription?.cancel();
    _listenerSubscription = _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('calendar_data')
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .snapshots()
        .listen((snapshot) {
      Map<DateTime, int> newDatasets = {};
      snapshot.docs.forEach((doc) {
        DateTime docDate = (doc.data()['date'] as Timestamp).toDate();
        newDatasets[docDate] = doc.data()['app_usage'];
      });

      setState(() {
        datasets = newDatasets;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('Reading Record', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
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
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: HeatMapCalendar(
                          flexible: true,
                          colorMode: ColorMode.opacity,
                          colorTipCount: 4,
                          datasets: datasets,
                          colorsets: colorsets,

                          onClick: (value) async {
                            DateTime clickedDate = value;
                            int appUsage = await _fetchAppUsage(clickedDate);
                            String message = 'Reading Time: ${clickedDate.day}/${clickedDate.month}/${clickedDate.year}: $appUsage minutes';
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                          },
                          onMonthChange: (date) {
                            setState(() {
                              _currentDate = date;
                              _fetchUserData(date); // Call to fetch data for new month
                              _setUpRealTimeListener(); // Update listener for new month
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      '*Click on the Date for seeing your Reading time.',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
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
    WidgetsBinding.instance.removeObserver(this);
    _listenerSubscription?.cancel();
    _stopTimer();
    super.dispose();
  }
}
*/