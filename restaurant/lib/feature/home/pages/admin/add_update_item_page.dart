import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restaurant/core/widgets/add_photo.dart';
import 'package:restaurant/feature/home/widgets/custom_app_bar.dart';
import 'package:restaurant/feature/home/widgets/ingredient_grid_view.dart';
import 'package:restaurant/feature/home/widgets/input_field.dart';
import 'package:restaurant/feature/models/product_item.dart';

class AddOrUpdateItemPage extends StatefulWidget {
  final ProductItem? item;
  const AddOrUpdateItemPage({super.key, this.item});

  @override
  State<AddOrUpdateItemPage> createState() => _AddOrUpdateItemPageState();
}

class _AddOrUpdateItemPageState extends State<AddOrUpdateItemPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController pricController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  ValueNotifier<File?> image = ValueNotifier(null);

  @override
  void initState() {
    if (widget.item != null) {
      nameController.text = widget.item!.itemName;
      pricController.text = widget.item!.price.toString();
      descriptionController.text = widget.item!.description!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),

                widget.item == null
                    ? CustomAppBar(
                        title: 'Add New Item',
                        textButton: 'ADD',
                        onPressed: () {},
                      )
                    : CustomAppBar(
                        title: 'Update  Item',
                        textButton: 'Update',
                        onPressed: () {},
                      ),

                SizedBox(height: 20),
                InputField(
                  title: 'ITEM NAME',
                  hint: 'Smash, Burger...',
                  controller: nameController,
                ),

                SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CATEGORY NAME',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    DropdownButton<String>(
                      isExpanded: true, // makes it take full width
                      value: 'one', // default selected value
                      items: const [
                        DropdownMenuItem(value: 'one', child: Text('One')),
                        DropdownMenuItem(value: 'two', child: Text('Two')),
                        DropdownMenuItem(value: 'three', child: Text('Three')),
                      ],
                      onChanged: (value) {
                        // handle selection
                      },
                    ),
                  ],
                ),

                SizedBox(height: 20),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UPLOAD PHOTO',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      width: double.infinity, // full width
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AddPhoto(
                            image: image,
                            icon: Icon(
                              Icons.cloud_upload,
                              size: 40,
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                InputField(
                  title: 'PRICE',
                  hint: '\$50',
                  controller: pricController,
                ),
                SizedBox(height: 20),

                IngredientGridView(),
                SizedBox(height: 20),

                InputField(
                  title: 'Description',
                  hint: 'Descripe the item',
                  controller: descriptionController,
                  numOfLines: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
