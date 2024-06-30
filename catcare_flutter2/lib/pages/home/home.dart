import 'package:catcare_flutter2/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'CatCare',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
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
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello👋',
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                FirebaseAuth.instance.currentUser!.email!.toString(),
                style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ),
              const SizedBox(
                height: 30,
              ),
              _logout(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _logout(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0D6EFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: () async {
        await AuthService().signout(context: context);
        Navigator.pushReplacementNamed(context, '/login');
      },
      child: const Text("Sign Out"),
    );
  }
}
