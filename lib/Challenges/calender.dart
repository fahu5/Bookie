import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:provider/provider.dart';
import 'appusage_provider.dart';

class HeatmapCalendarScreen extends StatefulWidget {
  const HeatmapCalendarScreen({Key? key}) : super(key: key);

  @override
  _HeatmapCalendarScreenState createState() => _HeatmapCalendarScreenState();
}

class _HeatmapCalendarScreenState extends State<HeatmapCalendarScreen> {
  // Adjusted color sets for better visibility
  final Map<int, Color> colorsets = {
    1: Colors.green,  // 1-14 minutes
    2: Colors.green.shade600,  // 15-29 minutes
    3: Colors.green.shade700,  // 30-44 minutes
    4: Colors.green.shade800,  // 45-59 minutes
    5: Colors.green.shade900,  // 60 or more minutes
  };

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
          child: Consumer<AppUsageProvider>(
            builder: (context, appUsageProvider, child) {
              // Debugging: Print the datasets to verify values
              print('Datasets: ${appUsageProvider.datasets}');

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '*Click on the Date to see your reading time.',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      child: HeatMapCalendar(
                        flexible: true,
                        colorMode: ColorMode.color, // Use color mode for direct color differentiation
                        colorTipCount: colorsets.length,  // Number of color levels
                        datasets: appUsageProvider.datasets.map((date, usage) {
                          // Debugging: Print each date and usage value
                          print('Date: $date, Usage: $usage');
                          return MapEntry(date, _getColorLevel(usage));
                        }),
                        colorsets: colorsets,
                        onClick: (value) async {
                          try {
                            DateTime clickedDate = value;
                            int appUsage = await appUsageProvider.fetchAppUsage(clickedDate);
                            String message = 'Reading Time: ${clickedDate.day}/${clickedDate.month}/${clickedDate.year}: $appUsage minutes';
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error fetching data: $e')));
                          }
                        },
                        onMonthChange: (date) {
                          appUsageProvider.fetchUserData(date);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper function to get the color level based on usage
  int _getColorLevel(int usage) {
    if (usage >= 60) {
      return 5;
    } else if (usage >= 45) {
      return 4;
    } else if (usage >= 30) {
      return 3;
    } else if (usage >= 15) {
      return 2;
    } else if (usage >= 1) {
      return 1;
    } else {
      return 0;  // No usage
    }
  }
}
