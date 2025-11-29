import 'package:hive_flutter/hive_flutter.dart';

class ToDoDatabase {
  List ToDoList = [];

  final _myBox = Hive.box('mybox');

  void createIntialData() {
    ToDoList = [
      ['Fuck the world every day', true],
      ['Fuck the world every week', false],
      ['Fuck the world every year', false],
    ];
  }

  void loadData() {
    ToDoList = _myBox.get('TODOLIST');
  }

  void updateData() {
    _myBox.put('TODOLIST', ToDoList);
  }
}
