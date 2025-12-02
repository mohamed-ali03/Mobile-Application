import 'package:flutter/material.dart';
import 'package:isarlocal/utils/note_settings.dart';
import 'package:popover/popover.dart';

class NoteTile extends StatelessWidget {
  final String text;
  final void Function()? deleteNodePrassed;
  final void Function()? updateNodePrassed;
  const NoteTile({
    super.key,
    required this.text,
    required this.deleteNodePrassed,
    required this.updateNodePrassed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        title: Text(text),
        trailing: Builder(
          builder: (context) => IconButton(
            onPressed: () => showPopover(
              height: 100,
              width: 100,
              context: context,
              bodyBuilder: (context) => NoteSettings(
                onEdit: updateNodePrassed,
                onDelete: deleteNodePrassed,
              ),
            ),
            icon: Icon(Icons.more_vert),
          ),
        ),
      ),
    );
  }
}
