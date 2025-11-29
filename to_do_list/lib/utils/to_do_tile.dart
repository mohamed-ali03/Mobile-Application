import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:to_do_list/core/size_config.dart';

class ToDoTile extends StatelessWidget {
  const ToDoTile({
    super.key,
    required this.taskName,
    required this.value,
    required this.onChanged,
    required this.deleteFunction,
  });

  final Function(BuildContext)? deleteFunction;
  final String taskName;
  final bool? value;
  final Function(bool?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: SizeConfig.defaultSize!,
        left: SizeConfig.defaultSize!,
        top: SizeConfig.defaultSize!,
      ),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(SizeConfig.defaultSize!),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.yellow,
          ),
          child: Row(
            children: [
              Checkbox(value: value, onChanged: onChanged),
              Text(
                taskName,
                style: TextStyle(
                  decoration: value!
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
