import 'package:flutter/material.dart';
import 'package:foodapp/core/functions.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatefulWidget {
  final ItemModel item;
  final String catName;
  final Function(bool) onSelectItem;

  const ItemCard({
    super.key,
    required this.item,
    required this.catName,
    required this.onSelectItem,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool selected = false;

  void _showEditItemDialog(BuildContext context, ItemModel item) {
    showDialog(
      context: context,
      builder: (context) => MenuItemFormDialog(
        isEdit: true,
        initialItem: item,
        onSave: (name, price, description, categoryId, available, imageUrl) {
          final updatedItem = ItemModel()
            ..itemId = item.itemId
            ..name = name
            ..description = description
            ..price = price
            ..categoryId = categoryId
            ..imageUrl = imageUrl.isNotEmpty ? imageUrl : item.imageUrl
            ..ingreidents = item.ingreidents
            ..available = available;

          context.read<MenuProvider>().updateItem(updatedItem);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Item page will be handled later'),
            backgroundColor: Colors.blue,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(12),
                child: Image.network(
                  widget.item.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ),
              title: Text(widget.item.name),
              subtitle: Text(widget.catName),
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: widget.item.available ? Colors.green : Colors.grey,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.item.available ? 'Available' : 'Out of Stock',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Divider(color: Colors.black54),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Price: \$${widget.item.price}'),
                  context.read<AuthProvider>().user?.role == 'user'
                      ? widget.item.available
                            ? selected
                                  ? IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selected = false;
                                          widget.onSelectItem(selected);
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () {
                                        setState(() {
                                          selected = true;
                                          widget.onSelectItem(selected);
                                        });
                                      },
                                      icon: Icon(Icons.shopping_cart),
                                    )
                            : IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.block, color: Colors.red),
                              )
                      : IconButton(
                          onPressed: () =>
                              _showEditItemDialog(context, widget.item),
                          icon: Icon(Icons.edit),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemFormDialog extends StatefulWidget {
  final bool isEdit;
  final ItemModel? initialItem;
  final Function(
    String name,
    double price,
    String description,
    int categoryId,
    bool available,
    String imageUrl,
  )
  onSave;

  const MenuItemFormDialog({
    super.key,
    this.isEdit = false,
    this.initialItem,
    required this.onSave,
  });

  @override
  State<MenuItemFormDialog> createState() => _MenuItemFormDialogState();
}

class _MenuItemFormDialogState extends State<MenuItemFormDialog> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;
  late bool isAvailable;
  late int selectedCategoryId;
  String? imageUrl;
  bool isUploadingImage = false;
  final _formKey = GlobalKey<FormState>();

  UploadImage uploadImage = UploadImage();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(
      text: widget.initialItem?.name ?? '',
    );
    priceController = TextEditingController(
      text: widget.initialItem?.price.toString() ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.initialItem?.description ?? '',
    );
    isAvailable = widget.initialItem?.available ?? true;
    selectedCategoryId = widget.initialItem?.categoryId ?? 1;
    imageUrl = widget.initialItem?.imageUrl;
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void _handleImageUpload() async {
    setState(() => isUploadingImage = true);

    final file = await uploadImage.pickImage();
    if (mounted && file == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to pick the image')));
      return;
    }

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    imageUrl = await uploadImage.uploadImage('item_pic', fileName, file!);

    if (mounted && imageUrl!.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to upload image')));
    }
    setState(() => isUploadingImage = false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdit ? 'Edit Menu Item' : 'Add Menu Item'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image Upload Section
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: imageUrl != null && imageUrl!.isNotEmpty
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(imageUrl!, fit: BoxFit.cover),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () => setState(() => imageUrl = null),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: isUploadingImage ? null : _handleImageUpload,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (isUploadingImage)
                              const CircularProgressIndicator()
                            else ...[
                              Icon(
                                Icons.image_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tap to upload image',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  hintText: 'e.g., Margherita Pizza',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: 'e.g., 12.99',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Item description...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Category selector
              Consumer<MenuProvider>(
                builder: (context, menuProvider, _) {
                  return DropdownButtonFormField<int>(
                    initialValue: selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: menuProvider.categories
                        .map(
                          (cat) => DropdownMenuItem(
                            value: cat.categoryId,
                            child: Text(cat.name),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => selectedCategoryId = value ?? 1);
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Available'),
                value: isAvailable,
                onChanged: (value) {
                  setState(() => isAvailable = value ?? true);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: isUploadingImage
              ? null
              : () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSave(
                      nameController.text,
                      double.parse(priceController.text),
                      descriptionController.text,
                      selectedCategoryId,
                      isAvailable,
                      imageUrl ?? '',
                    );
                  }
                },
          child: Text(widget.isEdit ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
