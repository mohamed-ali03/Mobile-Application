import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/core/size_config.dart';
import 'package:restaurant/core/widgets/add_photo.dart';
import 'package:restaurant/feature/home/provider/app_provider.dart';
import 'package:restaurant/feature/home/widgets/custom_app_bar.dart';
import 'package:restaurant/core/widgets/input_field.dart';
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
  TextEditingController ingreidentsController = TextEditingController();

  ValueNotifier<String> categoryID = ValueNotifier('');
  ValueNotifier<bool> isAvailable = ValueNotifier(false);

  @override
  void initState() {
    // true if you came to update not to create new item
    if (widget.item != null) {
      nameController.text = widget.item!.itemName;
      pricController.text = widget.item!.price.toString();
      descriptionController.text = widget.item!.description;
      categoryID.value = widget.item!.categoryId;
      context.read<AppProvider>().imageURL = widget.item!.imageUrl;
      isAvailable.value = widget.item!.isAvailable;
      ingreidentsController.text = widget.item!.ingredients;
    }
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    pricController.dispose();
    descriptionController.dispose();
    ingreidentsController.dispose();
    categoryID.dispose();
    isAvailable.dispose();
    super.dispose();
  }

  // add new item func
  void addItem() async {
    ProductItem newItem = ProductItem(
      itemId: '',
      itemName: nameController.text,
      categoryId: categoryID.value,
      categoryName: context
          .read<AppProvider>()
          .categories
          .firstWhere((cat) => cat.categoryId == categoryID.value)
          .categoryName,
      description: descriptionController.text,
      ingredients: ingreidentsController.text,
      price: double.tryParse(pricController.text) ?? 0,
      isAvailable: isAvailable.value,
      imageUrl: context.read<AppProvider>().imageURL,
    );

    await context.read<AppProvider>().addNewItem(newItem);
    Navigator.pop(context);
  }

  // update exist item
  void updateItem() async {
    await context.read<AppProvider>().modifyItem(
      widget.item!, // existing product
      newName: nameController.text.trim(),
      newCategoryId: categoryID.value,
      newCategoryName: context
          .read<AppProvider>()
          .categories
          .firstWhere((cat) => cat.categoryId == categoryID.value)
          .categoryName,
      newDescription: descriptionController.text.trim(),
      newIngredients:
          ingreidentsController.text, // make sure this is List<String>
      newPrice: double.tryParse(pricController.text.trim()),
      newAvailability: isAvailable.value,
      newImageUrl: context.read<AppProvider>().imageURL,
    );
    Navigator.pop(context);
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
                // show two different string according on the sitaution
                widget.item == null
                    ? CustomAppBar(
                        title: 'Add New Item',
                        textButton: 'ADD',
                        onPressed: addItem,
                      )
                    : CustomAppBar(
                        title: 'Update  Item',
                        textButton: 'Update',
                        onPressed: updateItem,
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
                    // watch the selected category name and save it
                    ValueListenableBuilder(
                      valueListenable: categoryID,
                      builder: (context, value, _) => DropdownButton<String>(
                        isExpanded: true,
                        value: value.isEmpty ? null : value,
                        items: context
                            .read<AppProvider>()
                            .categories
                            .map(
                              (category) => DropdownMenuItem(
                                value: category.categoryId,
                                child: Text(category.categoryName),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          // update the category id
                          categoryID.value = value!;
                        },
                      ),
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
                    AddPhoto(
                      icon: Icon(
                        Icons.cloud_upload,
                        size: SizeConfig.defaultSize! * 5,
                        color: Colors.orange,
                      ),
                      folder: 'items',
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: InputField(
                        title: 'PRICE',
                        hint: '\$50',
                        controller: pricController,
                        numbersOnly: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        Text(
                          'Is available',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: isAvailable,
                          builder: (context, value, _) => CupertinoSwitch(
                            value: value,
                            onChanged: (value) => isAvailable.value = value,
                            activeColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                InputField(
                  title: 'INGREIDENTS',
                  hint: 'Beef,cheese,tomato...',
                  controller: ingreidentsController,
                  numOfLines: 2,
                ),
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
