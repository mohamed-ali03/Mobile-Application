import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:to_do_list/data/database.dart';
import 'package:to_do_list/utils/dialog_box.dart';
import 'package:to_do_list/utils/to_do_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  final controller = TextEditingController();

  @override
  void initState() {
    if (_myBox.get('TODOLIST') == null) {
      db.createIntialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.ToDoList[index][1] = value;
    });
    db.updateData();
  }

  void saveNewTask() {
    setState(() {
      db.ToDoList.add([controller.text, false]);
      controller.clear();
      Navigator.of(context).pop();
    });
    db.updateData();
  }

  void creatingNewTask() {
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        controller: controller,
        onSave: saveNewTask,
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
    db.updateData();
  }

  void deleteTask(int index) {
    setState(() {
      db.ToDoList.removeAt(index);
    });
    db.updateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TO DO'),
        backgroundColor: Colors.yellow,
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.yellow[200],

      floatingActionButton: FloatingActionButton(
        onPressed: creatingNewTask,
        child: Icon(Icons.add),
        backgroundColor: Colors.yellow,
      ),
      body: ListView.builder(
        itemCount: db.ToDoList.length,
        itemBuilder: (context, index) {
          return ToDoTile(
            taskName: db.ToDoList[index][0],
            value: db.ToDoList[index][1],
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
