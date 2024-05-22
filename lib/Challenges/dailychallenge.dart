import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'calender.dart';

class ReadingTracker extends StatefulWidget {
  ReadingTracker({Key? key});

  @override
  _ReadingTrackerState createState() => _ReadingTrackerState();
}

class _ReadingTrackerState extends State<ReadingTracker> {
  final user = FirebaseAuth.instance.currentUser;
  int radialAxisUsageTime = 0;
  DateTime lastRecordDate = DateTime.now();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        // Increment the radialAxisUsageTime
        radialAxisUsageTime++;
        // Update data in Firestore
        _updateDataForDay(lastRecordDate, radialAxisUsageTime);
      });
    });
  }

  void _initializeData() async {
    final today = DateTime.now();

    try {
      final lastRecordSnapshot = await _getLastRecord();
      if (lastRecordSnapshot != null) {
        final lastRecordDate = (lastRecordSnapshot['timestamp'] as Timestamp).toDate();
        if (_isSameDay(lastRecordDate, today)) {
          setState(() {
            radialAxisUsageTime = lastRecordSnapshot['radialAxisUsageTime'];
          });
        }
      }

      if (!_isSameDay(lastRecordDate, today)) {
        await _resetData(today);
      }
    } catch (error) {
      print("Error initializing data: $error");
    }
  }

  Future<DocumentSnapshot?> _getLastRecord() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('reading_data')
          .doc(_formatDate(lastRecordDate))
          .get();
      return querySnapshot.exists ? querySnapshot : null;
    } catch (error) {
      throw Exception("Error getting last record: $error");
    }
  }

  Future<void> _resetData(DateTime today) async {
    try {
      await _updateDataForDay(today, 0);
      setState(() {
        radialAxisUsageTime = 0;
        lastRecordDate = today;
      });
    } catch (error) {
      print("Error resetting data: $error");
    }
  }

  Future<void> _updateDataForDay(DateTime date, int radialAxisUsageTime) async {
    try {
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('reading_data')
          .doc(_formatDate(date))
          .set({
        'timestamp': FieldValue.serverTimestamp(),
        'radialAxisUsageTime': radialAxisUsageTime,
      });
    } catch (error) {
      print("Error updating data for day: $error");
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: const Text('Reading Tracker', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            GaugeDisplay(radialAxisUsageTime: radialAxisUsageTime, updateDataForDay: _updateDataForDay),
            const SizedBox(
              height: 450,
              width: 450, // Adjust size as needed
              child: HeatmapCalendarScreen(),

            ),
            const SizedBox(height: 20), // Add some space between widgets and text
            const Text(
              'Click on the date to see your reading times',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GaugeDisplay extends StatefulWidget {
  final int radialAxisUsageTime;
  final Function(DateTime, int) updateDataForDay;

  const GaugeDisplay({Key? key, required this.radialAxisUsageTime, required this.updateDataForDay}) : super(key: key);

  @override
  _GaugeDisplayState createState() => _GaugeDisplayState();
}

class _GaugeDisplayState extends State<GaugeDisplay> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      setState(() {
        // Increment the radialAxisUsageTime
        widget.updateDataForDay(DateTime.now(), widget.radialAxisUsageTime + 1);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 90,
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            axisLineStyle: const AxisLineStyle(
              thickness: 0.1,
              color: Colors.blueGrey,
              thicknessUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.bothCurve,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: widget.radialAxisUsageTime.toDouble(),
                width: 0.1,
                sizeUnit: GaugeSizeUnit.factor,
                cornerStyle: CornerStyle.bothCurve,
                gradient: const SweepGradient(colors: <Color>[
                  Color(0xFF00a9b5),
                  Color(0xFFa4edeb)
                ], stops: <double>[
                  0.25,
                  0.75
                ]),
              ),
              MarkerPointer(
                value: widget.radialAxisUsageTime.toDouble(),
                markerType: MarkerType.circle,
                color: Colors.red,
              )
            ],
          )
        ],
      ),
    );
  }
}
