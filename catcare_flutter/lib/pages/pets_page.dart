import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetsPage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _catNameController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  void _addCat() async {
    if (user != null && _catNameController.text.isNotEmpty) {
      await _firestore
          .collection('users')
          .doc(user!.uid)
          .collection('cats')
          .add({
        'name': _catNameController.text,
      });
      _catNameController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _catNameController,
              decoration: InputDecoration(labelText: 'Cat Name'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addCat,
              child: Text('Add Cat'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('users')
                    .doc(user!.uid)
                    .collection('cats')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No cats added yet.'));
                  }

                  final cats = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: cats.length,
                    itemBuilder: (context, index) {
                      var cat = cats[index];
                      return ListTile(
                        title: Text(cat['name']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _firestore
                                .collection('users')
                                .doc(user!.uid)
                                .collection('cats')
                                .doc(cat.id)
                                .delete();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
