import 'package:flutter/material.dart';
import 'package:restaurant/core/constants.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String textButton;
  final Function()? onPressed;
  const CustomAppBar({
    super.key,
    required this.title,
    required this.textButton,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new, size: 20),
              ),
            ),
            SizedBox(width: 10),
            Text(title, style: TextStyle(fontSize: fontLarge)),
          ],
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(textButton, style: TextStyle(color: Colors.orange[800])),
        ),
      ],
    );
  }
}
