import 'package:flutter/material.dart';
import 'package:slideable/slideable.dart';

class HabitTile extends StatelessWidget {
  final String habitName;
  final void Function(bool?)? onChanged;
  final void Function() editHabit;
  final void Function() deleteHabit;
  final bool isCompletedToday;
  const HabitTile({
    super.key,
    required this.habitName,

    required this.isCompletedToday,
    required this.onChanged,
    required this.editHabit,
    required this.deleteHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Slideable(
        backgroundColor: Theme.of(context).colorScheme.surface,

        items: [
          ActionItems(
            icon: Icon(Icons.edit),
            backgroudColor: Colors.grey.shade800,
            radius: BorderRadius.circular(16),
            onPress: editHabit,
          ),
          ActionItems(
            icon: Icon(Icons.delete),
            backgroudColor: Colors.red,
            radius: BorderRadius.circular(16),
            onPress: deleteHabit,
          ),
        ],
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              onChanged!(!isCompletedToday);
            }
          },
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: isCompletedToday
                  ? Colors.green
                  : Theme.of(context).colorScheme.secondary,
            ),
            child: ListTile(
              title: Text(habitName),
              leading: Checkbox(
                value: isCompletedToday,
                onChanged: onChanged,
                activeColor: Colors.green,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
