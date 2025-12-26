import 'package:flutter/material.dart';
import 'package:foodapp/providers/order_provider.dart';
import 'package:foodapp/screens/user/widgets/unsynced_items.dart';
import 'package:provider/provider.dart';

class UserCartScreenn extends StatefulWidget {
  const UserCartScreenn({super.key});

  @override
  State<UserCartScreenn> createState() => _UserCartScreennState();
}

class _UserCartScreennState extends State<UserCartScreenn>
    with TickerProviderStateMixin {
  late OrderProvider orderProvider;
  late TabController tabController;

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
          // TODO : save locally
          Navigator.pushNamed(context, '/userHomeScreen');
        },
        icon: const Icon(Icons.arrow_back),
      ),
      bottom: TabBar(
        controller: tabController,
        tabs: [
          Tab(text: 'Unordered'),
          Tab(text: 'Processing'),
          Tab(text: 'Delivered'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: tabController,
      children: [
        UnsyncedItems(orderProvider: orderProvider),
        Container(color: Colors.blue),
        Container(color: Colors.yellow),
      ],
    );
  }
}
