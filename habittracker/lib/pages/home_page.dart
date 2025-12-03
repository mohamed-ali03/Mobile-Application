import 'package:flutter/material.dart';
import 'package:habittracker/database/database.dart';
import 'package:habittracker/models/habit.dart';
import 'package:habittracker/utils/custom_drawer.dart';
import 'package:habittracker/utils/custom_heat_map.dart';
import 'package:habittracker/utils/habit_tile.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final habitController = TextEditingController();
  @override
  void initState() {
    Provider.of<Database>(context, listen: false).fetchHabits();
    super.initState();
  }

  void createHabit() {
    habitController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: habitController,
          decoration: InputDecoration(
            hint: Text('Add new Habit...'),
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          MaterialButton(
            onPressed: () {
              String temp = habitController.text;
              habitController.clear();
              Navigator.pop(context);
              context.read<Database>().createHabit(temp);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void updateCheckBox(int id, bool isChecked) {
    context.read<Database>().updateHabitCompletion(id, isChecked);
  }

  void updateHabitName(int id, String oldName) {
    habitController.text = oldName;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: habitController,
          decoration: InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          MaterialButton(
            onPressed: () {
              String temp = habitController.text;
              habitController.clear();
              Navigator.pop(context);
              context.read<Database>().updateHabitName(id, temp);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
    //Provider.of<Database>(context).updateHabitName(id);
  }

  void deleteHabit(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Do you want to Delete this habit?'),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<Database>().deleteHabit(id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // build a list view of habits
  Widget _buildHhabits() {
    final db = context.watch<Database>();
    List<Habit> currentHabits = db.habits;

    return ListView.builder(
      itemCount: currentHabits.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        Habit habit = currentHabits[index];
        bool isCompletedToday = isHabitCompletedTody(habit.completedDays);
        return HabitTile(
          habitName: habit.habitName!,
          isCompletedToday: isCompletedToday,
          onChanged: (value) => updateCheckBox(habit.id, value!),
          editHabit: () => updateHabitName(habit.id, habit.habitName!),
          deleteHabit: () => deleteHabit(habit.id),
        );
      },
    );
  }

  // check if the habit is completed or not
  bool isHabitCompletedTody(List<DateTime> completedDays) {
    final today = DateTime.now();
    bool temp = completedDays.any(
      (date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
    );
    return temp;
  }

  // prepare heat map dataset
  Map<DateTime, int> prepHeatMapDataset(List<Habit> habits) {
    Map<DateTime, int> dataset = {};
    for (var habit in habits) {
      for (var date in habit.completedDays) {
        final normalizeDate = DateTime(date.year, date.month, date.day);

        if (dataset.containsKey(normalizeDate)) {
          dataset[normalizeDate] = dataset[normalizeDate]! + 1;
        } else {
          dataset[normalizeDate] = 1;
        }
      }
    }
    return dataset;
  }

  Widget _buildHeatMap() {
    final habitDatabase = context.watch<Database>();

    List<Habit> currentHabits = habitDatabase.habits;

    return FutureBuilder<DateTime?>(
      future: habitDatabase.getFirstLaunchTime(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomHeatMap(
            startDate: snapshot.data!,
            datasets: prepHeatMapDataset(currentHabits),
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Colors.transparent,
      ),
      drawer: CustomDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () => createHabit(),
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      body: ListView(children: [_buildHeatMap(), _buildHhabits()]),
    );
  }
}
