import 'package:flutter_test/flutter_test.dart';
import 'package:myjudo_flutter/models/user.dart';

void main() {
  group('User Model', () {
    test('fromJson and toJson', () {
      final json = {
        'id': 1,
        'username': 'testuser',
        'email': 'test@example.com',
        'dojo': 'Test Dojo',
        'sessions': 5,
        'sessions_this_month': 2,
        'sessions_last_month': 1,
        'sessions_this_year': 4,
        'sessions_last_year': 3,
        'session_types': {'randori': 2},
        'techniques': {'uchi-mata': 1},
        'techniques_this_month': {'uchi-mata': 1},
        'techniques_last_month': {},
        'techniques_this_year': {'uchi-mata': 1},
        'techniques_last_year': {},
      };
      final user = User.fromJson(json);
      expect(user.id, 1);
      expect(user.username, 'testuser');
      expect(user.email, 'test@example.com');
      expect(user.dojo, 'Test Dojo');
      expect(user.sessions, 5);
      expect(user.sessionsThisMonth, 2);
      expect(user.sessionTypes['randori'], 2);
      expect(user.techniques['uchi-mata'], 1);
      final toJson = user.toJson();
      expect(toJson['id'], 1);
      expect(toJson['username'], 'testuser');
      expect(toJson['dojo'], 'Test Dojo');
      expect(toJson['sessions'], 5);
      expect(toJson['session_types']['randori'], 2);
    });

    test('default values', () {
      final user = User(id: 1, username: 'a', email: 'b');
      expect(user.sessions, 0);
      expect(user.sessionTypes, isEmpty);
    });
  });
}
