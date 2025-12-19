import 'package:flutter/material.dart';
import 'package:restaurant/feature/home/widgets/order_card.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // listen to any change in the orders
    return Scaffold(
      appBar: AppBar(title: Text('Orders Page')),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return OrderCard(
            userName: "Mohamed Ali",
            orderName: "Double Cheese Burger",
            time: "5 min ago",
            userImage: "https://i.pravatar.cc/150",
            orderImage: "https://picsum.photos/200",
            onAccept: () {},
            onCancel: () {},
          );
        },
      ),
    );
  }
}
