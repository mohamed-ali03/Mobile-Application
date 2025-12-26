import 'package:flutter/material.dart';

class QuantityControl extends StatefulWidget {
  final int quantity;
  final Function(int) onChangeQuantity;
  const QuantityControl({
    super.key,
    required this.quantity,
    required this.onChangeQuantity,
  });

  @override
  State<QuantityControl> createState() => _QuantityControlState();
}

class _QuantityControlState extends State<QuantityControl> {
  late ValueNotifier<int> quantity;

  @override
  void initState() {
    quantity = ValueNotifier(widget.quantity);
    super.initState();
  }

  @override
  void dispose() {
    quantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove, size: 18),
            onPressed: () {
              if (quantity.value > 1) {
                quantity.value--;
                widget.onChangeQuantity(quantity.value);
              }
            },
            splashRadius: 20,
            constraints: BoxConstraints(minWidth: 36, minHeight: 36),
            padding: EdgeInsets.zero,
          ),
          ValueListenableBuilder(
            valueListenable: quantity,
            builder: (context, value, child) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  '$value',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add, size: 18),
            onPressed: () {
              // Increase quantity
              quantity.value++;
              widget.onChangeQuantity(quantity.value);
            },
            splashRadius: 20,
            constraints: BoxConstraints(minWidth: 36, minHeight: 36),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
