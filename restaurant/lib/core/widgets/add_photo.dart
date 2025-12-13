import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPhoto extends StatefulWidget {
  final ValueNotifier<File?> image;
  final Icon icon;
  const AddPhoto({super.key, required this.image, required this.icon});

  @override
  State<AddPhoto> createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked == null) return; // user canceled → do nothing

    widget.image.value = File(picked.path);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<File?>(
      valueListenable: widget.image,
      builder: (context, file, _) {
        return GestureDetector(
          onTap: pickImage,
          child: file != null
              ? Container(
                  height: 100,
                  width: 100,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: Image.file(file, fit: BoxFit.cover),
                )
              : Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: widget.icon,
                ),
        );
      },
    );
  }
}
