import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getgroovy/database_helpers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';




class ProfilePicture extends StatefulWidget {
  const ProfilePicture ({super.key, required this.title});
  final String title; 
  @override 
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  File? image;
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Column( 
          children: [
            const Spacer(),
            image != null ? ClipOval(
              child: Image.file(
                image!,
                width:160,
                height: 160,
                fit: BoxFit.cover,
              ),
            )
            : const FlutterLogo(size:160),
            const SizedBox(height: 24),
            const Text(
              'Image Picker',
            ),
            const SizedBox(height: 48),
              buildButton(
              title: 'Pick Camera Gallery', 
              icon: Icons.image_outlined, 
              onClicked: () => pickImage(ImageSource.gallery),
            ),
            const SizedBox(height: 24),
              buildButton(
                title:'Pick Camera',
                icon: Icons.camera_alt_outlined,
                onClicked: () => pickImage(ImageSource.camera),
              ),
              const Spacer(), 
          ],
        ), 
      ),
    );
  }
  Widget buildButton({
      required String title, 
      required IconData icon, 
      required VoidCallback onClicked,
    }) => ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        textStyle: const TextStyle(fontSize: 20),
      ),
    onPressed: onClicked, 
    child: Row(
      children: [
        Icon(icon, size: 28),
        const SizedBox(width: 16),
        Text(title), 
      ],
    ),
    );
  
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return; 
      final imageTemporary = File(image.path); 
      setState(() =>this.image = imageTemporary);
      DatabaseHelpers.updateProfilePicture(imageTemporary);
    } on PlatformException catch(e) {
      print('Failed to pick image$e');
    }
  }
}