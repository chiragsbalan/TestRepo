import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart'; // For the progress ring
import 'notifications_page.dart';
import 'forms_page.dart';
import 'calendar_page.dart';
import 'timetable_page.dart';
import 'profile_page.dart';
import 'main.dart';
import 'payments_page.dart';
import 'attendance_page.dart';
import 'events_page.dart';
import 'academics_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String studentName;

  HomePage({required this.studentName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _profileImageFile;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profileImagePath');
    if (imagePath != null) {
      setState(() {
        _profileImageFile = File(imagePath);
      });
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  final List<Map<String, String>> alerts = [
    {'title': 'Holiday', 'description': 'Holiday declared on Friday'},
    {'title': 'Exam', 'description': 'Exam date announced: 21th July'},
    {'title': 'Assignment', 'description': 'Assignment due: 15th July'},
    {'title': 'New Course', 'description': 'New course available: AI'},
    {'title': 'Event', 'description': 'Hackathon on 25th July'},
    {'title': 'Notice', 'description': 'Library will be closed on Sunday'}
  ];

  final Map<String, List<String>> timetable = {
    'Monday': [
      'Mobile Applications Lab - BSc. Lab',
      'Mobile Applications Lab - BSc. Lab',
      'BREAK',
      'Cyber Security',
      'Business Intelligence',
      'Computer Networks',
      'Library'
    ],
    'Tuesday': [
      'Business Intelligence Lab - BSc. Lab',
      'Business Intelligence Lab - BSc. Lab',
      'BREAK',
      'Mobile Applications',
      'Computer Networks',
      'Project',
      'Project'
    ],
    'Wednesday': [
      'MA Lab - Class',
      'MA Lab - Class',
      'BREAK',
      'Cyber Security',
      'Business Intelligence',
      'Activity Hour',
      'Cyber Security'
    ],
    'Thursday': [
      'Business Intelligence Lab - BSc. Lab',
      'Business Intelligence Lab - BSc. Lab',
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
    'Saturday': ['Project Lab', 'Project Lab', 'BREAK', 'Computer Networks']
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

  double getAttendancePercentage() {
    // This function should return the actual attendance percentage.
    // For demonstration, it returns a hardcoded value.
    return 0.85; // 85%
  }

  Color getAttendanceColor(double percentage) {
    if (percentage >= 0.80) {
      return Colors.green;
    } else if (percentage >= 0.75) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current day
    String today = DateFormat('EEEE').format(DateTime.now());
    if (today == 'Sunday') {
      today = 'Monday';
    }
    List<String>? todayClasses = timetable[today];
    List<String> todayTimings =
        (today == 'Saturday') ? timings['Saturday']! : timings['Weekdays']!;

    double attendancePercentage = getAttendancePercentage();
    Color attendanceColor = getAttendanceColor(attendancePercentage);

    return Scaffold(
      backgroundColor: Colors.black, // Ensure the scaffold background is black
      appBar: AppBar(
        title: Text('${getGreeting()}, ${widget.studentName}'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundColor: Colors.grey[900],
              backgroundImage: _profileImageFile != null
                  ? FileImage(_profileImageFile!)
                  : null,
              child: _profileImageFile == null ? null : null,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              ).then((_) {
                // Reload the profile image when coming back from the profile page
                _loadProfileImage();
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top +
                  16.0), // Add padding at the top
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Menu',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Divider(color: Colors.white),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('My Timetable'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimetablePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Attendance'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AttendancePage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notifications'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendar'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.school),
              title: const Text('Academics'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AcademicsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text('Events'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.format_list_bulleted),
              title: const Text('Forms'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FormsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Payments'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          MyApp(isLoggedIn: false)), // Pass false to MyApp
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Attendance Widget
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AttendancePage()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Attendance: ${(attendancePercentage * 100).toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    CircularPercentIndicator(
                      radius: 30.0,
                      lineWidth: 5.0,
                      percent: attendancePercentage,
                      center: Text(
                        '${(attendancePercentage * 100).toStringAsFixed(0)}%',
                        style: TextStyle(color: Colors.white),
                      ),
                      progressColor: attendanceColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32.0), // Add spacing between widgets

            // Alerts Section
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsPage()),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alerts',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'NotoSans',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    height:
                        140.0, // Fixed height for scrollable container to show 3 alerts
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[900], // Dark grey for widgets
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: alerts.map((alert) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.notification_important,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          alert['title']!,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'NotoSans',
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4.0),
                                        Text(
                                          alert['description']!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'NotoSans',
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32.0), // Add spacing between widgets

            // Timetable Section
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimetablePage()),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upcoming Classes ($today)',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'NotoSans',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    height: 200.0, // Fixed height for showing 2 classes
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[900], // Dark grey for widgets
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        itemCount: todayClasses?.length ?? 0,
                        itemBuilder: (context, index) {
                          if (index >= (todayTimings.length)) {
                            return Container();
                          }
                          final timing =
                              todayTimings[index] ?? 'No timing available';
                          final session =
                              todayClasses?[index] ?? 'No session available';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: _getTimeContainerColor(timing),
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 5.0),
                                    child: Text(
                                      timing,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                                  ),
                                  const SizedBox(height: 4.0),
                                  Container(
                                    padding: const EdgeInsets.all(6.0),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[850],
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Text(
                                      session,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32.0), // Add spacing between widgets

            // Events Section
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EventsPage()),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Events',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'NotoSans',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    height:
                        240.0, // Fixed height for scrollable container to show events
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[900], // Dark grey for widgets
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: PageView.builder(
                        itemCount: 3, // Assuming you want to show 3 events
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 100.0,
                                    height: 130.0,
                                    margin: const EdgeInsets.only(
                                        right: 12.0,
                                        left:
                                            16.0), // Adjust this value to move the image to the right
                                    color: Colors.grey,
                                    child: Center(
                                        child: Text(
                                            'IMAGE')), // Placeholder for image
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Event Name',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Department Conducting',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            'Event Date',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            'Description',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
}
