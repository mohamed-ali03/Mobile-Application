import 'package:flutter/material.dart';
import 'package:foodapp/core/functions.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/models/category%20model/category_model.dart';
import 'package:foodapp/providers/auth_provider.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:provider/provider.dart';

class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({super.key});

  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  Future<void> _onRefresh() async {
    return context.read<MenuProvider>().sync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🍽️ Menu Management'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: context.read<AuthProvider>().logout,
            icon: Icon(Icons.logout),
          ),
          IconButton(
            onPressed: _onRefresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Menu',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
      body: Consumer<MenuProvider>(
        builder: (context, menuProvider, _) {
          // Error state
          if (menuProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Error: ${menuProvider.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _onRefresh,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          // Stream builder for items
          return StreamBuilder<List<ItemModel>>(
            stream: menuProvider.itemsStream,
            builder: (context, snapshot) {
              // Loading state
              if (snapshot.connectionState == ConnectionState.waiting &&
                  snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }

              // Error state
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text('Error: ${snapshot.error}'),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _onRefresh,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              final items = snapshot.data ?? [];

              // Empty state
              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.restaurant_menu,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No menu items yet',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => _showAddItemDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Add First Item'),
                      ),
                    ],
                  ),
                );
              }

              // Items list
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return MenuItemCard(
                      item: item,
                      onEdit: () => _showEditItemDialog(context, item),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => MenuItemFormDialog(
        onSave: (name, price, description, categoryId, available, imageUrl) {
          final newItem = ItemModel()
            ..name = name
            ..price = price
            ..description = description
            ..categoryId = categoryId
            ..available = available
            ..imageUrl = imageUrl;
          context.read<MenuProvider>().addItem(newItem);
          Navigator.pop(context);
        },
      ),
    );
  }

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
}

class MenuItemCard extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onEdit;

  const MenuItemCard({super.key, required this.item, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Name and Availability
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: item.available ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    item.available ? 'Available' : 'Out of Stock',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Description
            if (item.description.isNotEmpty)
              Text(
                item.description,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            if (item.description.isNotEmpty) const SizedBox(height: 12),

            // Divider
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 8),

            // Price and Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Edit',
                    ),
                  ],
                ),
              ],
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
                  return StreamBuilder<List<CategoryModel>>(
                    stream: menuProvider.categoriesStream,
                    builder: (context, snapshot) {
                      final categories = (snapshot.data ?? []);
                      if (categories.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return DropdownButtonFormField<int>(
                        initialValue: selectedCategoryId,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: categories
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
