import 'package:flutter/material.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/screens/admin/widgets/show_orders.dart';
import 'package:provider/provider.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen>
    with TickerProviderStateMixin {
  late OrderProvider orderProvider;
  late TabController tabController;
  Map<String, dynamic> order = {};

  @override
  void initState() {
    orderProvider = context.read<OrderProvider>();
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Cart'),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back),
      ),
      bottom: TabBar(
        controller: tabController,
        tabs: [
          Tab(text: 'Pending'),
          Tab(text: 'Processing'),
          Tab(text: 'Delivered'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<OrderProvider>(
      builder: (context, value, child) {
        if (value.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (value.error != null) {
          return Center(child: Text('Error'));
        }

        value.orders.sort((a, b) => (b.orderId ?? 0).compareTo(a.orderId ?? 0));
        return TabBarView(
          controller: tabController,
          children: [
            ShowOrders(
              orders: value.orders
                  .where((order) => order.status.toLowerCase() == 'pending')
                  .toList(),
              items: value.orderItems,
            ),
            ShowOrders(
              orders: value.orders
                  .where(
                    (order) =>
                        order.status.toLowerCase() != 'pending' &&
                        order.status.toLowerCase() != 'delivered',
                  )
                  .toList(),
              items: value.orderItems,
            ),
            ShowOrders(
              orders: value.orders
                  .where((order) => order.status.toLowerCase() == 'delivered')
                  .toList(),
              items: value.orderItems,
            ),
          ],
        );
      },
    );
  }
}
