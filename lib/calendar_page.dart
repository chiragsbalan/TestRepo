import 'package:flutter/material.dart';
import 'google_calendar_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final GoogleCalendarService _calendarService = GoogleCalendarService();
  GoogleSignInAccount? _currentUser;
  List<calendar.Event> _events = [];

  @override
  void initState() {
    super.initState();
    _handleSignIn();
  }

  Future<void> _handleSignIn() async {
    final user = await _calendarService.signIn();
    if (user != null) {
      final events = await _calendarService.getCalendarEvents(user);
      setState(() {
        _currentUser = user;
        _events = events;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: _currentUser == null
          ? Center(
        child: ElevatedButton(
          onPressed: _handleSignIn,
          child: const Text('Sign in with Google'),
        ),
      )
          : _events.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final event = _events[index];
          return ListTile(
            title: Text(event.summary ?? 'No Title'),
            subtitle:
            Text(event.start?.dateTime?.toString() ?? 'No Date'),
          );
        },
      ),
    );
  }
}
