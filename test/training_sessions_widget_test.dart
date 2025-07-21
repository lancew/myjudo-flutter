import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myjudo_flutter/screens/training_sessions_screen.dart';
import 'package:myjudo_flutter/models/training_session.dart';
import 'package:myjudo_flutter/services/database_service.dart';

class FakeDatabaseService implements ITrainingSessionService {
  final List<TrainingSession> _sessions = [];
  int _idCounter = 1;

  @override
  Future<int> addTrainingSession(TrainingSession session) async {
    final newSession = session.copyWith(id: _idCounter++);
    _sessions.add(newSession);
    return newSession.id!;
  }

  @override
  Future<List<TrainingSession>> getTrainingSessions(int userId) async {
    return _sessions.where((s) => s.userId == userId).toList();
  }

  @override
  Future<int> updateTrainingSession(TrainingSession session) async {
    final idx = _sessions.indexWhere((s) => s.id == session.id);
    if (idx != -1) {
      _sessions[idx] = session;
      return 1;
    }
    return 0;
  }

  @override
  Future<int> deleteTrainingSession(int id) async {
    _sessions.removeWhere((s) => s.id == id);
    return 1;
  }
}

void main() {
  late FakeDatabaseService fakeDbService;
  setUp(() {
    fakeDbService = FakeDatabaseService();
  });

  testWidgets('Add training session with duration', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: TrainingSessionsScreen(userId: 1, databaseService: fakeDbService),
    ));

    // Tap the add button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Enter values in the form
    await tester.enterText(find.widgetWithText(TextFormField, 'Date (YYYY-MM-DD)'), '2024-06-01');
    await tester.enterText(find.widgetWithText(TextFormField, 'Dojo'), 'Test Dojo');
    await tester.enterText(find.widgetWithText(TextFormField, 'Techniques (comma separated)'), 'uchi-mata');
    await tester.enterText(find.widgetWithText(TextFormField, 'Types (comma separated)'), 'randori');
    await tester.enterText(find.widgetWithText(TextFormField, 'Duration (minutes)'), '90');

    // Tap the Add button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));
    await tester.pumpAndSettle();

    // Check that the new session appears in the list
    expect(find.text('Test Dojo'), findsOneWidget);
    expect(find.text('Duration: 90 min'), findsOneWidget);
  });
} 