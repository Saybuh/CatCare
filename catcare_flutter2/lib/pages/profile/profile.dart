import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  File? _image;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userProfile =
          await _firestore.collection('users').doc(user.uid).get();
      _nameController.text = userProfile['name'];
      _imageUrl = userProfile['imageUrl'];
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _updateProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      String? imageUrl;
      if (_image != null) {
        // Upload image to storage and get URL
        // Assuming you have a function uploadImageToStorage that handles the upload
        imageUrl = await uploadImageToStorage(_image!, user.uid);
      }

      await _firestore.collection('users').doc(user.uid).update({
        'name': _nameController.text,
        'imageUrl': imageUrl ?? _imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')));
      setState(() {
        _imageUrl = imageUrl ?? _imageUrl;
      });
    }
  }

  Future<String> uploadImageToStorage(File image, String userId) async {
    // Implement your image upload logic here and return the image URL
    // For example:
    // final ref = FirebaseStorage.instance.ref().child('user_images').child('$userId.jpg');
    // await ref.putFile(image);
    // return await ref.getDownloadURL();
    return 'image_url_placeholder'; // Replace with actual URL after implementing
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.raleway()),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Text(
                'Edit Profile',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 32)),
              ),
            ),
            const SizedBox(height: 20),
            _image != null
                ? CircleAvatar(
                    radius: 40,
                    backgroundImage: FileImage(_image!),
                  )
                : _imageUrl != null
                    ? CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(_imageUrl!),
                      )
                    : CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[300],
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[700],
                        ),
                      ),
            TextButton(
              onPressed: _pickImage,
              child: Text('Change Profile Image'),
            ),
            const SizedBox(height: 20),
            _nameField(),
            const SizedBox(height: 20),
            _emailField(user?.email ?? ''),
            const SizedBox(height: 20),
            _saveButton(),
          ],
        ),
      ),
    );
  }

  Widget _nameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name',
          style: GoogleFonts.raleway(
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16)),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffF7F7F9),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(14))),
        )
      ],
    );
  }

  Widget _emailField(String email) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email Address',
          style: GoogleFonts.raleway(
              textStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16)),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: TextEditingController(text: email),
          readOnly: true,
          decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xffF7F7F9),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(14))),
        )
      ],
    );
  }

  Widget _saveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0D6EFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: _updateProfile,
      child: const Text("Save"),
    );
  }
}
