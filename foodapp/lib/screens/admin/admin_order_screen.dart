import 'package:flutter/material.dart';
import 'package:foodapp/l10n/app_localizations.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/screens/admin/widgets/admin_order_states.dart';
import 'package:foodapp/screens/admin/widgets/admin_orders_stats.dart';
import 'package:foodapp/screens/admin/widgets/admin_orders_views.dart';
import 'package:provider/provider.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen>
    with TickerProviderStateMixin {
  late TabController tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().fetchAllUsers();
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<OrderModel> _getFilteredOrders(List<OrderModel> orders) {
    if (_searchQuery.isEmpty) return orders;

    final query = _searchQuery.toLowerCase();
    return orders.where((order) {
      return order.orderId.toString().contains(query) ||
          order.address.toLowerCase().contains(query);
    }).toList();
  }

  Map<String, int> _calculateStats(List<OrderModel> orders) {
    return {
      'pending': orders
          .where((o) => o.status.toLowerCase() == 'pending')
          .length,
      'processing': orders
          .where(
            (o) =>
                o.status.toLowerCase() != 'pending' &&
                o.status.toLowerCase() != 'delivered',
          )
          .length,
      'delivered': orders
          .where((o) => o.status.toLowerCase() == 'delivered')
          .length,
      'total': orders.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).t('orderManagement')),
        elevation: 0,
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pending, size: 18),
                  SizedBox(width: 8),
                  Text(AppLocalizations.of(context).t('pending')),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant, size: 18),
                  SizedBox(width: 8),
                  Text(AppLocalizations.of(context).t('processing')),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 18),
                  SizedBox(width: 8),
                  Text(AppLocalizations.of(context).t('delivered')),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading && orderProvider.orders.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (orderProvider.error != null) {
            return AdminOrdersErrorState(
              error: orderProvider.error!,
              onRetry: () => orderProvider.fetchAllOrders(),
            );
          }

          final sortedOrders = List<OrderModel>.from(orderProvider.orders)
            ..sort((a, b) => (b.orderId ?? 0).compareTo(a.orderId ?? 0));

          final stats = _calculateStats(sortedOrders);

          return Column(
            children: [
              // Stats Section
              AdminOrdersStats(stats: stats),

              // Search Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(
                      context,
                    ).t('searchByOrderIdOrAddress'),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                ),
              ),

              // Orders List
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    AdminOrderTabView(
                      orders: _getFilteredOrders(
                        sortedOrders
                            .where(
                              (order) =>
                                  order.status.toLowerCase() == 'pending',
                            )
                            .toList(),
                      ),
                      orderItems: orderProvider.orderItems,
                      onRefresh: () => orderProvider.fetchAllOrders(),
                    ),
                    AdminOrderTabView(
                      orders: _getFilteredOrders(
                        sortedOrders
                            .where(
                              (order) =>
                                  order.status.toLowerCase() != 'pending' &&
                                  order.status.toLowerCase() != 'delivered',
                            )
                            .toList(),
                      ),
                      orderItems: orderProvider.orderItems,
                      onRefresh: () => orderProvider.fetchAllOrders(),
                    ),
                    AdminOrderTabView(
                      orders: _getFilteredOrders(
                        sortedOrders
                            .where(
                              (order) =>
                                  order.status.toLowerCase() == 'delivered',
                            )
                            .toList(),
                      ),
                      orderItems: orderProvider.orderItems,
                      onRefresh: () => orderProvider.fetchAllOrders(),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
