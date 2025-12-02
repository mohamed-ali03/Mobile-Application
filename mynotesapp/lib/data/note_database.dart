import 'package:hive/hive.dart';

class NoteDatabase {
  List notes = [];

  final _myBox = Hive.box('mybox');

  void createIntialData() {
    notes = ['Fuck gradle bro'];
  }

  void loadData() {
    notes = _myBox.get('NOTELIST');
  }

  void updateData() {
    _myBox.put('NOTELIST', notes);
  }
}
