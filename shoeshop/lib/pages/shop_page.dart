import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoeshop/core/size_config.dart';
import 'package:shoeshop/models/shoe_model.dart';
import 'package:shoeshop/utils/shoe_tile.dart';
import 'package:shoeshop/models/cart.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final Cart cart = Cart();

  void addItem(ShoeModel shoe) {
    Provider.of<Cart>(context, listen: false).addItemToUserCart(shoe);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Successfully add !!'),
        content: Text('Check you cart'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: Consumer<Cart>(
          builder: (context, value, child) => Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.defaultSize! * 2,
                  right: SizeConfig.defaultSize! * 3,
                  left: SizeConfig.defaultSize! * 3,
                ),
                child: Container(
                  height: SizeConfig.defaultSize! * 3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Search',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Icon(Icons.search, color: Colors.grey[600]),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.defaultSize! * 2,
                ),
                child: Text(
                  'Everyone flies.. some fly longer than others',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(SizeConfig.defaultSize! * 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hot Picks',
                      style: TextStyle(
                        fontSize: SizeConfig.defaultSize! * 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      'See all',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: SizeConfig.defaultSize!,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: value.getShoesList().length,
                  itemBuilder: (context, index) {
                    ShoeModel shoe = value.getShoesList()[index];
                    return ShoeTile(shoe: shoe, onTap: () => addItem(shoe));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
