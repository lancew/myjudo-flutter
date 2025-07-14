import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/training_session.dart';

class ApiService extends ChangeNotifier {
  static const String baseUrl = 'http://localhost'; // Your Raku backend URL

  final http.Client _client = http.Client();
  String? _sessionCookie;

  // Authentication methods
  Future<bool> login(String username, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'login': username,
          'password': password,
        },
      );

      if (response.statusCode == 303) {
        // Successful login - extract session cookie
        final setCookie = response.headers['set-cookie'];
        if (setCookie != null) {
          _sessionCookie = setCookie.split(';').first;
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String username, String email, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'usernamesignup': username,
          'emailsignup': email,
          'passwordsignup': password,
          'passwordsignup_confirm': password,
        },
      );

      return response.statusCode == 303; // Redirect to login on success
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _client.get(
        Uri.parse('$baseUrl/logout'),
        headers: _getAuthHeaders(),
      );
      _sessionCookie = null;
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // User data methods
  Future<User?> getUserData(String username) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/user/$username'),
        headers: _getAuthHeaders(),
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
        headers: _getAuthHeaders(),
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
          ..._getAuthHeaders(),
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
          ..._getAuthHeaders(),
        },
        body: json.encode(session.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Update training session error: $e');
      return false;
    }
  }

  Future<bool> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/password-change'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          ..._getAuthHeaders(),
        },
        body: {
          'password': currentPassword,
          'password-new': newPassword,
          'password-repeat': newPassword,
        },
      );

      return response.statusCode == 303; // Redirect on success
    } catch (e) {
      print('Change password error: $e');
      return false;
    }
  }

  Map<String, String> _getAuthHeaders() {
    if (_sessionCookie != null) {
      return {'Cookie': _sessionCookie!};
    }
    return {};
  }

  bool get isLoggedIn => _sessionCookie != null;

  void dispose() {
    _client.close();
  }
}
