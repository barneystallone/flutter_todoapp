import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'td_app_bar.dart';
import 'search_box.dart';
import 'todo_item.dart';
import '../models/todo_model.dart';
import '../resources/app_color.dart';
import '../services/local/shared_prefs.dart';

class ListTodo extends StatefulWidget {
  final bool isRestorePage;

  const ListTodo({super.key, this.isRestorePage = false});

  @override
  State<ListTodo> createState() => _ListTodoState();
}

class _ListTodoState extends State<ListTodo> {
  final _searchController = TextEditingController();
  final _addController = TextEditingController();
  final _addFocus = FocusNode();
  bool _showAddBox = false;

  final SharedPrefs _prefs = SharedPrefs();
  int _statusFilterIdx = 0;
  String _searchText = '';
  List<TodoModel> _initTodos = [];
  List<TodoModel> _filterTodos = [];
  List<TodoModel> _todos = [];

  @override
  void initState() {
    super.initState();
    initTodos();
  }

  initTodos() {
    _prefs.getTodos(isDeleted: widget.isRestorePage).then((value) {
      _initTodos = value ?? (!widget.isRestorePage ? todosInit : []);
      _todos = [..._initTodos];
      _filterTodos = [..._initTodos];
      setState(() {});
    });
  }

  // Home -> Xóa todo trong todos và thêm todo đóvào deletedTodos
  // Restore -> Xóa todo trong deletedTodos
  removeTodo(TodoModel todo) {
    setState(() {
      _initTodos.remove(todo);
      setFilterTodos();
      _todos.remove(todo);
      _prefs.addTodos(todos: _initTodos, isDeleted: widget.isRestorePage);
      // Add to deleted todos
      if (!widget.isRestorePage) {
        _prefs.getTodos(isDeleted: true).then((value) {
          value = value ?? [];
          value.add(todo);
          _prefs.addTodos(todos: value, isDeleted: true);
        });
      }
    });
  }

  _showDialog({required String title, required VoidCallback successCb}) async {
    bool? status = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('😍'),
        content: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 22.0),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    if (status ?? false) {
      successCb();
    }
  }

  clickTodo(TodoModel todo) {
    if (!widget.isRestorePage) {
      return setState(() {
        todo.isDone = !(todo.isDone ?? false);
        _prefs.addTodos(todos: _initTodos, isDeleted: widget.isRestorePage);
        setFilterTodos();
      });
    }
    // Restore -> xóa khỏi deletedTodos và thêm vào todoList
    _showDialog(
        title: 'Restore this todo?',
        successCb: () {
          _prefs.getTodos().then((value) {
            value = value ?? [];
            value.add(todo);
            _prefs.addTodos(todos: value);
          });
          removeTodo(todo);
        });
  }

  // gọi method sau khi update initTodos (thêm, sửa, xóa todo)
  setFilterTodos() {
    _filterTodos = _statusFilterIdx == 0
        ? _initTodos
        : _initTodos
            .where((element) =>
                (element.isDone ?? false) == ((_statusFilterIdx - 1) != 0))
            .toList();
  }

  getTodos() {
    String searchText = _searchText.toLowerCase().trim();
    _todos = _filterTodos
        .where((element) =>
            (element.text ?? '').toLowerCase().contains(searchText))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0)
                  .copyWith(top: 12.0, bottom: 92.0),
              child: Column(
                children: [
                  SearchBox(
                      onChanged: (value) => setState(() {
                            _searchText = value;
                            getTodos();
                          }),
                      controller: _searchController),
                  Row(
                    children: List.generate(
                      todosStatus.length,
                      (int index) => Padding(
                        padding: const EdgeInsets.only(
                            top: 12.0, right: 12.0, bottom: 16.0),
                        child: Center(
                          child: FilterChip(
                            label: Text(todosStatus[index]),
                            selected: index == _statusFilterIdx,
                            onSelected: (bool value) => setState(() {
                              if (_statusFilterIdx != index) {
                                _statusFilterIdx = index;
                                setFilterTodos();
                                // click Doing -> false, Done -> true
                              }
                              getTodos();
                            }),
                            side: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: _todos.length,
                    itemBuilder: (context, index) {
                      TodoModel todo = _todos.reversed.toList()[index];
                      return TodoItem(
                        onTap: () {
                          clickTodo(todo);
                        },
                        onDeleted: () async {
                          _showDialog(
                              title: 'Do you want to remove the todo?',
                              successCb: () => removeTodo(todo));
                        },
                        text: todo.text ?? '-:-',
                        isDone: todo.isDone ?? false,
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16.8),
                  )
                ],
              ),
            ),
          ),
        ),
        if (!widget.isRestorePage)
          Positioned(
            left: 20.0,
            right: 20.0,
            bottom: 14.6,
            child: Row(
              children: [
                Expanded(
                  child: Visibility(
                    visible: _showAddBox,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 5.6),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        border: Border.all(color: AppColor.blue),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColor.shadow,
                            offset: Offset(0.0, 3.0),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _addController,
                        focusNode: _addFocus,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add a new todo item',
                          hintStyle: TextStyle(color: AppColor.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 18.0),
                GestureDetector(
                  onTap: () {
                    _showAddBox = !_showAddBox;

                    if (_showAddBox) {
                      setState(() {});
                      _addFocus.requestFocus();
                      return;
                    }

                    String text = _addController.text.trim();
                    if (text.isEmpty) {
                      setState(() {});
                      FocusScope.of(context).unfocus();
                      return;
                    }

                    int id = 1;
                    if (_initTodos.isNotEmpty) {
                      id = (_initTodos.last.id ?? 0) + 1;
                    }
                    TodoModel todo = TodoModel()
                      ..id = id
                      ..text = text;
                    _initTodos.add(todo);
                    _prefs.addTodos(todos: _initTodos);
                    _addController.clear();
                    _searchController.clear();
                    _searchText = '';
                    setFilterTodos();
                    getTodos();
                    setState(() {});
                    FocusScope.of(context).unfocus();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14.6),
                    decoration: BoxDecoration(
                      color: AppColor.blue,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColor.shadow,
                          offset: Offset(0.0, 3.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.add,
                        size: 32.0, color: AppColor.white),
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }
}
