import 'package:isar/isar.dart';

part 'habit.g.dart';

@collection
class Habit {
  Id id = Isar.autoIncrement;
  String? habitName;
  List<DateTime> completedDays = [];
}
