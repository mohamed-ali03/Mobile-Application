import 'package:flutter/material.dart';
import 'package:foodapp/core/functions.dart';
import 'package:foodapp/models/item%20model/item_model.dart';
import 'package:foodapp/providers/menu_provider.dart';
import 'package:provider/provider.dart';

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
    String ingreidents,
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
  late TextEditingController ingreidentsController;
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
    ingreidentsController = TextEditingController(
      text: widget.initialItem?.ingreidents ?? '',
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
    ingreidentsController.dispose();
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
                  suffixText: 'EGP',
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
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  if (value.trim().length < 10) {
                    return 'Description is too short';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: ingreidentsController,
                decoration: const InputDecoration(
                  labelText: 'Ingredients',
                  hintText: 'Item ingredients (comma separated)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter ingredients';
                  }
                  final parts = value
                      .split(',')
                      .map((s) => s.trim())
                      .where((s) => s.isNotEmpty)
                      .toList();
                  if (parts.isEmpty) {
                    return 'Please list at least one ingredient';
                  }
                  return null;
                },
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
                  if ((_formKey.currentState?.validate() ?? false)) {
                    widget.onSave(
                      nameController.text,
                      double.parse(priceController.text),
                      descriptionController.text,
                      selectedCategoryId,
                      isAvailable,
                      imageUrl ?? '',
                      ingreidentsController.text,
                    );
                  }
                },
          child: Text(widget.isEdit ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}
