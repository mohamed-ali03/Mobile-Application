import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final String userName;
  final void Function()? onTap;
  const UserTile({super.key, required this.userName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Row(
          children: [
            // icon
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(Icons.person),
            ),

            // username
            Text(userName),
          ],
        ),
      ),
    );
  }
}
