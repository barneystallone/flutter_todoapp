import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/todo_model.dart';

class SharedPrefs {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<TodoModel>?> getTodos({bool isDeleted = false}) async {
    SharedPreferences prefs = await _prefs;
    String key = isDeleted ? 'deletedTodos' : 'todos';
    String? data = prefs.getString(key);
    if (data == null) return null;
    List<Map<String, dynamic>> maps = jsonDecode(data)
        .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>;
    List<TodoModel> todos = maps.map((e) => TodoModel.fromJson(e)).toList();
    return todos;
  }

  Future<void> addTodos(
      {required List<TodoModel> todos, bool isDeleted = false}) async {
    List<Map<String, dynamic>> maps = todos.map((e) => e.toJson()).toList();
    String key = isDeleted ? 'deletedTodos' : 'todos';
    SharedPreferences prefs = await _prefs;
    prefs.setString(key, jsonEncode(maps));
  }

  Future<String?> getUsername() async {
    SharedPreferences prefs = await _prefs;
    return prefs.getString('username');
  }

  Future<void> setUsername(String username) async {
    SharedPreferences prefs = await _prefs;
    prefs.setString('username', username);
  }

  Future<void> logOut() async {
    SharedPreferences prefs = await _prefs;
    prefs.remove('username');
  }
}
