import 'package:flutter/material.dart';
import 'package:habittracker/models/app_settings.dart';
import 'package:habittracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class Database extends ChangeNotifier {
  static late Isar isar;
  List<Habit> habits = [];

  // initialize isar
  Future<void> initDatebase() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      HabitSchema,
      AppSettingsSchema,
    ], directory: dir.path);
  }

  // save the first run date
  Future<void> saveFirstLaunchTime() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      AppSettings appSettings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(appSettings));
    }
  }

  // get the first run date
  Future<DateTime?> getFirstLaunchTime() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    return existingSettings!.firstLaunchDate;
  }

  /*
      C R U D operations
  */

  // Create
  Future<void> createHabit(String habitName) async {
    final habit = Habit()..habitName = habitName;
    await isar.writeTxn(() => isar.habits.put(habit));
    fetchHabits();
  }

  // Read
  Future<void> fetchHabits() async {
    List<Habit> fetchedHabits = await isar.writeTxn(
      () => isar.habits.where().findAll(),
    );

    habits.clear();
    habits.addAll(fetchedHabits);

    notifyListeners();
  }

  // Update
  // modigy the check habit on and off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    final existingHabit = await isar.habits.get(id);
    if (existingHabit != null) {
      await isar.writeTxn(() async {
        if (isCompleted &&
            !existingHabit.completedDays.contains(DateTime.now())) {
          existingHabit.completedDays.add(DateTime.now());
        } else {
          existingHabit.completedDays.removeWhere(
            (date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day,
          );
        }
        await isar.habits.put(existingHabit);
      });
      fetchHabits();
    }
  }

  // modify the name of hibat
  Future<void> updateHabitName(int id, String name) async {
    final existingHabit = await isar.habits.get(id);
    if (existingHabit != null) {
      await isar.writeTxn(() async {
        existingHabit.habitName = name;
        await isar.habits.put(existingHabit);
      });
      fetchHabits();
    }
  }

  // Delete
  Future<void> deleteHabit(int id) async {
    final existingHabit = await isar.habits.get(id);
    if (existingHabit != null) {
      await isar.writeTxn(() => isar.habits.delete(id));
      fetchHabits();
    }
  }
}
