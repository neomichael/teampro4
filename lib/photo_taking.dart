import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PhotoTakingScreen extends StatefulWidget {
  final Function(File image)? onImageSaved;

  const PhotoTakingScreen({Key? key, this.onImageSaved}) : super(key: key);

  @override
  _PhotoTakingScreenState createState() => _PhotoTakingScreenState();
}

class _PhotoTakingScreenState extends State<PhotoTakingScreen> {
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> saveImage() async {
    if (_image != null) {
      try {
        // Read the image file
        Uint8List imageBytes = await _image!.readAsBytes();
        img.Image? originalImage = img.decodeImage(imageBytes);

        if (originalImage != null) {
          // Resize the image
          img.Image resizedImage = img.copyResize(originalImage, width: 800);

          // Encode the resized image to JPEG
          List<int> resizedJpg = img.encodeJpg(resizedImage, quality: 85);

          // Save the resized image
          final result = await ImageGallerySaver.saveImage(Uint8List.fromList(resizedJpg));
          if (result['isSuccess']) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.imageSaved)),
            );
            if (widget.onImageSaved != null) {
              widget.onImageSaved!(_image!);
            }
          } else {
            throw Exception('Failed to save image');
          }
        } else {
          throw Exception('Failed to decode image');
        }
      } catch (e) {
        print('Error saving image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.imageSaveError ?? 'Failed to save image')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.noImageSelected)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.cameraTest),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (_image != null)
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                else
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Text(AppLocalizations.of(context)!.noImageSelected),
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: getImage,
                  child: Text(AppLocalizations.of(context)!.takePicture),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: saveImage,
                  child: Text(AppLocalizations.of(context)!.saveImage),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}