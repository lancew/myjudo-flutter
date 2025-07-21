import 'package:flutter_test/flutter_test.dart';
import 'package:myjudo_flutter/models/training_session.dart';

void main() {
  group('TrainingSession Model', () {
    test('fromJson and toJson', () {
      final json = {
        'id': 1,
        'date': '2024-06-01',
        'dojo': 'Test Dojo',
        'user_id': 42,
        'techniques': 'uchi-mata,seoi-nage',
        'types': 'randori,kata',
        'duration': 90,
      };
      final session = TrainingSession.fromJson(json);
      expect(session.id, 1);
      expect(session.date, '2024-06-01');
      expect(session.dojo, 'Test Dojo');
      expect(session.userId, 42);
      expect(session.techniques, ['uchi-mata', 'seoi-nage']);
      expect(session.types, ['randori', 'kata']);
      expect(session.duration, 90);
      final toJson = session.toJson();
      expect(toJson['id'], 1);
      expect(toJson['date'], '2024-06-01');
      expect(toJson['dojo'], 'Test Dojo');
      expect(toJson['user_id'], 42);
      expect(toJson['techniques'], 'uchi-mata,seoi-nage');
      expect(toJson['types'], 'randori,kata');
      expect(toJson['duration'], 90);
    });

    test('copyWith', () {
      final session = TrainingSession(
        id: 1,
        date: '2024-06-01',
        dojo: 'Test Dojo',
        userId: 42,
        techniques: ['uchi-mata'],
        types: ['randori'],
        duration: 60,
      );
      final updated = session.copyWith(duration: 120, dojo: 'New Dojo');
      expect(updated.duration, 120);
      expect(updated.dojo, 'New Dojo');
      expect(updated.id, 1);
      expect(updated.techniques, ['uchi-mata']);
    });
  });
}
