import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/subject.dart';

class AppState extends ChangeNotifier {
  List<Subject> _subjects = [];
  int _attendanceThreshold = 75;

  List<Subject> get subjects => List.unmodifiable(_subjects);
  int get attendanceThreshold => _attendanceThreshold;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('subjects');
    if (raw != null) {
      final list = jsonDecode(raw) as List<dynamic>;
      _subjects =
          list.map((e) => Subject.fromJson(e as Map<String, dynamic>)).toList();
    }
    _attendanceThreshold = prefs.getInt('attendanceThreshold') ?? 75;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'subjects',
      jsonEncode(_subjects.map((s) => s.toJson()).toList()),
    );
    await prefs.setInt('attendanceThreshold', _attendanceThreshold);
  }

  void addSubject(Subject subject) {
    _subjects.add(subject);
    notifyListeners();
    _persist();
  }

  void updateSubject(Subject updated) {
    final idx = _subjects.indexWhere((s) => s.id == updated.id);
    if (idx == -1) return;
    _subjects[idx] = updated;
    notifyListeners();
    _persist();
  }

  void deleteSubject(String id) {
    _subjects.removeWhere((s) => s.id == id);
    notifyListeners();
    _persist();
  }

  void setAttendanceThreshold(int value) {
    _attendanceThreshold = value;
    notifyListeners();
    _persist();
  }
}
