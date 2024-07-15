import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // You need to add this package for formatting dates

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  final Map<String, List<String>> timetable = {
    'Monday': [
      'Mobile Applications Lab (Practical)',
      'Mobile Applications Lab (Practical)',
      'BREAK',
      'Cyber Security',
      'Business Intelligence',
      'Computer Networks',
      'Library'
    ],
    'Tuesday': [
      'Business Intelligence Lab',
      'Business Intelligence Lab',
      'BREAK',
      'Mobile Applications',
      'Computer Networks',
      'Project',
      'Project'
    ],
    'Wednesday': [
      'Mobile Applications Lab (Theory)',
      'Mobile Applications Lab (Theory)',
      'BREAK',
      'Cyber Security',
      'Business Intelligence',
      'Activity Hour',
      'Cyber Security'
    ],
    'Thursday': [
      'Business Intelligence Lab',
      'Business Intelligence Lab',
      'BREAK',
      'Cyber Security',
      'Business Intelligence',
      'Mobile Applications',
      'Cyber Security'
    ],
    'Friday': [
      'Mobile Applications',
      'Mobile Applications',
      'BREAK',
      'Business Intelligence',
      'Computer Networks',
      'Library',
      'Library'
    ],
    'Saturday': ['Project', 'Project', 'Cyber Security', 'Computer Networks']
  };

  final Map<String, List<String>> timings = {
    'Weekdays': [
      '7:30 - 8:30 AM',
      '8:30 - 9:00 AM',
      '9:00 - 9:30 AM',
      '9:30 - 10:30 AM',
      '10:30 - 11:30 AM',
      '11:30 - 12:30 PM',
      '12:30 - 1:30 PM'
    ],
    'Saturday': [
      '8:00 - 9:00 AM',
      '9:00 - 10:00 AM',
      '10:00 - 11:00 AM',
      '11:00 - 12:00 PM'
    ]
  };

  final Map<String, Map<String, String>> details = {
    'Mobile Applications Lab (Practical)': {
      'teacher': 'Dr. Manasa Kulkarni',
      'block': 'Block 2',
      'room': 'BSc. Lab'
    },
    'Mobile Applications Lab (Theory)': {
      'teacher': 'Dr. Manasa Kulkarni',
      'block': 'Block 2',
      'room': '707'
    },
    'Cyber Security': {
      'teacher': 'Dr. Chanty S',
      'block': 'Block 2',
      'room': '707'
    },
    'Business Intelligence': {
      'teacher': 'Dr. Newbegin Luke',
      'block': 'Block 2',
      'room': '707'
    },
    'Computer Networks': {
      'teacher': 'Dr. Smitha Vinod',
      'block': 'Block 2',
      'room': '707'
    },
    'Library': {
      'teacher': 'N/A',
      'block': '1st Block/Central Block',
      'room': 'Library'
    },
    'Project Lab': {
      'teacher': 'Dr. Kirubanand V',
      'block': 'Block 2',
      'room': '707'
    },
    'Activity Hour': {
      'teacher': 'Dr. Newbegin Luke',
      'block': 'Block 2',
      'room': '707'
    },
    'Project': {
      'teacher': 'Dr. Kirubanand V',
      'block': 'Block 2',
      'room': '707'
    },
    'BREAK': {'teacher': 'N/A', 'block': 'N/A', 'room': 'N/A'},
    'Mobile Applications': {
      'teacher': 'Dr. Manasa Kulkarni',
      'block': 'Block 2',
      'room': '707'
    },
    'Business Intelligence Lab': {
      'teacher': 'Dr. Newbegin Luke',
      'block': '2nd Block',
      'room': 'BSc. Lab'
    },
  };

  late String _selectedDay;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _selectedDay = DateFormat('EEEE').format(
        now); // This gets the current day in full name format, e.g., "Monday"
    if (_selectedDay == 'Sunday') {
      // Assuming no classes on Sunday
      _selectedDay = 'Monday';
    }
    print(
        'Selected day: $_selectedDay'); // Debug print to check the initial selected day
  }

  void _showDayPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.grey[900],
          child: ListView(
            shrinkWrap: true,
            children: timetable.keys.map((String day) {
              return ListTile(
                title: Text(
                  day,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onTap: () {
                  setState(() {
                    _selectedDay = day;
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showDetails(String time, String session) {
    final detail =
        details[session] ?? {'teacher': 'N/A', 'block': 'N/A', 'room': 'N/A'};
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: Text(
            session,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Time: $time',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Teacher: ${detail['teacher']}',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Block: ${detail['block']}',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Room: ${detail['room']}',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Color _getTimeContainerColor(String time) {
    if (time.contains('7:30')) {
      return Colors.blue;
    } else if (time.contains('8:30') || time.contains('8:00')) {
      return Colors.green;
    } else if (time.contains('9:00') || time.contains('9:00')) {
      return Colors.orange;
    } else if (time.contains('9:30') || time.contains('10:00')) {
      return Colors.purple;
    } else if (time.contains('10:30') || time.contains('11:00')) {
      return Colors.red;
    } else if (time.contains('11:30')) {
      return Colors.teal;
    } else if (time.contains('12:30')) {
      return Colors.pink;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTimings =
        _selectedDay == 'Saturday' ? timings['Saturday'] : timings['Weekdays'];
    final sessions = timetable[_selectedDay];
    final maxPeriods = timetable.values
        .map((list) => list.length)
        .reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Timetable'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenHeight = constraints.maxHeight -
              kToolbarHeight -
              48; // Subtract AppBar and dropdown height
          final periodHeight =
              (screenHeight / maxPeriods) - 2; // Slightly reduce height

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: _showDayPicker,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[900], // Background color
                        foregroundColor: Colors.white, // Text color
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _selectedDay,
                            style: TextStyle(fontSize: 18),
                          ),
                          Icon(Icons.arrow_drop_down,
                              size: 24.0), // Add an icon to indicate dropdown
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: sessions?.length ?? 0,
                  itemBuilder: (context, index) {
                    if (index >= (currentTimings?.length ?? 0)) {
                      return Container();
                    }
                    final timing =
                        currentTimings?[index] ?? 'No timing available';
                    final session = sessions?[index] ?? 'No session available';
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 12.0), // Adjusted padding
                      child: GestureDetector(
                        onTap: () => _showDetails(timing, session),
                        child: Container(
                          height: periodHeight, // Adjusted height
                          decoration: BoxDecoration(
                            color: Colors.grey[900],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.all(8.0), // Fixed padding
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: _getTimeContainerColor(timing),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 6.0), // Fixed padding
                                child: Text(
                                  timing,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(
                                      6.0), // Fixed padding
                                  decoration: BoxDecoration(
                                    color: Colors.grey[900],
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    session,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16), // Fixed font size
                                    maxLines:
                                        2, // Ensure text fits in two lines
                                    overflow: TextOverflow
                                        .ellipsis, // Handle overflow
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
