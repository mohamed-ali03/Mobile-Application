import 'package:flutter/material.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/screens/admin/widgets/admin_orders_views.dart';
import 'package:provider/provider.dart';

class StaffOrdersScreen extends StatefulWidget {
  const StaffOrdersScreen({super.key});
  @override
  State<StaffOrdersScreen> createState() => _StaffOrdersScreenState();
}

class _StaffOrdersScreenState extends State<StaffOrdersScreen> {
  @override
  void initState() {
    super.initState();
    // safe to read provider in initState if using read()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().fetchAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staff Orders')),
      body: Consumer<OrderProvider>(
        builder: (context, orderProv, _) {
          if (orderProv.isLoading && orderProv.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = orderProv.orders
              .where((o) => o.status.toLowerCase() != 'delivered')
              .toList();

          if (orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
                    const SizedBox(height: 24),
                    const Text('No active orders'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => orderProv.fetchAllOrders(),
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              ),
            );
          }

          return AdminOrderTabView(
            orders: orders,
            orderItems: orderProv.orderItems,
            onRefresh: () => orderProv.fetchAllOrders(),
          );
        },
      ),
    );
  }
}
