import 'package:flutter/material.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/screens/user/widgets/user_cart_order.dart';
import 'package:foodapp/screens/user/widgets/user_home_unsynced_items.dart';
import 'package:foodapp/screens/user/widgets/user_cart_states.dart';
import 'package:provider/provider.dart';

class UserCartScreen extends StatefulWidget {
  const UserCartScreen({super.key});

  @override
  State<UserCartScreen> createState() => _UserCartScreenState();
}

class _UserCartScreenState extends State<UserCartScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('My Orders'),
        elevation: 0,
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart, size: 18),
                  SizedBox(width: 8),
                  Text('Cart'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant, size: 18),
                  SizedBox(width: 8),
                  Text('Processing'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 18),
                  SizedBox(width: 8),
                  Text('Delivered'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        if (orderProvider.isLoading && orderProvider.orders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orderProvider.error != null) {
          return ErrorState(
            error: orderProvider.error!,
            onRetry: () => orderProvider.fetchAllOrders(),
          );
        }

        final unorderedItems = orderProvider.orderItems
            .where((item) => item.synced == false)
            .toList();
        final processingOrders = orderProvider.orders
            .where((order) => order.status.toLowerCase() != 'delivered')
            .toList();
        final deliveredOrders = orderProvider.orders
            .where((order) => order.status.toLowerCase() == 'delivered')
            .toList();

        return TabBarView(
          controller: tabController,
          children: [
            _CartTabView(
              orderItems: unorderedItems,
              onRefresh: () => orderProvider.fetchAllOrders(),
            ),
            _OrdersTabView(
              orders: processingOrders,
              orderItems: orderProvider.orderItems,
              onRefresh: () => orderProvider.fetchAllOrders(),
            ),
            _OrdersTabView(
              orders: deliveredOrders,
              orderItems: orderProvider.orderItems,
              onRefresh: () => orderProvider.fetchAllOrders(),
            ),
          ],
        );
      },
    );
  }
}

class _CartTabView extends StatelessWidget {
  final List<OrderItemModel> orderItems;
  final VoidCallback onRefresh;

  const _CartTabView({required this.orderItems, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: orderItems.isEmpty
          ? EmptyCartState()
          : UnsyncedItems(orderItems: orderItems),
    );
  }
}

class _OrdersTabView extends StatelessWidget {
  final List<OrderModel> orders;
  final List<OrderItemModel> orderItems;
  final VoidCallback onRefresh;

  const _OrdersTabView({
    required this.orders,
    required this.orderItems,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return EmptyOrdersState();
    }

    final sortedOrders = List<OrderModel>.from(orders)
      ..sort((a, b) {
        final aTime = a.createdAt ?? DateTime(1970);
        final bTime = b.createdAt ?? DateTime(1970);
        return bTime.compareTo(aTime);
      });

    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedOrders.length,
        itemBuilder: (context, index) => OrderCard(
          order: sortedOrders[index],
          orderItems: orderItems
              .where(
                (orderItem) => orderItem.orderId == sortedOrders[index].orderId,
              )
              .toList(),
        ),
      ),
    );
  }
}
