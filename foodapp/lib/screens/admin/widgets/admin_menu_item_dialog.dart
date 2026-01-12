import 'package:flutter/material.dart';
import 'package:foodapp/core/functions.dart';
import 'package:foodapp/l10n/app_localizations.dart';
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).t('failedToPickImage')),
        ),
      );
      return;
    }

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

    imageUrl = await uploadImage.uploadImage('item_pic', fileName, file!);

    if (mounted && imageUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).t('failedToUploadImage')),
        ),
      );
    }
    setState(() => isUploadingImage = false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.isEdit
            ? AppLocalizations.of(context).t('editMenuItem')
            : AppLocalizations.of(context).t('addMenuItem'),
      ),
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
                                AppLocalizations.of(
                                  context,
                                ).t('tapToUploadImage'),
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
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).t('itemName'),
                  hintText: AppLocalizations.of(
                    context,
                  ).t('e.g., Margherita Pizza'),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(
                      context,
                    ).t('pleaseEnterItemName');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).t('price'),
                  hintText: AppLocalizations.of(context).t('e.g., 12.99'),
                  suffixText: AppLocalizations.of(context).t('egp'),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context).t('pleaseEnterPrice');
                  }
                  if (double.tryParse(value) == null) {
                    return AppLocalizations.of(
                      context,
                    ).t('pleaseEnterValidPrice');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).t('description'),
                  hintText: AppLocalizations.of(context).t('itemDescription'),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLocalizations.of(
                      context,
                    ).t('pleaseEnterDescription');
                  }
                  if (value.trim().length < 10) {
                    return AppLocalizations.of(
                      context,
                    ).t('descriptionTooShort');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: ingreidentsController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).t('ingredients'),
                  hintText: AppLocalizations.of(context).t('itemIngredients'),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return AppLocalizations.of(
                      context,
                    ).t('pleaseEnterIngredients');
                  }
                  final parts = value
                      .split(',')
                      .map((s) => s.trim())
                      .where((s) => s.isNotEmpty)
                      .toList();
                  if (parts.isEmpty) {
                    return AppLocalizations.of(
                      context,
                    ).t('pleaseListAtLeastOneIngredient');
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
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).t('category'),
                      border: const OutlineInputBorder(),
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
                title: Text(AppLocalizations.of(context).t('available')),
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
          child: Text(AppLocalizations.of(context).t('cancel')),
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
          child: Text(
            widget.isEdit
                ? AppLocalizations.of(context).t('update')
                : AppLocalizations.of(context).t('add'),
          ),
        ),
      ],
    );
  }
}
