import 'package:flutter/material.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:provider/provider.dart';
import 'package:foodapp/screens/staff/widgets/staff_stat_card.dart';

class StaffHomeScreen extends StatelessWidget {
  const StaffHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text('Staff Dashboard'), elevation: 0),
      body: SafeArea(
        child: Consumer2<OrderProvider, MenuProvider>(
          builder: (context, orderProv, menuProv, child) {
            final orders = orderProv.orders;
            final pending = orders
                .where((o) => o.status.toLowerCase() == 'pending')
                .length;
            final processing = orders
                .where(
                  (o) =>
                      o.status.toLowerCase() != 'pending' &&
                      o.status.toLowerCase() != 'delivered',
                )
                .length;

            return RefreshIndicator(
              onRefresh: () async {
                await Future.wait([
                  orderProv.fetchAllOrders(),
                  menuProv.sync(),
                ]);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),

                    // Stats row
                    Row(
                      children: [
                        Expanded(
                          child: StaffStatCard(
                            label: 'Pending',
                            value: pending.toString(),
                            color: Colors.orange,
                            icon: Icons.pending,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StaffStatCard(
                            label: 'Processing',
                            value: processing.toString(),
                            color: Colors.blue,
                            icon: Icons.restaurant,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Quick actions
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              '/staffOrdersScreen',
                            ),
                            icon: const Icon(Icons.list_alt),
                            label: const Text('View Orders'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/accountScreen'),
                            icon: const Icon(Icons.person),
                            label: const Text('Profile'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Menu summary
                    Text(
                      'Menu items',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${menuProv.items.length}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Total items',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              '/adminMenuScreen',
                            ),
                            child: const Text('Manage Menu'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
