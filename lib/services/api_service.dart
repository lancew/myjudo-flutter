import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/training_session.dart';

class ApiService extends ChangeNotifier {
  static const String baseUrl = 'http://localhost'; // Your Raku backend URL

  final http.Client _client = http.Client();

  // User data methods
  Future<User?> getUserData(String username) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/user/$username'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return User.fromJson(jsonData);
      }
      return null;
    } catch (e) {
      print('Get user data error: $e');
      return null;
    }
  }

  // Training session methods
  Future<List<TrainingSession>> getTrainingSessions(int userId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/training-sessions/$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => TrainingSession.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Get training sessions error: $e');
      return [];
    }
  }

  Future<bool> addTrainingSession(TrainingSession session) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/api/training-session/add'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(session.toJson()),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Add training session error: $e');
      return false;
    }
  }

  Future<bool> updateTrainingSession(TrainingSession session) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/api/training-session/${session.id}'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(session.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Update training session error: $e');
      return false;
    }
  }

  void dispose() {
    _client.close();
  }
}
