import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cats extends StatefulWidget {
  @override
  _CatsState createState() => _CatsState();
}

class _CatsState extends State<Cats> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _imageUrl = ''; // This should be updated with the image upload logic

  void _addCat() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (_nameController.text.isEmpty ||
        _typeController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _imageUrl.isEmpty ||
        user == null) {
      return;
    }

    await _firestore.collection('cats').add({
      'userId': user.uid, // Add this line
      'name': _nameController.text,
      'type': _typeController.text,
      'age': _ageController.text,
      'imageUrl': _imageUrl,
    });

    // Clear the text fields and close the modal
    _nameController.clear();
    _typeController.clear();
    _ageController.clear();
    _imageUrl = '';
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Cat added successfully')));
  }

  void _editCat(String id) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (_nameController.text.isEmpty ||
        _typeController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _imageUrl.isEmpty ||
        user == null) {
      return;
    }

    await _firestore.collection('cats').doc(id).update({
      'userId': user.uid, // Add this line if necessary
      'name': _nameController.text,
      'type': _typeController.text,
      'age': _ageController.text,
      'imageUrl': _imageUrl,
    });

    // Clear the text fields and close the modal
    _nameController.clear();
    _typeController.clear();
    _ageController.clear();
    _imageUrl = '';
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Cat updated successfully')));
  }

  void _removeCat(String id) async {
    await _firestore.collection('cats').doc(id).delete();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Cat removed successfully')));
  }

  void _showCatModal(BuildContext context,
      {String? id, String? name, String? type, String? age, String? imageUrl}) {
    if (id != null) {
      _nameController.text = name!;
      _typeController.text = type!;
      _ageController.text = age!;
      _imageUrl = imageUrl!;
    } else {
      _nameController.clear();
      _typeController.clear();
      _ageController.clear();
      _imageUrl = '';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _typeController,
                  decoration: InputDecoration(labelText: 'Type of Cat'),
                ),
                TextField(
                  controller: _ageController,
                  decoration: InputDecoration(labelText: 'Age'),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Image URL'),
                  onChanged: (value) {
                    _imageUrl = value;
                  },
                  controller: TextEditingController(
                      text: _imageUrl), // Pre-fill with current image URL
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (id == null) {
                      _addCat();
                    } else {
                      _editCat(id);
                    }
                  },
                  child: Text(id == null ? 'Add Cat' : 'Edit Cat'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cats'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('cats')
            .where('userId', isEqualTo: user?.uid) // Add this line
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final cats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: cats.length,
            itemBuilder: (context, index) {
              final cat = cats[index];
              final catData = cat.data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(catData['imageUrl']),
                  ),
                  title: Text(catData['name']),
                  subtitle:
                      Text('Type: ${catData['type']} - Age: ${catData['age']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _showCatModal(
                            context,
                            id: cat.id,
                            name: catData['name'],
                            type: catData['type'],
                            age: catData['age'],
                            imageUrl: catData['imageUrl'],
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeCat(cat.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCatModal(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
