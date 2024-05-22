import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class AppUsageProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  Timer? _timer;
  DateTime _lastDate = DateTime.now();
  int _appUsage = 0;
  Map<DateTime, int> _datasets = {};

  AppUsageProvider() {
    _startTimer();
    FirebaseAuth.instance.authStateChanges().listen((User? firebaseUser) {
      user = firebaseUser;
      if (user != null) {
        _fetchAppUsageForToday();
      } else {
        _stopTimer();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _appUsage++;
      _updateAppUsageTime();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _fetchAppUsageForToday() async {
    DateTime now = DateTime.now();
    int appUsage = await fetchAppUsage(now);
    _appUsage = appUsage;
    notifyListeners();
  }

  Future<int> fetchAppUsage(DateTime date) async {
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

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  Future<void> _updateAppUsageTime() async {
    DateTime now = DateTime.now();
    if (!_isSameDay(_lastDate, now)) {
      _appUsage = 0;
    }
    _lastDate = now;

    try {
      await _updateDataForDay(now, _appUsage);
    } catch (error) {
      print("Error updating data for day: $error");
    }

    notifyListeners();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  Future<void> _updateDataForDay(DateTime date, int appUsage) async {
    String dateString = _formatDate(date);
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await _firestore
        .collection('users')
        .doc(user!.uid)
        .collection('calendar_data')
        .doc(dateString)
        .get();

    if (docSnapshot.exists) {
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('calendar_data')
          .doc(dateString)
          .update({
        'app_usage': appUsage,
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
        'date': Timestamp.fromDate(date),
      });
    }

    fetchUserData(date); // Refresh datasets after updating
  }

  Future<void> fetchUserData(DateTime date) async {
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

      _datasets = newDatasets;
      notifyListeners();
    }
  }

  Map<DateTime, int> get datasets => _datasets;
}
