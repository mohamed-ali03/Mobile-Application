import 'package:flutter/material.dart';
import 'package:restaurant/core/constants.dart';

class RateBox extends StatelessWidget {
  final double rate;
  final int reviews;
  const RateBox({super.key, required this.rate, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.star, color: Colors.orange, size: 18),
        SizedBox(width: 5),
        Text(rate.toString(), style: TextStyle(color: Colors.orange[800])),
        SizedBox(width: 5),
        Text(
          '($reviews Reviws)',
          style: TextStyle(color: Colors.grey.shade600, fontSize: fontSmall),
        ),
      ],
    );
  }
}
