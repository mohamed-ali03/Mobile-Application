import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/feature/home/provider/app_provider.dart';
import 'package:restaurant/feature/home/widgets/order_card.dart';
import 'package:restaurant/feature/models/order_model.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    // listen to any change in the orders
    return Selector<AppProvider, List<OrderModel>>(
      selector: (_, provider) => provider.orders,
      builder: (context, value, _) => Scaffold(
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
      ),
    );
  }
}
