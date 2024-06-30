import 'package:catcare_flutter2/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  Future<Map<String, dynamic>?> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userProfile = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userProfile.exists) {
        return userProfile.data() as Map<String, dynamic>?;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      drawer: Drawer(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return Center(child: Text("User data not found"));
            } else {
              var userData = snapshot.data!;
              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(userData['name'] ?? 'User Name'),
                    accountEmail: Text(
                        FirebaseAuth.instance.currentUser?.email ??
                            'user@example.com'),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(
                        userData['imageUrl'] ??
                            'https://via.placeholder.com/150',
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.pets),
                    title: Text('My Cats'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/cats');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.schedule),
                    title: Text('Food Schedule'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/food_schedule');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.schedule),
                    title: Text('Water Schedule'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/water_schedule');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.medical_services),
                    title: Text('Illness Identification'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/illness_identification');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text('Care Tips'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/care_tips');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Sign Out'),
                    onTap: () async {
                      await AuthService().signout(context: context);
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${FirebaseAuth.instance.currentUser?.displayName ?? 'User'}👋',
                style: GoogleFonts.raleway(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.schedule),
                  title: Text('Upcoming Food Schedule'),
                  subtitle: Text('Today at 6:00 PM'),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.schedule),
                  title: Text('Upcoming Water Schedule'),
                  subtitle: Text('Today at 8:00 PM'),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Icon(Icons.lightbulb),
                  title: Text('Tip of the Day'),
                  subtitle: Text(
                    'Ensure your cat has fresh water available at all times.',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/food_schedule');
                    },
                    icon: Icon(Icons.schedule),
                    label: Text('Food Schedule'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/water_schedule');
                    },
                    icon: Icon(Icons.schedule),
                    label: Text('Water Schedule'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                icon: Icon(Icons.person),
                label: Text('View Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
