import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/core/functions.dart';
import 'package:restaurant/core/size_config.dart';
import 'package:restaurant/core/widgets/show_image.dart';
import 'package:restaurant/feature/home/provider/app_provider.dart';

class AddPhoto extends StatefulWidget {
  final Icon icon;
  final String folder;

  const AddPhoto({super.key, required this.icon, required this.folder});

  @override
  State<AddPhoto> createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  File? image;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickAndUploadImage() async {
    // pick photo from device
    final picked = await _picker.pickImage(source: ImageSource.gallery);

    // check if it is null and assign it to image file
    if (picked == null) return;
    final file = File(picked.path);
    image = file;

    try {
      // create a file name for new photo
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      // check if the context is not mounted
      if (!mounted) return;
      // upload photo to supabase storage in in {bucket => widget.folder , fileName => fileName}
      await context.read<AppProvider>().uploadImage(
        widget.folder,
        fileName,
        file,
      );
    } catch (e) {
      if (!mounted) return;
      showCustomDialog(context, 'Error occurs try again');
    }
  }

  @override
  Widget build(BuildContext context) {
    // watch only the image url form app provider
    return Selector<AppProvider, String>(
      selector: (_, provider) => provider.imageURL,
      builder: (context, imageurl, _) {
        // if taped --> get photo and upload it to supabase  using  /* pickAndUploadImage */
        return GestureDetector(
          onTap: pickAndUploadImage,
          child: Container(
            height: SizeConfig.defaultSize! * 25,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            // if there is a url avaiable show the photo
            child: imageurl.isNotEmpty
                ? ShowImage(imageUrl: imageurl)
                // if not show the desired icon
                : widget.icon,
          ),
        );
      },
    );
  }
}
