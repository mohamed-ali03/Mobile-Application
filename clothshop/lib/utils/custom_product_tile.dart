import 'package:clothshop/models/product.dart';
import 'package:flutter/material.dart';

class CustomProductTile extends StatelessWidget {
  final Product product;
  final void Function()? onTap;
  const CustomProductTile({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.only(top: 20, left: 20),
      width: 600,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // image
              SizedBox(height: 700, child: Image.asset(product.imagePath)),

              // name
              Text(
                product.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),

              // description
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ],
          ),

          // price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$${product.price}', style: TextStyle(fontSize: 18)),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    color: Colors.black,
                  ),
                  child: Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
          // add button
        ],
      ),
    );
  }
}
