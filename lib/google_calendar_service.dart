import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class GoogleCalendarService {
  static const _scopes = [calendar.CalendarApi.calendarReadonlyScope];

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);

  Future<GoogleSignInAccount?> signIn() async {
    return await _googleSignIn.signIn();
  }

  Future<List<calendar.Event>> getCalendarEvents(
      GoogleSignInAccount googleUser) async {
    final authHeaders = await googleUser.authHeaders;
    final authClient = authenticatedClient(
      http.Client(),
      AccessCredentials(
        AccessToken(
          authHeaders['type']!,
          authHeaders['Authorization']!,
          DateTime.now().add(Duration(hours: 1)),
        ),
        '',
        _scopes,
      ),
    );

    final calendarApi = calendar.CalendarApi(authClient);
    final events = await calendarApi.events.list('primary');
    return events.items ?? [];
  }
}
