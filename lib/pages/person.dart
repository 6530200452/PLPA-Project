import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:noteapp/Logins/login_screen.dart';

class Person extends StatefulWidget {
  const Person({super.key});

  @override
  _PersonState createState() => _PersonState();
}

class _PersonState extends State<Person> {
  User? user = FirebaseAuth.instance.currentUser;

  void updateUser() {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 65,
              backgroundColor: Colors.yellow[300],
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/profile.png'),
              ),
            ),
            SizedBox(height: 20),
            Text(
              user?.displayName ?? 'No Name',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.yellow[800],
              ),
            ),
            SizedBox(height: 10),
            Text(
              user?.email ?? 'No Email',
              style: TextStyle(fontSize: 18, color: Colors.yellow[700]),
            ),
            SizedBox(height: 20),
            Divider(thickness: 1.5, color: Colors.grey[400]),
            Card(
              margin: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.settings, color: const Color.fromARGB(255, 252, 118, 0)),
                    title: Text(
                      'Change Name',
                      style: TextStyle(fontSize: 18, color: const Color.fromARGB(255, 255, 119, 0)),
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  SettingsScreen(updateUser: updateUser),
                        ),
                      );
                      setState(() {});
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.red[700]),
                    title: Text(
                      'Logout',
                      style: TextStyle(fontSize: 18, color: Colors.red[700]),
                    ),
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final VoidCallback updateUser;

  const SettingsScreen({Key? key, required this.updateUser}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = user?.displayName ?? '';
    _emailController.text = user?.email ?? '';
  }

  Future<void> _updateProfile() async {
    if (user != null) {
      await user!.updateDisplayName(_nameController.text);
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'name': _nameController.text,
        'email': _emailController.text,
      }, SetOptions(merge: true));

      widget.updateUser();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile Updated Successfully'),
          backgroundColor: Colors.yellow[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text(
          'Change Name',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.yellow[700],
        elevation: 4,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellow[800],
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: Colors.yellow[800]),
                      prefixIcon: Icon(Icons.person, color: Colors.yellow[800]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.yellow[800]),
                      prefixIcon: Icon(Icons.email, color: Colors.yellow[800]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    enabled: false,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _updateProfile,
                      icon: Icon(Icons.save, color: Colors.white),
                      label: Text('Save Changes'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow[700],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
