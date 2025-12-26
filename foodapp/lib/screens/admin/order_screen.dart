// import 'package:flutter/material.dart';
// import 'package:foodapp/providers/auth_provider.dart';
// import 'package:foodapp/providers/order_provider.dart';
// import 'package:provider/provider.dart';

// class OrdersScreen extends StatefulWidget {
//   const OrdersScreen({super.key});

//   @override
//   State<OrdersScreen> createState() => _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch orders on screen load
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<OrderProvider>().fetchAllOrders();
//     });
//   }

//   Future<void> _onRefresh() async {
//     return context.read<OrderProvider>().fetchAllOrders();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('📦 My Orders'),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: context.read<AuthProvider>().logout,
//             icon: Icon(Icons.logout),
//           ),
//           IconButton(
//             onPressed: _onRefresh,
//             icon: const Icon(Icons.refresh),
//             tooltip: 'Refresh Orders',
//           ),
//         ],
//       ),
//       body: Consumer<OrderProvider>(
//         builder: (context, orderProvider, _) {
//           // Loading state on first load
//           if (orderProvider.isLoading && orderProvider.ordersSub == null) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           // Error state
//           if (orderProvider.error != null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 48, color: Colors.red),
//                   const SizedBox(height: 16),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 24),
//                     child: Text(
//                       'Error: ${orderProvider.error}',
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton.icon(
//                     onPressed: _onRefresh,
//                     icon: const Icon(Icons.refresh),
//                     label: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           // Stream builder for orders
//           return RefreshIndicator(
//             onRefresh: _onRefresh,
//             child: StreamBuilder<List<Map<String, dynamic>>>(
//               stream: orderProvider.ordersSub,
//               builder: (context, snapshot) {
//                 // Loading state
//                 if (snapshot.connectionState == ConnectionState.waiting &&
//                     snapshot.data == null) {
//                   return const Center(child: CircularProgressIndicator());
//                 }

//                 // Error state
//                 if (snapshot.hasError) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.error_outline,
//                           size: 48,
//                           color: Colors.red,
//                         ),
//                         const SizedBox(height: 16),
//                         Text('Error: ${snapshot.error}'),
//                         const SizedBox(height: 24),
//                         ElevatedButton.icon(
//                           onPressed: _onRefresh,
//                           icon: const Icon(Icons.refresh),
//                           label: const Text('Retry'),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 final orderData = snapshot.data ?? [];

//                 // Empty state
//                 if (orderData.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.shopping_cart_outlined,
//                           size: 64,
//                           color: Colors.grey,
//                         ),
//                         const SizedBox(height: 16),
//                         const Text(
//                           'No orders yet',
//                           style: TextStyle(fontSize: 16, color: Colors.grey),
//                         ),
//                         const SizedBox(height: 24),
//                         ElevatedButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: const Text('Start Shopping'),
//                         ),
//                       ],
//                     ),
//                   );
//                 }

//                 // Orders list
//                 return ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: orderData.length,
//                   itemBuilder: (context, index) {
//                     final order = orderData[index]['order'];
//                     final items = orderData[index]['items'] as List;

//                     return OrderCard(order: order, items: items);
//                   },
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class OrderCard extends StatelessWidget {
//   final dynamic order;
//   final List items;

//   const OrderCard({super.key, required this.order, required this.items});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 2,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: () {
//           // Add order detail navigation here if needed
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Order #${order.orderId ?? order.id} details'),
//               duration: const Duration(seconds: 1),
//             ),
//           );
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header: Order ID and Status
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Text(
//                       'Order #${order.orderId ?? order.id}',
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: _getStatusColor(order.status),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Text(
//                       order.status.toUpperCase(),
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),

//               // Date
//               Text(
//                 '📅 ${_formatDate(order.createdAt)}',
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//               const SizedBox(height: 8),

//               // Address
//               Text(
//                 '📍 ${order.address ?? "No address"}',
//                 style: const TextStyle(fontSize: 12),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 12),

//               // Items count
//               Text(
//                 '${items.length} item${items.length > 1 ? 's' : ''}',
//                 style: const TextStyle(
//                   fontSize: 12,
//                   color: Colors.blue,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // Divider
//               Divider(color: Colors.grey[300]),
//               const SizedBox(height: 8),

//               // Total Price and Status
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text(
//                     'Total:',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     '\$${order.totalPrice?.toStringAsFixed(2) ?? "0.00"}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green,
//                     ),
//                   ),
//                 ],
//               ),

//               // Synced indicator
//               const SizedBox(height: 8),
//               if (order.synced == false)
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     // ignore: deprecated_member_use
//                     color: Colors.orange.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                   child: const Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.cloud_off, size: 14, color: Colors.orange),
//                       SizedBox(width: 4),
//                       Text(
//                         'Syncing...',
//                         style: TextStyle(fontSize: 11, color: Colors.orange),
//                       ),
//                     ],
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   String _formatDate(dynamic date) {
//     if (date == null) return 'N/A';
//     try {
//       return date.toString().split('.')[0];
//     } catch (e) {
//       return 'N/A';
//     }
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'pending':
//         return Colors.orange;
//       case 'completed':
//         return Colors.green;
//       case 'cancelled':
//         return Colors.red;
//       case 'processing':
//         return Colors.blue;
//       default:
//         return Colors.grey;
//     }
//   }
// }
