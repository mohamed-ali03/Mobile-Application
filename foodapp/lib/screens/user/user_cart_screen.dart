import 'package:flutter/material.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/models/order%20item%20model/order_item_model.dart';
import 'package:foodapp/models/order%20model/order_model.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/widgets/delete_confirmation_dialog.dart';
import 'package:foodapp/widgets/cart/delivered_orders_tab_view.dart';
import 'package:foodapp/widgets/cart/processing_orders_tab_view.dart';
import 'package:provider/provider.dart';

class UserCartScreen extends StatefulWidget {
  const UserCartScreen({super.key});

  @override
  State<UserCartScreen> createState() => _UserCartScreenState();
}

class _UserCartScreenState extends State<UserCartScreen> {
  late MenuProvider menuProvider;
  late OrderProvider orderProvider;
  List<OrderItemModel> allItems = [];
  List<OrderModel> allOrders = [];
  Future<ItemModel?>? item;
  bool isChanged = false;

  @override
  void initState() {
    super.initState();
    menuProvider = context.read<MenuProvider>();
    orderProvider = context.read<OrderProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(appBar: _buildAppBar(), body: _buildBody()),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Cart'),
      leading: IconButton(
        onPressed: () {
          if (isChanged) {
            // TODO : save locally
          }
          Navigator.pushNamed(context, '/userHomeScreen');
        },
        icon: const Icon(Icons.arrow_back),
      ),
      bottom: const TabBar(
        tabs: [
          Tab(text: 'Unordered'),
          Tab(text: 'Processing'),
          Tab(text: 'Delivered'),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => orderProvider.fetchAllOrders(),
          icon: const Icon(Icons.refresh),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return StreamBuilder<Map<String, dynamic>>(
      stream: orderProvider.ordersWithItemsSub,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Failed to load Items'));
        }

        final orderAndItems = snapshot.data ?? {};
        if (orderAndItems.isEmpty) {
          return const Center(child: Text('No Items'));
        }

        allOrders = orderAndItems['orders'] as List<OrderModel>;
        allItems = orderAndItems['items'] as List<OrderItemModel>;

        return TabBarView(
          children: [
            // CartTabView(
            //   items: allItems.where((item) => item.synced == false).toList(),
            //   orders: allOrders,
            //   menuProvider: menuProvider,
            //   orderProvider: orderProvider,
            //   onDeleteItem: _showDeleteConfirmationDialog,
            //   onCheckout: (items, totalPrice) => _onCheckout(items, totalPrice),
            // ),
            ProcessingOrdersTabView(
              orders: allOrders
                  .where((order) => order.status == 'Processing')
                  .toList(),
              onGetStatusColor: _getStatusColor,
              onFormatDate: _formatDate,
            ),
            DeliveredOrdersTabView(
              orders: allOrders
                  .where((order) => order.status == 'Delivered')
                  .toList(),
              onGetStatusColor: _getStatusColor,
              onFormatDate: _formatDate,
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(OrderItemModel orderItem, ItemModel item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmationDialog(
          item: item,
          orderItem: orderItem,
          onConfirm: () => _handleDeleteOrderItem(orderItem, item),
        );
      },
    );
  }

  void _handleDeleteOrderItem(OrderItemModel orderItem, ItemModel item) async {
    await orderProvider.deleteOrderItemLocally(orderItem.id);
    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} removed from cart'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onCheckout(List<OrderItemModel> orderItems, double totalPrice) async {
    final addressController = TextEditingController();
    List<ItemModel?> items = await Future.wait(
      orderItems.map((orderItem) => menuProvider.getItem(orderItem.itemId)),
    );

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Confirm Order'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Items list
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: orderItems
                      .map(
                        (orderItem) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${items.where((item) => item?.itemId == orderItem.itemId).first?.name}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'x${orderItem.quantity}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 16),
              // Address field
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  hintText: 'Enter delivery address',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              // Total price
              Text(
                'Total: $totalPrice EGP',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (addressController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter address')),
                );
                return;
              }
              OrderModel order = OrderModel()
                ..address = addressController.text
                ..createdAt = DateTime.now()
                ..status = 'pending'
                ..totalPrice = totalPrice
                ..userId = context.read<AuthProvider>().user!.authID;
              await orderProvider.placeOrder(order, orderItems);
              if (!context.mounted) return;
              Navigator.pop(context);
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    try {
      return date.toString().split('.')[0];
    } catch (e) {
      return 'N/A';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'processing':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'delivered':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
